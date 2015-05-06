# Cenas que utilizam a PowerArm.
class PAScene extends Element
  constructor: (@id) ->
    super @id
    @dom.addClass "cabin-session"
    @commarea = new Element(@id + "-ccomm")
    @commarea.dom.addClass "cabin-comm"
    @commarea.hide()
    @arena = new Element(@id + "-carena")
    @arena.dom.addClass "cabin-arena"
    @arena.hide()
    @panel = new Element(@id + "-cpanel")
    @panel.dom.addClass "cabin-panel"
    @panel.hide()
    @session = false
    @next = false
  activate: (mother) ->
    super mother
    @commarea.activate mother
    @arena.activate mother
    @panel.activate mother
    Blockly.inject $('#' + @id + '-ccomm')[0],
      toolbox: '<xml id="toolbox"><block type="controls_if"></block><block type="controls_repeat_ext"></block><block type="logic_compare"></block><block type="math_number"></block><block type="math_arithmetic"></block><block type="text"></block><block type="stuff_date"></block></xml>'
    @hide()
  echo: (msg) ->
    console.log 'Incompleto.'
  eval: () ->
    console.log 'Incompleto.'
  turnOn: () ->
    @show()
    @commarea.show()
    @arena.show()
    @panel.show()
  turnOff: () ->
    @commarea.hide()
    @arena.hide()
    @panel.hide()
    @hide()
  clear: () ->
    console.log 'Incompleto.'
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
  addState: (s) ->
    @states.push s
  setState: (i) ->
    @actual = i
  updateState: () ->
    @arena.dom.css 'background-image', "url(" + @states[@actual] + ")"
  run: (actual, next, st = 0) ->
    console.log 'Incompleto.'
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
