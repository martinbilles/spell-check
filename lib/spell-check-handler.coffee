SpellChecker = require 'spellchecker'
_ = require 'underscore-plus'

wordRegex = /(?:^|[\s\[\]"'])([a-zA-Z]+([a-zA-Z']+[a-zA-Z])?)(?=[\s\.\[\]:,"']|$)/g
whichRegex = /[^,]\swhich(?=[\s\.\[\]:,"']|$)/g
thatRegex = /,\sthat(?=[\s\.\[\]:,"']|$)/g

firstToUpper = (str) ->
  str.charAt(0).toLocaleUpperCase() + str.slice(1)

firstToLower = (str) ->
  str.charAt(0).toLocaleLowerCase() + str.slice(1)

module.exports = ({id, text, ignored}) ->
  row = 0
  misspellings = []
  for line in text.split('\n')
    while matches = wordRegex.exec(line)
      word = matches[1]
      continue if _.contains(ignored, word)
      continue if _.contains(ignored, firstToUpper(word))
      continue if _.contains(ignored, firstToLower(word))
      continue unless SpellChecker.isMisspelled(word)

      startColumn = matches.index + matches[0].length - word.length
      endColumn = startColumn + word.length
      misspellings.push([[row, startColumn], [row, endColumn]])
    while matches = whichRegex.exec(line)
      word = matches[0]
      startColumn = matches.index + matches[0].length - word.length
      endColumn = startColumn + word.length
      misspellings.push([[row, startColumn], [row, endColumn]])
    while matches = thatRegex.exec(line)
      word = matches[0]
      startColumn = matches.index + matches[0].length - word.length
      endColumn = startColumn + word.length
      misspellings.push([[row, startColumn], [row, endColumn]])

    row++
  {id, misspellings}
