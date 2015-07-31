#testar snap/svg/raphael/paper interagindo com o blockly

screenarea = [640, 420]
# Tamanho da tela contado em quadrados
b_screen = [screenarea[0]/40, screenarea[1]/42]

scene = new Scenary [
  'ggggggsggggggggggggg',
  'tttttgsggggggggggggg',
  'ttttttsssssssssggggg',
  'tsstttsgggggggsggggg',
  'ssssttsgggggghsggggg',
  'ssssthsgggggwssggggg',
  'sssssssggggwwwwwgwwg',
  'ttggggggggwwwwwwgwww',
  'ggggggggggggwwwggwww',
  'gggggggggggwwwwgggww'
] 
hero = new Person "hero"
hero.setImage "images/hero-kim.png"
scene.addPerson "kim", hero, [0, 0]

anon = new Person "anon"
anon.setImage "images/hero.png"
scene.addPerson "Anon", anon, [7, 7]

heroPerson = new NovelPerson "hero-kim", "#b202d1"
heroPerson.addImage "default", "images/photo-kim.png"

npcPerson = new NovelPerson "npc-person", "#444"
npcPerson.addImage "default", "images/photo-anon.png"

novel = new NovelScene "mainnovel"
novel.addPerson "kim", heroPerson
novel.addPerson "npc", npcPerson

###cabine = new PuzzleScene 'fase1'
cabine.addState 'images/snake-off.png'
cabine.addState 'images/snake-on.png'###

cabine = new PAScene 'fase1'

mapKeypress = (k) ->
  console.log "Apertou a tecla " + k.key
  if k.key in UP
    scene.move "kim", 0, -1, true
  else if k.key in DOWN
    scene.move "kim", 0, 1, true
  else if k.key in LEFT
    scene.move "kim", -1, 0, true
  else if k.key in RIGHT
    scene.move "kim", 1, 0, true
  else if k.key in ESC
    cabine.run 'Snake', 'Jogo'

#  for i in $("#blocklyDiv")[0]
#    document.write "<ul>" + i + "</ul>"

###var code = Blockly.JavaScript.workspaceToCode();
var myInterpreter = new Interpreter(code, initApi);
myInterpreter.run();###
###$("#blocklyDiv")[0].dom.animate({
translate3d: '1000px,1000px,0'
}, 500, 'linear')###

$(document).ready ->
  ###
  $("#bclear").on 'click', (e) ->
    area = $("#editor_area")
    Blockly.mainWorkspace.clear()
  $("#bhide").on 'click', (e) ->
    area = $("#editor_area")
    x = -810
    y = 0
    area.animate({
      translate3d: x + 'px,' + y + 'px,0',
      opacity: 0.0
    }, 500, 'ease')
  $("#bshow").on 'click', (e) ->
    area = $("#editor_area")
    x = 0
    y = 0
    area.animate({
      translate3d: x + 'px,' + y + 'px,0'
      opacity: 1.0
    }, 500, 'ease')
  ###

  tb =
    toolbox: '<xml id="toolbox"><block type="controls_if"></block><block type="controls_repeat_ext"></block><block type="logic_compare"></block><block type="math_number"></block><block type="math_arithmetic"></block><block type="text"></block><block type="stuff_date"></block></xml>'

  #Blockly.inject $('#blocklyDiv')[0], tb

  scene.addEvent 6, 6, () ->
    novel.turnOn()
    novel.write "Chegou aqui."
    novel.run "Fala", "Jogo"
  scene.activate $("#area")
  novel.activate $("#area")
  cabine.activate $("#area")
  # Mapeamento de teclas para movimentações
  keyMonitor.pushState mapKeypress
  novel.turnOn()
  novel.write "Certo dia de Sol..."
  novel.talk "kim", "default", "Olá mundo"
  novel.tright "npc", "default", "Oi, e aí?"
  novel.talk "kim", "default", "Desde quando você se chama mundo?"
  novel.write "Assim a jornada teve início"
  novel.run "Inicial", "Jogo"
