require 'mail'

require_relative '../upload/base'

# Uploads workout to strava.com as described here
# https://strava.zendesk.com/entries/20950143-Uploading-to-Strava-Website
# (sends an email to upload@strava.com)
class StravaUploader

  # Strava uploaders that uploads workout for the
  # username in from.
  # options are the smtp send options.
  def initialize(from, options)
    @from = from
    @options = options
  end

  def upload(file)
    options = @options
    from = @from
    mail = Mail.new do
      to 'upload@strava.com'
      from from
      subject 'Activity report'
      add_file :filename => file
      delivery_method :smtp, options
    end
    mail.deliver!
  end
end
