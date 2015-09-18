window.Switch = React.createClass
  render: ->
    <div className="lily-switch state-#{@state.state}" onClick={@toggle}>
      <input name={@props.name} type='checkbox' className='switch-checkbox' checked={@state.state is 'on'} readOnly ref='checkbox' />
      <div className='switch-toggle'></div>
    </div>

  getInitialState: ->
    state: @props.state || 'off'

  toggle: ->
    state = @state.state
    state = (['on', 'off'].filter (x)-> x isnt state)[0]
    @setState
      state: state

  componentDidUpdate: ->
    $checkbox = jQuery @refs.checkbox.getDOMNode()
    $checkbox.attr('checked', @state.state is 'on')
    jQuery(document).trigger 'lily:switch-change', @refs.checkbox.getDOMNode()

page_loaded ->
  jQuery('input[type=checkbox][role=lily-switch]').each ->
    $elm = jQuery(this)
    name = $elm.attr('name')
    $container = jQuery('<div>')
      .addClass('lily-switch-container')
      .insertAfter $elm
    React.render <Switch state='on' name={name}/>, $container[0]
    $elm.remove()