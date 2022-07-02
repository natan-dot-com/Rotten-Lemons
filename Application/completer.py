import readline, sys
from os import environ

# Source: https://stackoverflow.com/questions/20625642/autocomplete-with-readline-in-python3

class Completer:  # Custom completer
  def __init__(self, options):
    self.options = sorted(options)

  def complete(self, text, state):
    if state == 0:  # on first trigger, build possible matches
      if not text:
        self.matches = self.options[:]
      else:
        self.matches = [s for s in self.options
                        if s and s.startswith(text)]

    # return match indexed by state
    try:
      return self.matches[state]
    except IndexError:
      return None

  def display_matches(self, substitution, matches, longest_match_length):
    line_buffer = readline.get_line_buffer()
    columns = environ.get("COLUMNS", 80)

    print()

    buffer = ""
    for match in matches:
      match = f"{match:<{int(max(map(len, matches)) * 1.2)}}"
      if len(buffer + match) > columns:
        print(buffer)
        buffer = ""
      buffer += match

    if buffer:
      print(buffer)

    print("> ", end="")
    print(line_buffer, end="")
    sys.stdout.flush()