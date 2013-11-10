#!/usr/bin/env ruby

require 'daemons'
require 'fileutils'
require 'tempfile'

require_relative 'input/listen'
require_relative 'upload/strava'
require_relative 'process/types'


def load_config
  yaml = YAML.load_file 'config.yml'
  # Transform keys to symbols (looks better when getting config options).
  return Hash[yaml.map{|(k,v)| [k.to_sym,v]}]
end

def main(dir)
  Dir.chdir dir
  config = load_config
  uploader = StravaUploader.new(config[:username],
                                config[:smtp_options])
  listener = DirectoryListener.new(config[:watchdir]) do |files|
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
  stopped = false
  dir = File.expand_path File.dirname(__FILE__)
  Daemons.run_proc('upfit') do
    main dir
    sleep 10 until stopped
  end
end
