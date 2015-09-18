window.AddableItemsInputer = React.createClass
  render: ->
    <div className='addable-items-inputer'>
      <div className='list'>
        {
          for child in @state.children
            <div className='item' data-key={child.key} key={child.key}>
            </div>
        }
      </div>
      <div className='ops'>
        <a className='btn btn-default btn-sm add-btn' href='javascript:;'>
          <span className='glyphicon glyphicon-plus'></span>
          <span>增加</span>
        </a>
      </div>
    </div>

  getInitialState: ->
    count = this.props.count || 1
    children = for i in [0...count]
      key: i
    children: children

  componentDidMount: ->
    @$elm = jQuery @getDOMNode()
    @bind_events()
    @update_items()

  componentDidUpdate: ->
    @update_items()

  bind_events: ->
    that = this

    @$elm.on 'click', '.add-btn', (evt)=>
      children = @state.children 
      children.push
        key: children[children.length - 1].key + 1
      @setState
        children: children

    @$elm.on 'click', '[role=remove-btn]', (evt)->
      key = jQuery(this).closest('.item').data('key')
      children = that.state.children 
      children = children.filter (child)->
        child.key != key
      that.setState
        children: children

  update_items: ->
    @$elm.find('.item').each (idx, item)=>
      $item = jQuery(item)
      key = $item.data('key')

      if $item.children().length is 0
        @props.item.clone()
          .appendTo $item
        @fill_data $item, @props.filldata, idx

      jQuery(document).trigger 'lily:addable-items-inputer-item-render', {
        'item': $item
        key: key
        idx: idx
      }

  fill_data: ($item, filldata, idx)->
    d = filldata[idx]
    $item.find('*').each ->
      $field = jQuery(this)

      return if $field.children().length > 0

      val = $field.val()
      text = $field.text()

      # val
      match = val.match /\{(.+)\}/
      if match
        replace = if d? then d[match[1]] else ''
        $field.val replace

      # text
      match = text.match /\{(.+)\}/
      if match
        replace = if d? then d[match[1]] else ''
        $field.text replace


page_loaded ->
  jQuery('.lily-component[role=lily-addable-items-inputer]').each ->
    $elm = jQuery(this)
    $item = $elm.children().clone()
    count = $elm.data('count')
    filldata = $elm.data('filldata')

    React.render (
      <AddableItemsInputer item={$item} count={count} filldata={filldata}>
      </AddableItemsInputer>
    ), $elm[0]
    
