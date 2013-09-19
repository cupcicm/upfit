require 'date'
require 'test/unit'

require_relative 'st'



class StProcessorTest < Test::Unit::TestCase

  def setup
    @data = open('testdata/st.gpx')
  end

  def test_can_parse
    st = SportsTrackerProcessor.new
    st.process(@data)
  end

  def test_convert_date_summer
    date = '2013-09-07T17:11:19.76'
    st = SportsTrackerProcessor.new
    assert_match '2013-09-07T15:11:19.76Z', st.convert_date(date)
  end

  def test_convert_date_winter
    date = '2013-12-07T17:11:19.76'
    st = SportsTrackerProcessor.new
    assert_match '2013-12-07T16:11:19.76Z', st.convert_date(date)
  end

  def test_get_offset
    date = DateTime.new(2013, 9, 7)
    st = SportsTrackerProcessor.new
    assert_equal 2, st.get_offset(date)
  end
end