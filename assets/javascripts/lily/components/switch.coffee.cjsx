@Switch = React.createClass
  render: ->
    <div className="lily-switch state-#{@state.state} skin-#{@props.skin}" onClick={@toggle}>
      <input name={@props.name} type='checkbox' className='switch-checkbox' checked={@_is_on()} readOnly ref='checkbox' />
      <div className='switch-toggle'></div>
    </div>

  getInitialState: ->
    state: @props.state || 'off'

  getDefaultProps: ->
    name: ''
    skin: 'default'

  toggle: ->
    state = if @_is_on() then 'off' else 'on'
    @setState state: state

  _is_on: ->
    @state.state is 'on'

  componentDidUpdate: ->
    dom = React.findDOMNode @refs.checkbox
    jQuery(dom).attr 'checked', @_is_on()
    jQuery(document).trigger 'lily:switch-change', dom