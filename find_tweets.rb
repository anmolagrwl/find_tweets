require 'yaml'
require 'tweetstream'
require 'dino'
require 'time'
 
auth = YAML::load_file("twitter_api_config.yml")
 
TweetStream.configure do |config|
    config.consumer_key       = auth["consumer_key"]
    config.consumer_secret    = auth["consumer_secret"]
    config.oauth_token        = auth["oauth_token"]
    config.oauth_token_secret = auth["oauth_token_secret"]
end

desc 'Streamming tweets'  
task :tweet_stream => [:environment] do  
  TweetStream.configure do |config|
    config.consumer_key = 'your-consumer'
    config.consumer_secret = 'your-secret'
    config.oauth_token = 'your-token'
    config.oauth_token_secret = 'your-tsecret'
    config.auth_method        = :oauth
  end

  stream(["Pink Floyd", "Led Zeppelin", "The  Beatles"])
end  

def stream(tracked)  
  tracked.each do |track|
    tweets = 0
    TweetStream::Client.new.track(track) do |t|
      tweets += 1
      if tweets > 1000
        break
      else
        Tweet.create(:text => t.text)
    end      
  end
end  

# We can also build something to save an amount X of tweets, about a subject Y, from time to time Z.

# def stream(tracked, amount, time)  
#   tweets = 0
#   TweetStream::Client.new.track(tracked) do |t|
#     break if tweets > amount
#     tweets += 1
#     Tweet.create(:text => t.text)
#   end

#   sleep(time)
#   stream(tracked, amount, time)
# end 