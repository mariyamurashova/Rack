class DateFormat

  def initialize(app)
    @app = app  
  end

  def call(env)
    if request_path_and_query_present?(env)
      status, headers, body = @app.call(env)
      body = create_body_response(get_query(env))
      status = 200
      status = 400 if @errors.count != 0

      return [status, headers, body]
    else
      status, headers, body = @app.call(env)
    end
end

private

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
      body = ["Unknown time format #{@errors}"]
    end
  end
return [body]
end

end

