
# Interpretador da linguagem do PowerArm
class LangEngine
  constructor: () ->
    @api = {}
    alfa = '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split ''
    num = '0123456789'.split ''
    @pattern =
      alfa: alfa
      num: num
      math: ['+', '-', '*', '/', '**', '%', '(', ')']
      logic: ['&&', '||', '(', ')', '!']
      comment: ['#']
      text: ['"', "'"]
      attrib: ['=', '+=', '-=', '*=', '/=', '%=']
      command: ['(', ')']
      blank:  [" ", "\t"]
      alfanum: alfa.concat num
  addFunction: (name, f) ->
    @api[name] = f
  getLevel: (l) ->
    s = /^(\ *)(.*)/.exec l
    if s % 2 is 0
      return Math.floor(s/2)
    else
      return -1
  exec: (l) ->
    level = @getLevel(l)
    l.trim()
    # Estado da máquina da linguagem
    # 0 - inicial, esperando alfabético
    # 1 - recebe uma ou mais letras (opcional)
    # 2 - recebe abre-parêntese, chamada de função
    # 3 - recebe fecha-parêntese, fim de comando bem-sucedido
    # 4 - comentário
    state = 0
    aux = ''
    for i of l.split ''
      c = l[i]
      switch state
        when 0
          if @pattern.alfa.indexOf(c) >= 0
            aux = c
            state = 1
          else
            return -1
        when 1
          if @pattern.alfanum.indexOf(c) >= 0
            aux += c
          else if c is @pattern.comment[0]
            state = 4
          else if c is @pattern.command[0]
            state = 2
          else
            return -1
        when 2
          if c is @pattern.command[1]
            state = 3
          else
            return -1
      if state is 3
        if @api[aux]
          @api[aux].call()
        else
          console.log 'Comando não conhecido'
