
class NovelPerson extends Element
  constructor: (@id, @color) ->
    super constructor @id
    @dom.addClass "novel-person"
    @images = []
  activate: (mother) ->
    super activate mother
    @hide()
  addImage: (humor, image) ->
    @images[humor] = image
  show: (humor) ->
    @dom.css 'background-image', @images[humor]
    super show()

# Cena de novela, envolve diálogo entre personagens e possível interação do jogador através de decisões
class NovelScene
  constructor: (@id) ->
    super constructor @id
    @dom.addClass "novel-scene"
    @persons = []
    @message = new Element(@id + "-message")
    @message.dom.addClass "novel-message"
  activage: (mother) ->
    super activate mother
    @message.activate(@dom)
    person.activate(@dom) for person in @persons
  addPerson: (name, p) ->
    @persons[name] = p
  talk: (name, humor, text) ->
    @persons[name].show(humor)
  write: (t) ->
    @message.text(t)
    @message.show()
  choose: () ->
  desactivate: () ->

