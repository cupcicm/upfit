require 'nokogiri'

require_relative 'st'

class FileType
  attr_reader :name

  # Initializes a FileType.
  # Name is a unique name for the type.
  # Processor is the processor that should be used for this file.
  def initialize(name, processor)
    @name = name
    @processor = processor
  end

  def process_with
    return @processor
  end
end



class FileTypes
  @@SPORTS_TRACKER_GPX = FileType.new('st', SportsTrackerProcessor.new)
  @@DEFAULT_GPX = FileType.new('gpx', DoNothingProcessor.new)
  @@TCX_FILE = FileType.new('tcx', DoNothingProcessor.new)

  def self.detect(file)
    ext = File.extname(file)
    case ext
      when '.tcx'
        return @@TCX_FILE
      when '.gpx'
        xml = Nokogiri::XML(File.read(file))
        link = xml.xpath('//xmlns:link')
        if link.nil? or link.first.nil?
          return @@DEFAULT_GPX
        end
        if link.first.attr('href') == 'www.sports-tracker.com'
          return @@SPORTS_TRACKER_GPX
        else
          return @@DEFAULT_GPX
        end
      else
        return nil
    end
  end
end