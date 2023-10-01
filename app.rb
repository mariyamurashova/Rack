require_relative 'time_formatter'

class App

  def call(env)
    request = Rack::Request.new(env) 
    if request_correct?(request)
      time_formatter = TimeFormatter.new(request.query_string)
      create_response_to_valid_or_invalid_requests(time_formatter, request)
    else
      create_response(404, ["Page not found"])
    end     
  end

private

  def request_correct?(request)
    request.path =="/time" && request.request_method == "GET"
  end

  def create_response(status, body)
    response = Rack::Response.new(body, status, {'Content-Type' => 'text/plain'})
    response.finish
  end

  def create_response_to_valid_or_invalid_requests(time_formatter, request)
    if time_formatter.query_valid?(request.query_string)
      create_response(200, time_formatter.format_date)
    else 
      create_response(400, ["Unknown time format: #{time_formatter.invalid_words.join(" ")}"])
    end
  end
  
end
