# A standard output is recorded in the log file.
# If an error occurs, cron will send mail to you.
set :output, :standard => Rails.root + 'log/cron.log'

every 1.hour do
  rake 'headline:fetch'
  rake 'twitter:wash_whale'
end
