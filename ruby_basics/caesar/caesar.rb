LOWER_CASE = ('a'..'z')
UPPER_CASE = ('A'..'Z')

def ascii_alpha?(char)
  lower_case?(char) || upper_case?(char)
end

def lower_case?(char)
  LOWER_CASE.include?(char)
end

def upper_case?(char)
  UPPER_CASE.include?(char)
end

def offset_ascii_with_wrap(char, offset)
  return LOWER_CASE.to_a[wrap_index(LOWER_CASE, char, offset)] if lower_case?(char)

  UPPER_CASE.to_a[wrap_index(UPPER_CASE, char, offset)]
end

def wrap_index(range, char, offset)
  array = range.to_a
  new_index = array.find_index(char) + offset
  if array.length - 1 >= new_index
    new_index
  else
    new_index - array.length
  end
end

def caesar(message, offset)
  message.split('').reduce('') do |acc, char|
    acc << if ascii_alpha? char
             offset_ascii_with_wrap(char, offset)
           else
             char
           end
  end
end
