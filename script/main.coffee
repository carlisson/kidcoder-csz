
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
hero = new Hero scene

heroPerson = new NovelPerson "hero-kim", "#b202d1"
heroPerson.addImage "default", "url(images/photo-kim.png)"

npcPerson = new NovelPerson "npc-person", "#444"
npcPerson.addImage "default", "url(images/photo-anon.png)"

novel = new NovelScene("mainnovel")
novel.addPerson "kim", heroPerson
novel.addPerson "npc", npcPerson

#mapHero = (k) ->
#  hero.sceneKeypress(scene, k.key)

$(document).ready ->
  scene.activate $("#area")
  hero.activate $("#area")
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
