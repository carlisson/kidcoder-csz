
# Interpretador da linguagem do PowerArm
class LangEngine
  constructor: () ->
    @api = {}
  addFunction: (name, f) ->
    @api[name] = f
  getLevel: (l) ->
    s = 0
    for c in l
      console.log 'Avaliando ' + c + ' de ' + l
      if c is ' '
        s += 1
      else
        break
    if s % 2 is 0
      return Math.floor(s/2)
    else
      return -1
  exec: (l) ->
    console.log @getLevel(l) + ' - executarei.'
