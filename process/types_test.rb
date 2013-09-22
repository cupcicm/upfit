require 'test/unit'

require_relative 'types'


class TypeDetectorTest < Test::Unit::TestCase

  def test_detect_gpx
    assert_equal FileTypes::detect('testdata/strava.gpx').name, 'gpx'
  end

  def test_detect_tcx
    assert FileTypes::detect('testdata/cycling.tcx').name == 'tcx'
  end

  def test_detect_junk
    assert FileTypes::detect('testdata/attachment.txt').nil?
  end

  def test_detect_sportstracker
    assert_equal FileTypes::detect('testdata/st.gpx').name, 'st'
  end

end