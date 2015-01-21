# Arquivo de apoio, com classes, funções e variáveis amplamente utilizadas pelo jogo.


# Elemento gráfico do jogo
class Element
  # Deve definir @dom como construtor do correspondente ao elemento no DOM
  constructor: (@id) ->
    @dom = $("<div/>", {id: @id})
  # Vincula o elemento @dom a um elemento mãe. Dá outros procedimentos que
  # devam ser feito somente após o DOM da página estar pronto.
  activate: (mother) ->
    mother.append @dom
  # Desloca o elemento para a nova posição.
  show: () ->
    @dom.show()
  hide: () ->
    @dom.hide()
  slide: (x, y) ->
    @dom.animate({
      translate3d: x + 'px,' + y + 'px,0'
    }, 500, 'linear')

# Controlador de eventos de teclado
class InternalKeyMonitor
  constructor: () ->
    @stack = []
  toLast: () ->
    $(document).unbind 'keypress'
    $(document).on 'keypress', @stack[@stack.length - 1] if @stack.length > 0
  pushState: (f) ->
    @stack.push(f)
    @toLast()
  popState: () ->
    @stack.pop()
    @toLast()
  clear: () ->
    @stack = []
keyMonitor = new InternalKeyMonitor()

