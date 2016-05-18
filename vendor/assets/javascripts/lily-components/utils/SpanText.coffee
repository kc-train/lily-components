@SpansText = React.createClass
  render: ->
    <div {...@props}>
    {
      for char, idx in @props.text.split('')
        <span key={idx}>{char}</span>
    }
    </div>