require 'rack'
require_relative 'middleware/date_format'
require_relative 'app'

use DateFormat
run App.new
