###############################################################################
# Declarations
###############################################################################
CHUNK_SIZE = 3
UNDER_TWENTY_WORDS = %W(#{""} one two three four five six seven eight nine ten eleven
  twelve thirteen fourteen fifteen sixteen seventeen eightteen nineteen)
TENS_WORDS = %W(#{""} #{""} twenty thirty fourty fifty sixty seventy eighty ninety)
MAGNITUDE_WORDS = %W(#{""} thousand million billion trillion quadrillion 
  uintillion sextillion septillion octillion nonillion decillion undecillion 
  duodecillion tredecillion quattuordecillion quindecillion sexdecillion 
  septendecillion octodecillion novemdecillion vigintillion centillion)
INVALID_ARGS_MSG = "Invalid arguments. Please provide a single integer argument."

###############################################################################
# Helpers
###############################################################################
# Returns true if first command line argument is parsable as an integer
def args_are_valid
  begin
    Integer(eval(ARGV[0]))
    return true
  rescue
    return false
  end
end

# Returns spelled out number for 3 digit decimal number passed as string
def spelled_out_three_digit_num(three_digit_num_string, use_and_separator)
  return "" if three_digit_num_string == "000"

  ones = Integer(three_digit_num_string[2])
  tens = Integer(three_digit_num_string[1])
  hundreds = Integer(three_digit_num_string[0])
  under_100 = (tens * 10) + ones

  after_hundreds_separator = (hundreds > 0 && under_100 > 0) ? " " : ""
  after_tens_separator = (tens > 1 && ones > 0) ? " " : ""

  spelled_out = use_and_separator ? "and " : ""

  # Set up under 100 name
  if under_100 < 20 
    spelled_out += UNDER_TWENTY_WORDS[under_100]
  else
    spelled_out += TENS_WORDS[tens] + after_tens_separator + UNDER_TWENTY_WORDS[ones]
  end

  # Set up hundreds
  if hundreds > 0 
    spelled_out.prepend(UNDER_TWENTY_WORDS[hundreds] + " hundred" + after_hundreds_separator)
  end

  spelled_out
end

# Breaks num_string into 3 digit chunks. Prepends 0s to make string
# a multiple of 3 chars long if necessary
def break_into_three_digit_chunks(num_string)
  zeros_to_append = num_string.size % CHUNK_SIZE == 0 \
                    ? 0 \
                    : CHUNK_SIZE - (num_string.size % CHUNK_SIZE) 
  zeros_to_append.times { num_string.prepend("0") }
  num_string.scan(/.../)
end

# Accepts a string which must be equivalent to a valid integer literal and returns
# a string with the number spelled out.
def spelled_out_number(num_string)
  #Make sure we are working with a decimal equivalent string with no prepended 0s
  #This allows us to work with input like "-0xaabb", "0b001_001" or "0000045" 
  cleaned_decimal_num_string = Integer(eval(num_string)).to_s
  num_is_negative = (cleaned_decimal_num_string.to_i < 0)
  cleaned_decimal_num_string[0] = '' if num_is_negative

  # Handle 0
  return "zero" if cleaned_decimal_num_string == "0"

  #Break into 3 digit chunks and reverse so index matches magnitude
  chunks = break_into_three_digit_chunks(cleaned_decimal_num_string).reverse 
  index_of_smallest_non_zero_chunk = chunks.index {|chunk| chunk != "000"}

  # Cycle through each chunk prepending the chunk's spelled out string
  spelled_out = chunks.each_with_index.inject("") do |str, (chunk, index)|
    this_chunk_string = ""
    unless chunk == "000"
      use_and_separator = (index == 0 && chunks.size > 1 && chunks[0][1..2] != "00")
      use_magnitude_word = (index > 0)
      use_comma_separator_at_end = (index_of_smallest_non_zero_chunk < index \
                                    && !str.match(/^ and/))
      this_chunk_string << spelled_out_three_digit_num(chunk, use_and_separator)
      this_chunk_string << " " + MAGNITUDE_WORDS[index] if use_magnitude_word
      this_chunk_string << ", " if use_comma_separator_at_end
    end
    str.prepend(this_chunk_string)
  end

  # Handle negative and return
  (num_is_negative ? "negative " : '') + spelled_out
end

###############################################################################
# Main
###############################################################################
def main
  abort(INVALID_ARGS_MSG) unless args_are_valid
  puts spelled_out_number(ARGV[0].dup) #dup because we need an unfrozen string
end

if __FILE__ == $0
  main
end


