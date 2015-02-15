
# Corrigir bug de deslocamento quando no canto direito da tela

tileset = {
  s: "street",
  g: "grass",
  t: "tree",
  w: "water",
  h: "house",
  l: "wall"
};

# Lista de tiles por onde o herói pode caminhar
walkable = "sgh"

# Representação do avatar.
class Person extends Element
  constructor: (@id, @scenary) ->
    super @id
    @dom.addClass "mini-person"
    @pos = [0, 0]

  setImage: (url) ->
    @dom.css 'background-image', "url(" + url + ")"

  left: (ok) ->
    @dom.removeClass 'toright' if @dom.hasClass 'toright'
    @dom.removeClass 'toback' if @dom.hasClass 'toback'
    @dom.addClass 'toleft' if not @dom.hasClass 'toleft'
    if ok
      @pos[0] -= 1
    else
      console.log "Não pode ir mais para a esquerda que isso"

  right: (ok) ->
    @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
    @dom.removeClass 'toback' if @dom.hasClass 'toback'
    @dom.addClass 'toright' if not @dom.hasClass 'toright'
    if ok
      @pos[0] += 1
    else
      console.log "Não pode ir mais a direita que isso"

  up: (ok) ->
    @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
    @dom.removeClass 'toright' if @dom.hasClass 'toright'
    @dom.addClass 'toback' if not @dom.hasClass 'toback'
    if ok
      @pos[1] -= 1
    else
      console.log "Não pode subir mais que isso"

  down: (ok) ->
    @dom.removeClass 'toright' if @dom.hasClass 'toright'
    @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
    @dom.removeClass 'toback' if @dom.hasClass 'toback'
    if ok
      @pos[1] += 1
    else
      console.log "Não pode descer mai que isso"

  # Desloca o herói pelo cenário com base em (dx, dy), onde dx e dy podem
  # assumir valores -1, 0 ou 1.
  walk: (sc, dx, dy) ->
    # O cenário neste momento tem apenas 2 estados: colado à direita e colado à
    # esquerda. Se estiver colado à direita, as coordenadas do herói
    # deverão ser corrigidas em x.
    ifix = if sc.left then 0  else sc.b_right
    # Coordenadas corrigidas, necessárias nas comparações para funcionar direito
    pseudopos = [@pos[0] - ifix, @pos[1]]

    @info("pp " + pseudopos + " " + ifix + " (" + dx + ", " + dy + ") bs " + b_screen + " sa " + screenarea)
    # Mover para a esquerda
    if dx is -1
      ok = (@pos[0] > 0) and (walkable.indexOf(sc.map[@pos[1]][@pos[0]-1]) > -1)
      @left(ok)
      if (@pos[0] - 2 < -ifix) and not sc.left
        sc.left = true
        sc.slide(0, 0)
        ifix = 0

    # Mover para a direita
    else if dx is 1
      ok = (@pos[0] < sc.map[0].length) and (walkable.indexOf(sc.map[@pos[1]][@pos[0]+1]) > -1)
      @right(ok)
      if pseudopos[0] > 8 and sc.left
        sc.left = false
        sc.slide(sc.right, 0)
        ifix = sc.b_right

    # Mover para cima
    else if dy is -1
      ok = (pseudopos[1] > 0) and (walkable.indexOf(sc.map[@pos[1] - 1][@pos[0]]) > -1)
      @up(ok)

    # Mover para baixo
    else if dy is 1
      ok = (1 + pseudopos[1] < sc.map.length) and (walkable.indexOf(sc.map[@pos[1] + 1][@pos[0]]) > -1)
      @down(ok)

    # Mover o herói de fato para as novas coordenadas
    @slide((@pos[0] + ifix)*40 + 10, @pos[1]*42 +10)

  info: (msg) ->
    console.log "Hero: " + @pos + "; " + msg

  sceneKeypress: (scenary, key) ->
    switch key
      when "Up" then @walk(scenary, 0, -1)
      when "Down" then @walk(scenary, 0, 1)
      when "Left" then @walk(scenary, -1, 0)
      when "Right" then @walk(scenary, 1, 0)

# Mapa navegável por personagens (no momento, somente o herói)
class Scenary extends Element
  constructor: (@map) ->
    @persons = {}
    @events = {}
    @dom = $("<table />", {id: "scenario"})
    for l in @map
      line = $("<tr />")
      for t in l
        tile = $("<td />", {"class": tileset[t]})
        line.append(tile)
      @dom.append(line)

  addPerson: (pk, p) ->
    @persons[pk] = p
  addEvent: (x, y, func) ->
    @events[x + ':' + y] = func
  activate: (mother) ->
    super mother
    @pos = [0, 0]
    w = @map[0].length * 40
    @dom.css "width", w
 
    @left = true
    @b_right = b_screen[0] - @map[0].length
    @right = @b_right * 40
  move: (p, dx, dy) ->

mapKeypress = (k) -> 
  console.log "Pressionou a tecla " + k.key
  switch k.key
    when "Up" then hero.walk(scene, 0, -1)
    when "Down" then hero.walk(scene, 0, 1)
    when "Left" then hero.walk(scene, -1, 0)
    when "Right" then hero.walk(scene, 1, 0)
