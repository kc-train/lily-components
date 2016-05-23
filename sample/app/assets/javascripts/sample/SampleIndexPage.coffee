components = [
  ['文字输入测验', 'KcTeller.TextInputTestware']
  ['交易代码记忆测验', 'KcTeller.TransactionCodeMemoryTestware']
  ['测验调度', 'KcTest.Dispatcher']
].map (x)->
  {name: x[0], component_name: x[1]}

@SampleIndexPage = React.createClass
  render: ->
    <div className='ui container' style={paddingTop: '1rem'}>
      <h1 className='ui header'>Lily Components</h1>

      <div className='ui segment'>
        <h3 className='ui header'>常用 HTML 组件</h3>
      </div>
      <div className='ui segment'>
        <h3 className='ui header'>项目：KC Finance 考试模块</h3>

        <table className='ui celled table'>
          <tbody>
          {
            for component, idx in components
              <tr key={idx}>
                <td>{component.name}</td>
                <td>
                  <a href="/info?component=#{component.component_name}">{component.component_name}</a>
                </td>
              </tr>
          }
          </tbody>
        </table>
      </div>
    </div>