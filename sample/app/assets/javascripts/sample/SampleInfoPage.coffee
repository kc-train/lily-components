@SampleInfoPage = React.createClass
  render: ->
    <div className='ui container' style={paddingTop: '1rem'}>
      <h3 className='ui header'>{@props.data.component}</h3>
      <div className='ui segment basic'>
        暂无说明
      </div>
      <div className='ui segment basic'>
        <h4 className='ui header'>demo:</h4>
        {
          c = eval(@props.data.component)
          React.createElement(c, {})
        }
      </div>
    </div>