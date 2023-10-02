class TimeFormatter

  VALID_WORDS = ["year", "month", "day", "hour", "minute", "second"]
  DATE_FORMATTER = {"year" => "%Y", "month" =>"%b", "day" =>"%d", "hour" => "%H", "minute" => "%M", "second" => "%S" }

  attr_accessor :invalid_words, :valid_words, :query

  def initialize(query)
    @invalid_words = [ ]
    @valid_words = [ ]
    @query = Rack::Utils.parse_nested_query(query).values
  end

  def call
    converted_request_query
    get_valid_and_invalid_words
  end

  def converted_request_query
    @query = @query[0].split(",")
  end

  def query_valid?
    @invalid_words.empty? && !@valid_words.empty?
  end

  def get_valid_and_invalid_words
    @query.each do |query_word|
      if VALID_WORDS.include?(query_word)
        @valid_words << DATE_FORMATTER[query_word]
      else  
        @invalid_words << query_word
      end 
    end
  end

  def format_date
    Time.now.strftime(@valid_words.join(" "))
  end

  def string_for_date_conversion
    @valid_words.map do |word|
      word  = DATE_FORMATTER[word] 
    end
  end
  
end
