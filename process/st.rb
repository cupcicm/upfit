require 'date'
require 'nokogiri'
require 'tzinfo'

require_relative 'base'


# Processes a GPX file that was downloaded from sports-tracker.com
class SportsTrackerProcessor < Processor

  def get_offset(date)
    tz = TZInfo::Timezone.get('Europe/Paris')
    tz.period_for_utc(date).utc_total_offset / 3600
  end

  def convert_date(string_date)
    date = DateTime.iso8601(string_date)
    date = date.new_offset(Rational(-get_offset(date), 24))
    return date.strftime('%Y-%m-%dT%H:%M:%S.%2NZ')
   end

  def process(data)
    xml = Nokogiri::XML(data)
    xml.xpath('//xmlns:name').first.content = xml.xpath('//xmlns:desc').text
    xml.xpath('//xmlns:time').each do |xml|
      xml.content = convert_date(xml.content)
    end
    return xml.to_xml
  end
end