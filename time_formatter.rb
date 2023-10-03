class TimeFormatter

  DATE_FORMATTER = {"year" => "%Y", "month" =>"%b", "day" =>"%d", "hour" => "%H", "minute" => "%M", "second" => "%S" }

  attr_accessor :invalid_words, :valid_words, :query

  def initialize(query)
    @invalid_words = [ ]
    @valid_words = [ ]
    @query = (Rack::Utils.parse_nested_query(query).values)[0].split(",")
  end

  def call
    get_valid_and_invalid_words
  end

  def query_valid?
    @invalid_words.empty? && !@valid_words.empty?
  end

  def get_valid_and_invalid_words
    @query.each do |query_word|
      if DATE_FORMATTER.keys.include?(query_word)
        @valid_words << DATE_FORMATTER[query_word]
      else  
        @invalid_words << query_word
      end 
    end
  end

  def format_date
    Time.now.strftime(@valid_words.join(" "))
  end
  
end
