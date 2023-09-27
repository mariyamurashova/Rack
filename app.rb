class App

  def call(env)
    return [status, headers, body]
  end

private

  def status
    status = 404
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def body
    ["Page not found"]
  end

end
