# Copiado de novel, falta adaptar, criar os estilos, etc
# Passo 2: criar classe editor, que será extendida para Cabin, MemEditor (editor para salvar comportamentos nos slots) e Puzzle

# Editor de código em tempo real.
class Cabin extends Element
  constructor: (@id) ->
    super @id
    @dom.addClass "cabin-session"
    @shell = new Element(@id + "-cshell")
    @shell.dom.addClass "cabin-shell"
    @shell.hide()
    @help = new Element(@id + "-chelp")
    @help.dom.addClass "cabin-help"
    @help.hide()
    @commarea = new Element(@id + "-ccomm")
    @commarea.dom.addClass "cabin-comm"
    @commarea.hide()
    @arena = new Element(@id + "-carena")
    @arena.dom.addClass "cabin-arena"
    @arena.hide()
    @session = false
  activate: (mother) ->
    super mother
    @shell.activate mother
    @help.activate mother
    @commarea.activate mother
    @arena.activate mother
    @hide()
  turnOn: () ->
    @show()
    @shell.show()
    @help.show()
    @commarea.show()
    @arena.show()
  turnOff: () ->
    @shell.hide()
    @help.hide()
    @commarea.hide()
    @arena.hide()
    @hide()
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

