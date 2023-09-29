require_relative 'time_formatter'

class App

QUERY_WORDS = ["year", "month", "day", "hour", "minute", "second"]

  def call(env)
    if request_path_present?(env) && request_query_present?(env)
      status, body = response_status_body(env)
    else
      status= 404
      body = ["Page not found"]
    end
     return status, headers, body
  end

private

  def response_status_body(env)
    if request_query_correct?(env)
      status = 200
      @time_formatter = TimeFormatter.new
      body = @time_formatter.call(@query)
    else
      status = 400
      body = ["Unknown time format #{@errors}"]
    end
    
    return status, body
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def request_path_present?(env)
    env["REQUEST_PATH"] == "/time" 
  end

  def request_query_present?(env)
    env["QUERY_STRING"] != "" 
  end

  def get_query_from_request(env)
    query = Rack::Utils.parse_query URI(env["REQUEST_URI"]).query
    @query = query["format"].split(",")
  end

  def request_query_correct?(env)
    @errors = [ ]
    get_query_from_request(env)
    @query.each do |query_word|
      @errors << query_word if !QUERY_WORDS.include?(query_word) 
    end
    return true if @errors.count == 0
  end
  
end
