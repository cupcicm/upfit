require 'mail'
require 'test/unit'

require_relative 'strava'
require_relative '../testing/email'


class StravaUploaderTest < Test::Unit::TestCase

  def setup
    @uploader = StravaUploader.new('test@gmail.com',
                                   {:port => 2525})
    @server = TestMailServer.new
    @server.start
  end

  def teardown
    @server.shutdown
    @server.stop
    @server.join
  end

  def test_can_send_email
    @uploader.upload('testdata/attachment.txt')
    assert(@server.messages.empty? == false)
    @server.messages.each do |message|
        assert_equal('<test@gmail.com>', message[:from])
    end
  end
end
