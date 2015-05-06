# Arquivo de apoio, com classes, funções e variáveis amplamente utilizadas pelo jogo.

KC_TRUE = "ByewgEp6"
KC_FALSE = "syg3Glyrecs"

# Elemento gráfico do jogo
class Element
  # Deve definir @dom como construtor do correspondente ao elemento no DOM
  constructor: (@id) ->
    @dom = $("<div/>", {id: @id})
  # Vincula o elemento @dom a um elemento mãe. Dá outros procedimentos que
  # devam ser feito somente após o DOM da página estar pronto.
  activate: (mother) ->
    mother.append @dom
  # Desloca o elemento para a nova posição.
  show: () ->
    @dom.show()
  hide: () ->
    @dom.hide()
  slide: (x, y) ->
    @dom.animate({
      translate3d: x + 'px,' + y + 'px,0'
    }, 500, 'linear')

# Controlador de eventos de teclado
class InternalKeyMonitor
  constructor: () ->
    @stack = []
  pushState: (f) ->
    if @stack.length > 0
      $(document).off 'keypress', @stack[@stack.length - 1]
    @stack.push(f)
    $(document).on 'keypress', @stack[@stack.length - 1]
  popState: () ->
    if @stack.length > 0
      $(document).off 'keypress', @stack.pop()
    if @stack.length > 0
      $(document).on 'keypress', @stack[@stack.length - 1]
  clear: () ->
    @stack = []
keyMonitor = new InternalKeyMonitor()
###
initApi = (interpreter, scope) ->
  # Add an API function for the alert() block.
  wrapper = (text) ->
    text = text if text.toString() else ''
    return interpreter.createPrimitive alert text

  interpreter.setProperty scope, 'alert', interpreter.createNativeFunction(wrapper)

  # Add an API function for the prompt() block.
  wrapper = (text) ->
    text = text if text.toString() else ''
    return interpreter.createPrimitive prompttext

  interpreter.setProperty scope, 'prompt', interpreter.createNativeFunction(wrapper)

run_code = () ->
  code = Blockly.JavaScript.workspaceToCode()
  myInterpreter = new Interpreter code, initApi
  myInterpreter.run()
###
