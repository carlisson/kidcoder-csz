
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
  activate: (mother) ->
    super mother
    @message.activate mother
    #person.activate @dom for person in @persons
    for n, person of @persons
      person.activate @dom
  addPerson: (name, p) ->
    @persons[name] = p
  talk: (name, humor, text) ->
    @persons[name].show humor
  write: (t) ->
    @message.dom.text t
    @message.show()
  choose: () ->
  desactivate: () ->

