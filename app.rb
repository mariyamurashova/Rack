require_relative 'time_formatter'

class App

QUERY_WORDS = ["year", "month", "day", "hour", "minute", "second"]

  def call(env)
    if request_path_present?(env) && query_present?(env)
      status = status(env)
      body = body(env) 
    else
      status= 404
      body = ["Page not found"]
    end
     return status, headers, body
  end

private

  def status(env)
    check_query_correctness(env)
      if @errors.count == 0
        return status = 200
      else
        return status = 400
      end
  end

  def body(env)
    if @errors.count != 0
      body = ["Unknown time format #{@errors}"]
    else 
      @time_formatter = TimeFormatter.new
      body = @time_formatter.call(@query)
    end
    return body
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def request_path_present?(env)
    env["REQUEST_PATH"] == "/time" 
  end

  def query_present?(env)
    env["QUERY_STRING"] != "" 
  end

  def get_query_from_request(env)
    query = Rack::Utils.parse_query URI(env["REQUEST_URI"]).query
    @query = query["format"].split(",")
  end

  def check_query_correctness(env)
    @errors = [ ]
    get_query_from_request(env)
    @query.each do |query_word|
    @errors << query_word if !QUERY_WORDS.include?(query_word) 
  end
end
  
end
