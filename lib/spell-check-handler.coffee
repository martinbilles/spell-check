SpellChecker = require 'spellchecker'
_ = require 'underscore-plus'

wordRegex = /(?:^|[\s\[\]"'])([a-zA-Z]+([a-zA-Z']+[a-zA-Z])?)(?=[\s\.\[\]:,"']|$)/g

module.exports = ({id, text, ignored}) ->
  row = 0
  misspellings = []
  for line in text.split('\n')
    while matches = wordRegex.exec(line)
      word = matches[1]
      continue if _.contains(ignored, word)
      continue unless SpellChecker.isMisspelled(word)

      startColumn = matches.index + matches[0].length - word.length
      endColumn = startColumn + word.length
      misspellings.push([[row, startColumn], [row, endColumn]])
    row++
  {id, misspellings}
