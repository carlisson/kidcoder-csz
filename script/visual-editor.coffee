# Cenas que utilizam a PowerArm.
class PAScene extends Element
  constructor: (@id) ->
    super @id
    @dom.addClass "code-scene"
    @blocks = new Element @id + '-blocks'
    @blocks.dom.addClass 'blockly'
    @arena = new Element @id + '-display'
    @arena.dom.addClass 'code-display'
    @panel = new Element @id + '-panel'
    @toolbox =
      toolbox: '<xml id="toolbox"><block type="controls_if"></block><block type="controls_repeat_ext"></block><block type="logic_compare"></block><block type="math_number"></block><block type="math_arithmetic"></block><block type="text"></block><block type="stuff_date"></block></xml>'
    @session = false
    @next = false
  show: () ->
    @dom.animate({
      translate3d: '0px,0px,0'
      opacity: 1.0
    }, 500, 'ease')
  hide: () ->
    @dom.animate({
      translate3d: '-810px,0px,0',
      opacity: 0.0
    }, 500, 'ease')
  activate: (mother) ->
    super mother
    @blocks.activate @dom
    @arena.activate @dom
    @panel.activate @dom
    console.log @toolbox
    Blockly.inject @blocks.dom[0], @toolbox
    console.log 'Após ativar blockly'
    @hide()
  echo: (msg) ->
    console.log 'Incompleto.'
  eval: () ->
    console.log 'Incompleto.'
  turnOn: () ->
    @show()
  turnOff: () ->
    @hide()
  clear: () ->
    console.log 'Incompleto.'
  run: (actual, next) ->
    @session = actual
    @next = next
    @turnOn()
    keyMonitor.pushState @mapKeypress
  mapKeypress: (k) =>
    if k.key in ESC
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
    if k.key in ESC
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
