
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

novel = new NovelScene("mainnovel")
novel.addPerson "kim", heroPerson

#mapHero = (k) ->
#  hero.sceneKeypress(scene, k.key)

$(document).ready ->
  scene.activate $("#area")
  hero.activate $("#area")
  novel.activate $("#area")
  # Mapeamento de teclas para movimentações
  keyMonitor.pushState mapKeypress
  novel.turnOn()
  novel.talk "kim", "default", "Olá mundo"
  novel.talk "kim", "default", "Olá de novo"
  novel.run("Inicial", "Jogo")
