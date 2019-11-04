require 'time'
require 'slack'
require 'yaml'
require 'redis'

Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
  if config.token == ''
    STDERR.puts "must be set SLACK_TOKEN\n"
    exit(1)
  end
end

if ENV['REDIS_URL'] == ''
  STDERR.puts "must be set REDIS_URL\n"
  exit(1)
end

if ENV['NUM_MAX_GROUP'] == ''
  $MAX_GROUP = 3
else
  $MAX_GROUP = ENV['NUM_MAX_GROUP']
end


def post_slack_messeage(subject)
  # post slack messeage

  Slack.chat_postMessage(
    channel: ENV['SLACK_CHANNEL'],
    username: 'bot',
    text: subject,
    icon_url: 'http://2.bp.blogspot.com/-c1dEoxGvncY/UYzZhH-nugI/AAAAAAAAR7c/GJ1mk-SovxU/s400/oosouji_soujiki.png'
  )
end

def get_current_num()
  # get current number from file
  redis = Redis.new(url: ENV['REDIS_URL'])

  ng = redis.get 'next_group'
  return ng
end

def write_count(num)
  # write current num
  redis = Redis.new(url: ENV['REDIS_URL'])

  redis.set 'next_group', num
  return nil
end

def increment(num_today)
  # return next num
  num_today = num_today.to_i

  if num_today == $MAX_GROUP
    return 1
  else
    return num_today += 1
  end
end

def check_lab_cleaner()
  begin
    today = Time.now
  
    if today.strftime('%w') == '5'
      # if today Friday
      count = get_current_num
      subject = today.strftime('%x') + "\nToday is Friday!\n" + "Today cleaner group is " + count
  
      post_slack_messeage(subject)
  
      num_next = increment(count)
      write_count(num_next)
    else
      # if today not Friday
      # do nothing
    end
  rescue => e
    post_slack_messeage(e)
  end
end
