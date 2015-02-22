
# Interpretador da linguagem do PowerArm
class LangEngine
  constructor: () ->
    @api = {}
    ###
    @patterns =
      alfa: '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
      num: '0123456789'
      math: ['+', '-', '*', '/', '**', '%', '(', ')'
      logic: ['&&', '||', '(', ')', '!']
      comment: '#'
      text: ['"', "'"]
      attrib: ['=', '+=', '-=', '*=', '/=', '%=']
      command: '()'
      blank =  " \t"
    @patterns['alfanum'] = @patterns['alfa'] + @patterns['num']
    for p of ['alfa', 'num', 'alfanum', 'comment', 'command', 'blank']
      @patterns[p] = @patterns[p].split ''
    ###
  addFunction: (name, f) ->
    @api[name] = f
  getLevel: (l) ->
    s = 0
    for c of l.split('')
      if l[c] is ' '
        s += 1
      else
          break
    if s % 2 is 0
      return Math.floor(s/2)
    else
      return -1
  exec: (l) ->
    level = @getLevel(l)
    l.trim()
