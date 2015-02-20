
# Corrigir bug de deslocamento quando no canto direito da tela

tileset = {
  s: "street",
  g: "grass",
  t: "tree",
  t: "tree",
  w: "water",
  h: "house",
  l: "wall"
};

# Lista de tiles por onde o herói pode caminhar
walkable = "sgh"

# Representação do avatar.
class Person extends Element
  constructor: (@id) ->
    super @id
    @dom.addClass "mini-person"
    @pos = [0, 0]
    @event = false

  setImage: (url) ->
    @dom.css 'background-image', "url(" + url + ")"

  setEvent: (ev) ->
    @event = ev

  doMove: (ifix) ->
    @slide((@pos[0] + ifix)*40 + 10, @pos[1]*42 +10)

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

  info: (msg) ->
    console.log "Hero: " + @pos + "; " + msg

# Mapa navegável por personagens (no momento, somente o herói)
class Scenary extends Element
  constructor: (@map) ->
    @persons = {}
    @elements = {}
    @dom = $("<table />", {id: "scenario"})
    for l in @map
      line = $("<tr />")
      for t in l
        tile = $("<td />", {"class": tileset[t]})
        line.append(tile)
      @dom.append(line)

  _updatePos: (name, pos, prev = false) ->
    console.log "Mudando de " + prev + " para " + pos
    if prev
      console.log "Removendo prev"
      k = prev[0] + ':' + prev[1]
      if not @elements[k].call
        delete @elements[k]
      else
        return
      @elements[pos[0] + ':' + pos[1]] = name
  addPerson: (pk, p, pos) ->
    @persons[pk] = p
    p.pos = pos
    @_updatePos pk, p.pos
  addEvent: (x, y, func) ->
    @elements[x + ':' + y] = func
  activate: (mother) ->
    super mother
    @pos = [0, 0]
    w = @map[0].length * 40
    @dom.css "width", w
 
    @left = true
    @b_right = b_screen[0] - @map[0].length
    @right = @b_right * 40
    for p of @persons
      @persons[p].activate mother
      @persons[p].doMove @hDiff()

  # Diferença horizontal, a usar nos cálculos de posicionamento
  hDiff: () ->
    if @left then 0 else @b_right

  activatePos: (x, y) ->
    x_exst = 0 <= x < @map[0].length
    y_exst = 0 <= y < @map.length
    if x_exst and y_exst
      gdplane = walkable.indexOf(@map[y][x]) > -1
      ind = x + ':' + y
      console.log @elements
      console.log 'Kim: ' + @persons['kim'].pos
      console.log 'Target: ' + ind
      if @elements[ind]
        console.log "Havia algo na posição " + ind
        if @elements[ind].call
          @elements[ind].call()
          console.log "...e era uma função"
          elems = false
        else
          elems = true
      else
        elems = false
      return gdplane and not elems
    else
      return false

  # Funcionar em modo avatar (main=true) e modo NPC (main=false)
  move: (n, dx, dy, main = false) ->
    # O cenário neste momento tem apenas 2 estados: colado à direita e colado à
    # esquerda. Se estiver colado à direita, as coordenadas do herói
    # deverão ser corrigidas em x.
    p = @persons[n]
    prev = p.pos.slice()
    ifix = @hDiff()
    # Coordenadas corrigidas, necessárias nas comparações para funcionar direito
    pseudopos = [p.pos[0] - ifix, p.pos[1]]

    p.info("pp " + pseudopos + " " + ifix + " (" + dx + ", " + dy + ") bs " + b_screen + " sa " + screenarea)

    ok = @activatePos(p.pos[0] + dx, p.pos[1] + dy)

    # Mover para a esquerda
    if dx is -1
      p.left(ok)
      if (p.pos[0] - 2 < -ifix) and not @left
        @left = true
        @slide(0, 0)
        ifix = 0

    # Mover para a direita
    else if dx is 1
      p.right(ok)
      if pseudopos[0] > 8 and @left
        @left = false
        @slide(@right, 0)
        ifix = @b_right

    # Mover para cima
    else if dy is -1
      p.up(ok)

    # Mover para baixo
    else if dy is 1
      p.down(ok)

    # Mover o herói de fato para as novas coordenadas
    for k of @persons
      @persons[k].doMove(ifix)
      if k is n
        @_updatePos n, p.pos, prev
      else
        @_updatePos k, @persons[k].pos
