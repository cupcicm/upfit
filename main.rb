#!/usr/bin/env ruby

require 'daemons'
require 'fileutils'
require 'tempfile'

require_relative 'input/listen'
require_relative 'upload/strava'
require_relative 'process/types'


def main()
  eval(File.new('config.rb').read())
  uploader = StravaUploader.new(UpfitConfig[:username],
                                UpfitConfig[:smtp_options])
  DirectoryListener.new(UpfitConfig[:watchdir]) do |files|
    files.each do |file|
      type = FileTypes.detect(file)
      if type.nil?
        puts "Skipping #{file}."
        next
      end
      processor = type.processor
      if processor.nil?
        puts "Skipping #{file}"
        next
      end
      ext = File.extname(file)
      temp = Tempfile.new(['activity', ext])
      data = File.read(file)
      data = processor.process(data)
      temp.write(data)
      puts "Uploading #{file} to strava..."
      uploader.upload(file)
      FileUtils.touch("#{file}.uploaded")
      temp.close
      temp.unlink
    end
  end
end

if __FILE__ == $0
  Daemons.run_proc('upfit') do
    main
  end
end