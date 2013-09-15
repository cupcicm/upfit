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
    sleep 0.2
    assert(@server.messages.empty? == false)
    @server.messages.each do |message|
        assert_equal('test@gmail.com', message.from[0])
        message.attachments.each do |attachment|
          # We should have renamed attachment.txt to something else.
          assert !(attachment.filename.include? "attachment")
          # But keeping the extension is important.
          assert attachment.filename.end_with?('.txt')
        end
    end
  end
end