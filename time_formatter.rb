class TimeFormatter

  VALID_WORDS = ["year", "month", "day", "hour", "minute", "second"]

  attr_accessor :invalid_words, :valid_words

  def initialize
    @invalid_words = [ ]
    @valid_words = [ ]
  end

  def query_valid?(query)
    query = get_query_from_request(query)
    if query.empty? 
      return false
    else
      get_valid_and_invalid_words(query)
      return true if @invalid_words.empty?
    end
  end

  def get_valid_and_invalid_words(query)
    query.each do |query_word|
      if VALID_WORDS.include?(query_word)
        @valid_words << query_word
      else  
        @invalid_words << query_word
      end 
    end
  end

  def get_query_from_request(query)
    request_query = Rack::Utils.parse_nested_query(query).values
    request_query=request_query[0].split(",")
  end

  def format_date
    Time.now.strftime(string_for_date_conversion.join(" "))
  end

  def string_for_date_conversion
    string_for_date_conversion = [ ]
    @valid_words.each do |word|
      case word
      when "year"
        string_for_date_conversion << "%Y"
      when "month"
        string_for_date_conversion << "%b"
      when "day"
        string_for_date_conversion << "%d"
      when "hour" 
       string_for_date_conversion << "%H"
      when "minute"
        string_for_date_conversion << "%M"
      when "second"
         string_for_date_conversion << "%S"
      end
    end
    return string_for_date_conversion
  end
  end
