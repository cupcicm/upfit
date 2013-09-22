require 'test/unit'
require 'tmpdir'

require_relative 'listen'


class DirectoryListenerTest < Test::Unit::TestCase

  def setup
    @dir = Dir.mktmpdir
    @added = 0
    @listener = DirectoryListener.new(@dir) do |added|
      @added += added.length
    end
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def touch(name)
    File.write "#{@dir}/#{name}", 'test'
  end

  def test_listen
    5.times do |i|
      sleep 0.1
      touch("foo#{i}")
    end
    6.upto(10) do |i|
      touch("foo#{i}")
    end
    sleep 0.5 until @added == 10
    assert_equal 10, @added
  end

  def test_dont_report_modifies
    touch('foo')
    5.times do |i|
      touch('foo')
      sleep 0.1
    end
    6.upto(10) do |i|
      touch('foo')
    end
    sleep 0.5
    assert_equal 1, @added
  end

  def test_adds_in_subdir
    Dir.mkdir "#{@dir}/sub"
    touch('sub/foo')
    sleep 0.1 until @added == 1
    assert_equal 1, @added
  end
end