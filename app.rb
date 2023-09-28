class App

  def call(env)
    if request_path_and_query_present?(env)
      body = create_body_response(get_query(env))
      status = 200
      status = 400 if @errors.count != 0
    else
      status=404
      body = ["Page not found"]
    end
     return status, headers, body
  end

private

 def headers
  {'Content-Type' => 'text/plain'}
 end

def request_path_and_query_present?(env)
  env["REQUEST_PATH"] == "/time" && env["QUERY_STRING"] != ""
end

def get_query(env)
  query = Rack::Utils.parse_query URI(env["REQUEST_URI"]).query
  return query = (query["format"]).split(",")
end

def create_body_response(query)
  @errors = [ ]
  body = ""
  query.each do |w|
    case w 
      when "second"
        body = body+ "#{Time.now.sec}"+ " "
      when "minute"
        body = body+ "#{Time.now.min}"+ " "
      when "hour"
        body = body+ "#{Time.now.hour}"+ " "
      when "day"
        body = body+ "#{Time.now.day}"+ " "
      when "month"
        body = body+ "#{Time.now.month}" + " "
      when "year"
        body = body + "#{Time.now.year}" + " "
    else
      @errors << w
      body = "Unknown time format #{@errors}"
    end
  end
return [body]
end

end
