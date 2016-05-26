jQuery.open_modal = (component, config={})->
  klass = ['ui', 'modal', 'jquery']
  klass.push config?.className if config?.className?

  $dom = jQuery """
    <div class="#{klass.join(' ')}">
      <div class="content">
      </div>
    </div>
  """
    .appendTo document.body

  c = ReactDOM.render component, $dom.find('.content')[0]

  handle =
    component: c
    close: (func)->
      $dom.modal 'hide', ->
        $dom.remove()
        func?()
    refresh: ->
      $dom.modal('refresh')

  modal_config = jQuery.extend({
    blurring: false
    closable: true
  }, config.modal_config || {})

  $dom
    .modal modal_config
    .modal('show')

  return handle