class TimeFormatter

  def call(query)
    @time = Time.now
    return format_date(query)
  end

  def create_hash_with_time_formats(query)
    @time_formats = { }
    query.each do |word|
      case word.to_sym
      when :year
        @time_formats[:year] ="%Y"
      when :month
        @time_formats[:month] ="%b"
      when :day
        @time_formats[:day] = "%d"
      when :hour 
       @time_formats[:hour ] ="%H"
      when :minute
        @time_formats[:minute] ="%M"
      when :second
         @time_formats[:second] ="%S"
      end
    end
  end

  def format_date(query)
    body = [ ]
    formated_time = " "
    create_hash_with_time_formats(query)
    query.each do |word|
      formated_time= formated_time + " " + "#{@time.strftime(@time_formats[word.to_sym])}"
    end
    body << formated_time
    return body
  end

  end
