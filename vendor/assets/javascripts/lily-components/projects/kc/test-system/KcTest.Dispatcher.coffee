# 数据结构参考：
# http://markdown.4ye.me/OZqnksBw
# http://markdown.4ye.me/OZqnksBw/2

SAMPLE = 
  init_res:
    # status: 'NOT_START'
    status: 'FINISHED'


@KcTest.Dispatcher = React.createClass
  propTypes:
    test_status_url:  React.PropTypes.string.isRequired
    test_wares_url:   React.PropTypes.string.isRequired
    test_control_url: React.PropTypes.string.isRequired
    test_save_url:    React.PropTypes.string.isRequired

    # 是否仅加载演示数据
    sample: React.PropTypes.bool

  getInitialState: ->
    # INIT      组件初始化
    # NOT_START 测验未开始 
    # RUNNING   测验正在进行 
    # FINISHED  测验已结束

    status: 'INIT' 

  render: ->
    <div className='kc-test-dispatcher'>
    {
      switch @state.status
        when 'INIT'
          <InitLoader init={@init} />
        when 'NOT_START'
          <NotStart start={@start} />
        when 'FINISHED'
          <Finished />
    }
    </div>

  init: ->
    # 读取当前考试状态，判断是未开考还是已开考
    jQuery.ajax
      url: @props.test_status_url
      type: 'GET'
    .done (_res)=>
      res = if @props.sample then SAMPLE.init_res else _res
      @setState status: res.status

  start: ->
    jQuery.ajax
      url: @props.test_control_url
      type: 'POST'
      data:
        action: 'start'
    .done (res)=>
      111

InitLoader = React.createClass
  render: ->
    <div className='ui segment basic' style={height: '10rem'}>
      <div className='ui active inverted dimmer'>
        <div className='ui text loader'>
          测验正在初始化……
        </div>
      </div>
    </div>

  componentDidMount: ->
    @props.init()

NotStart = React.createClass
  render: ->
    <div>
      <div className='ui message warning'>
        测验尚未开始，请点击下方按钮开始测验
      </div>
      <a className='ui button green large' onClick={@start}>
        <i className='icon play' /> 开始测验
      </a>
    </div>

Finished = React.createClass
  render: ->
    <div>
      <div className='ui message warning'>
        测验已经结束，请关闭此网页
      </div>
    </div>