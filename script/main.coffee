
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

mapKeypress = (k) ->
  console.log "Apertou a tecla " + k.key
  switch k.key
    when "Up" then scene.move "kim", 0, -1, true
    when "Down" then scene.move "kim", 0, 1, true
    when "Left" then scene.move "kim", -1, 0, true
    when "Right" then scene.move "kim", 1, 0, true

$(document).ready ->
  scene.addEvent 6, 6, () ->
    novel.turnOn()
    novel.write "Chegou aqui."
    novel.run "Fala", "Jogo"
  scene.activate $("#area")
  novel.activate $("#area")
  # Mapeamento de teclas para movimentações
  keyMonitor.pushState mapKeypress
  novel.turnOn()
  novel.write "Certo dia de Sol..."
  novel.talk "kim", "default", "Olá mundo"
  novel.tright "npc", "default", "Oi, e aí?"
  novel.talk "kim", "default", "Desde quando você se chama mundo?"
  novel.write "Assim a jornada teve início"
  novel.run "Inicial", "Jogo"
