
# Personagem em estilo foto, para os diálogos.
class NovelPerson extends Element
  constructor: (@id, @color) ->
    super @id
    @dom.addClass "novel-person"
    @images = []
  activate: (mother) ->
    super mother
    # @hide()
  addImage: (humor, image) ->
    @images[humor] = image
  show: (humor) ->
    @dom.css 'background-image', @images[humor]
    super()

# Cena de novela, envolve diálogo entre personagens e possível interação do jogador através de decisões
class NovelScene extends Element
  constructor: (@id) ->
    super @id
    @dom.addClass "novel-scene"
    @persons = {}
    @message = new Element(@id + "-message")
    @message.dom.addClass "novel-message"
    @message.hide()
    @events = []
    @session = false
  activate: (mother) ->
    super mother
    @message.activate mother
    #person.activate @dom for person in @persons
    for n, person of @persons
      person.activate @dom
    @hide()
  addPerson: (name, p) ->
    @persons[name] = p
  talk: (name, humor, text) ->
    @events.push () =>
      if @persons[name].dom.hasClass('right')
        @persons[name].dom.removeClass('right')
      @persons[name].show humor
      @_write(text)
  # Talk Right
  tright: (name, humor, text) ->
    @events.push () =>
      console.log @persons[name].dom
      if not @persons[name].dom.hasClass('right')
        @persons[name].dom.addClass('right')
      @persons[name].show humor
      @_write(text)
  write: (t) ->
    @events.push () =>
      @_write(t)
  _write: (t) ->
    @message.dom.text t
    @message.show()
    keyMonitor.pushState @mapKeypress
  choose: () ->
  turnOn: () ->
    @show()
  turnOff: () ->
    @hide()
  run: (actual, next) ->
    @session = actual
    @next = next
    @_run()
  _run: () ->
    if @events.length > 0
      console.log "Rodando a primeira função"
      @events[0].call()
    else
      @turnOff()
      @session = @next
  mapKeypress: (k) =>
    if k.key in ['Enter', ' ']
      console.log 'Sai'
      @message.hide()
      @persons[p].hide() for p of @persons
      keyMonitor.popState()
      @events.shift()
      @_run()
    else
      console.log 'Espera'

