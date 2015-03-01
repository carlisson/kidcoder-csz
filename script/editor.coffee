# Copiado de novel, falta adaptar, criar os estilos, etc
# Passo 2: criar classe editor, que será extendida para Cabin, MemEditor (editor para salvar comportamentos nos slots) e Puzzle

# Cenas que utilizam a PowerArm.
class PAScene extends Element
  constructor: (@id) ->
    super @id
    @engine = new LangEngine()
    @dom.addClass "cabin-session"
    @shell = new Element(@id + "-cshell")
    @shell.dom.addClass "cabin-shell"
    @shell.hide()
    @history = $ "<ul/>", {id: @id + "-cshistory"}
    @history.addClass "cabin-shell-history"
    @history.hide()
    @input = $ "<input/>", {id: @id + "-csinput"}
    @input.addClass "cabin-shell-input"
    @input.hide()
    @input.on 'keypress', (k) =>
      if k.key is 'Enter'
        @eval()
    @help = new Element(@id + "-chelp")
    @help.dom.addClass "cabin-help"
    @help.hide()
    @commarea = $ "<ul/>", {id: @id + "-ccomm"}
    @commarea.addClass "cabin-comm"
    @commarea.hide()
    @arena = new Element(@id + "-carena")
    @arena.dom.addClass "cabin-arena"
    @arena.hide()
    @session = false
    @next = false
  activate: (mother) ->
    super mother
    @shell.activate mother
    mother.append @history
    mother.append @input
    @help.activate mother
    mother.append @commarea
    @arena.activate mother
    ea = @engine.getApi()
    for f of ea
      fl = $ "<li/>", {'class': "help-function"}
      fl.append ea[f]
      @commarea.append fl
    @hide()
  echo: (msg) ->
    li = $ '<li/>'
    li.append msg
    @history.append li
  eval: () ->
    @echo @input.val()
    exe = @engine.exec @input.val()
    switch exe
      when KC_FALSE
        @echo "Comando desconhecido"
      when KC_TRUE
        console.log "Comando bem-sucedido"
      else
        @echo exe
    @input.val ''
  turnOn: () ->
    @show()
    @shell.show()
    @history.show()
    @input.show()
    @help.show()
    @commarea.show()
    @arena.show()
  turnOff: () ->
    @shell.hide()
    @history.hide()
    @input.hide()
    @help.hide()
    @commarea.hide()
    @arena.hide()
    @hide()
  clear: () ->
    @shell.val ''
  run: (actual, next) ->
    @session = actual
    @next = next
    @turnOn()
    keyMonitor.pushState @mapKeypress
  mapKeypress: (k) =>
    if k.key in ['Esc']
      console.log 'Sai'
      keyMonitor.popState()
      @turnOff()
      @session = @next
    else
      console.log 'Espera'


# Editor de código para Puzzle
class PuzzleScene extends PAScene
  constructor: (@id) ->
    super @id
    @states = []
    @actual = 0
    @engine.addFunction "date", "Imprime a data atual", () =>
      aux = new Date()
      @echo aux.toGMTString()
      return KC_TRUE
  addState: (s) ->
    @states.push s
  setState: (i) ->
    @actual = i
  updateState: () ->
    @arena.dom.css 'background-image', "url(" + @states[@actual] + ")"
  run: (actual, next, st = 0) ->
    super actual, next
    @setState st
    @updateState()
    @input.focus()
  mapKeypress: (k) =>
    if k.key in ['Esc']
      @actual += 1;
      if @actual < @states.length
        @updateState()
      else
        @actual = 0
        keyMonitor.popState()
        @turnOff()
        @session = @next
    else
      console.log 'Espera'

# Editor de código em tempo real para combate
class CabinScene extends PAScene
  constructor: (@id) ->
    super @id
