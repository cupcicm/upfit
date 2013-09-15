require 'mail'
require 'mini-smtp-server'

# A MiniSmtpServer that just stores the messages
# it receives in a list, and allows acces to it.
class TestMailServer < MiniSmtpServer

  attr_reader :messages

  def initialize
    super(2525, "127.0.0.1", 1)
    @messages = Array.new
  end

  def new_message_event(hash)
    mail = Mail.read_from_string(hash[:data])
    @messages.push(mail)
  end
end
