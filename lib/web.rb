$LOAD_PATH.unshift('./lib')

require 'json'
require 'webrick'

require 'lab-cleaner-checker'

def do_POST(input_text)
  if input_text.to_i < 1 or input_text.to_i > 4
    # validate
    body = {
      :username => 'bot',
      :text => 'invaild number'
    }.to_json
    return body
  end

  begin
    write_count(input_text)
    body = {
      :text => 'Set Next Group to ' + input_text,
      :username => 'bot',
    }.to_json
  rescue => e
    body = {
      :text => e,
      :username => 'bot',
    }.to_json
  end

  return body
end

def run_web()
  port = ENV['PORT'] || 8080
  s = WEBrick::HTTPServer.new(
    :Port => port,
    :HTTPVersion => WEBrick::HTTPVersion.new('1.1'),
    :AccessLog => [[open(IO::NULL, 'w'), '']] # アクセスログを出力しない
  )

  s.mount_proc('/cleaner') do |req, res|
    res['Content-Type'] = 'application/json'

    if req.request_method == 'GET' then
      ng = get_current_num()

      res.status = 200
      body = {
        :text => 'Next group is ' + ng,
        :username => 'bot',
        :response_type => 'in_channel'
      }.to_json

      res.body = body
    elsif req.request_method == 'POST' then
      res.status = 200
      input_text = req.query["text"]
      body = do_POST(input_text)

      res.body = body
    else
      res.status = 405
    end
  end

  Signal.trap('INT') {
    s.shutdown
  }
  s.start
end
