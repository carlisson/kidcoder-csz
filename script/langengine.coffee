
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
      attrib: ['='] #, '+=', '-=', '*=', '/=', '%=']
      command: ['(', ')']
      internal:
        'if': [':', 'then', 'else']
        'for': [':', 'in']
      blank:  [" ", "\t"]
      alfanum: alfa.concat num
  addFunction: (name, help, f) ->
    @api[name] = f
  getApi: () ->
    return Object.keys @api
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
    # 5 - epaço após alfa. Ou palavra reservada ou atribuição
    # 6 - recebe atribuição
    # 7 - recebe número como parâmetro de função
    # 8 - espera pelo fecha-parêntese, não aceitando mais parâmetro
    state = 0
    iau = 0
    aux = []
    for i of l.split ''
      c = l[i]
      console.log l + "[" + i + "] = " + c + "(" + state + ")"
      ikeys = Object.keys @pattern.internal
      switch state
        when 0
          if @pattern.alfa.indexOf(c) >= 0
            aux[iau] = c
            state = 1
          else
            return KC_FALSE
        when 1
          console.log state
          if @pattern.alfanum.indexOf(c) >= 0
            aux[iau] += c
          else if c is @pattern.comment[0]
            state = 4
          else if c is @pattern.command[0]
            iau += 1
            aux[iau] = ''
            state = 2
          else if @pattern.blank.indexOf(c) >= 0
            if ikeys.indexOf(aux[iau]) >= 0
              return 'Ainda não sei o que fazer com ' + aux[iau]
              iau += 1
              aux[iau] = ''
            else
              state = 5
          else if c is @pattern.attrib[0]
            state = 6
          else
            return KC_FALSE
        when 2
          console.log state
          if c is @pattern.command[1]
            state = 3
          else if @pattern.blank.indexOf(c) >= 0
            state = 2
          else if @pattern.num.indexOf(c) >= 0
            aux[iau] += c
            state = 7
          else
            return KC_FALSE
        when 5
          if c is @pattern.attrib[0]
            state = 6
        when 7
          if @pattern.num.indexOf(c) >= 0
            aux[iau] += c
          else if @pattern.blank.indexOf(c) >= 0
            state = 8
          else if c is @pattern.command[1]
            state = 3
          else
            return KC_FALSE
        when 8
          if @pattern.blank.indexOf(c) >= 0
            state = 8
          else if c is @pattern.command[1]
            state = 3
          else
            return KC_FALSE
      if state is 3
        console.log aux
        if @api[aux[0]]
          if aux[1].length > 0
            console.log "Chamando a função " + @api[aux[0]] + "com parâmetro " + aux[1]
            return @api[aux[0]].call(aux[1])
          else
            return @api[aux[0]].call()
        else
          console.log 'Comando não conhecido'
    return KC_FALSE
