
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


# Representação do avatar. Futuramente, separar Person, que deverá ser usada
# também para NPCs.
class Hero extends Element
  constructor: (@scenary) ->
    @pos = [0, 0]
    @dom = $("<div/>", {id: "hero"})

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
      @dom.removeClass 'toright' if @dom.hasClass 'toright'
      @dom.removeClass 'toback' if @dom.hasClass 'toback'
      @dom.addClass 'toleft' if not @dom.hasClass 'toleft'
      if @pos[0] > 0
        if walkable.indexOf(sc.map[@pos[1]][@pos[0]-1]) > -1
          @pos[0] -= 1
          # Essa fórmula é maluca, mas funciona. Quando o jogador move o herói do
          # terceiro para o segundo quadrado na tela, a tela rola para a esquerda.
          if @pos[0] - 2 < -ifix and not sc.left
            sc.left = true
            sc.slide(0, 0)
            ifix = 0
        else
          console.log 'red'
      else
        console.log 'black'

    # Mover para a direita
    else if dx is 1
      @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
      @dom.removeClass 'toback' if @dom.hasClass 'toback'
      @dom.addClass 'toright' if not @dom.hasClass 'toright'
      if @pos[0] < sc.map[0].length
        if walkable.indexOf(sc.map[@pos[1]][@pos[0]+1]) > -1
          @pos[0] += 1
          if pseudopos[0] > 8 and sc.left
            sc.left = false
            sc.slide(sc.right, 0)
            ifix = sc.b_right
        else
          console.log 'red'
      else
        console.log 'black'

    # Mover para cima
    else if dy is -1
      @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
      @dom.removeClass 'toright' if @dom.hasClass 'toright'
      @dom.addClass 'toback' if not @dom.hasClass 'toback'
      if pseudopos[1] > 0
        if walkable.indexOf(sc.map[@pos[1] - 1][@pos[0]]) > -1
          @pos[1] -= 1
        else
          console.log 'red'
      else
        console.log 'black'

    # Mover para baixo
    else if dy is 1
      @dom.removeClass 'toright' if @dom.hasClass 'toright'
      @dom.removeClass 'toleft' if @dom.hasClass 'toleft'
      @dom.removeClass 'toback' if @dom.hasClass 'toback'
      if 1 + pseudopos[1] < sc.map.length
        if walkable.indexOf(sc.map[@pos[1] + 1][@pos[0]]) > -1
          @pos[1] += 1
        else
          console.log 'red'
      else
        console.log 'black'

    # Mover o herói de fato para as novas coordenadas
    @slide((@pos[0] + ifix)*40 + 10, @pos[1]*42 +10)

  info: (msg) ->
    console.log "Hero: " + @pos + "; " + msg

# Mapa navegável por personagens (no momento, somente o herói)
class Scenary extends Element
  constructor: (@map) ->
    @dom = $("<table />", {id: "scenario"})
    for l in @map
      line = $("<tr />")
      for t in l
        tile = $("<td />", {"class": tileset[t]})
        line.append(tile)
      @dom.append(line)

  activate: (mother) ->
    super mother
    @pos = [0, 0]
    w = @map[0].length * 40
    @dom.css "width", w
 
    @left = true
    @b_right = b_screen[0] - @map[0].length
    @right = @b_right * 40

mapKeypress = (k) -> 
    switch k.key
      when "Up" then hero.walk(scene, 0, -1)
      when "Down" then hero.walk(scene, 0, 1)
      when "Left" then hero.walk(scene, -1, 0)
      when "Right" then hero.walk(scene, 1, 0)
      when " " then keyMonitor.pushState (k) ->
        if k.key is "Esc"
          keyMonitor.popState()
        else
          console.log "E o jogador pressionou " + k.key


