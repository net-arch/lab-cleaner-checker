$LOAD_PATH.unshift('./lib')

require 'json'
require 'webrick'

require 'lab-cleaner-checker'

def run_web()
  port = ENV['PORT'] || 8080
  s = WEBrick::HTTPServer.new(
    :Port => port,
    :HTTPVersion => WEBrick::HTTPVersion.new('1.1'),
    :AccessLog => [[open(IO::NULL, 'w'), '']] # アクセスログを出力しない
  )

  s.mount_proc('/cleaner') do |req, res|
    ng = get_current_num()

    res.status = 200
    res['Content-Type'] = 'application/json'
    body = {
      :text => 'Next group is ' + ng,
      :username => 'bot',
      :response_type => 'in_channel'
    }.to_json

    res.body = body
  end


  Signal.trap('INT') {
    s.shutdown
  }
  s.start
end
