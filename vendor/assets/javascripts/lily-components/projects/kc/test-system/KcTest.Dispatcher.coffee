# 数据结构参考：
# http://markdown.4ye.me/OZqnksBw
# http://markdown.4ye.me/OZqnksBw/2

sample_seconds = 1 * 3600 + 14 * 60 + 58
# sample_seconds = 10

SAMPLE = 
  init_res:
    status: 'NOT_START'
    # status: 'RUNNING'
    # status: 'FINISHED'

  start_res:
    status: 'RUNNING'
    current_user:
      id: '12345'
      name: '宋亮'
    deadline_time: new Date(new Date().getTime() + sample_seconds * 1000)
    remain_seconds: sample_seconds
    test_wares_index:
      sections: [
        {
          kind: "single_choice"
          score: 5, # 每题分值
          test_wares: ['id1-1', 'id1-2']
        }
        {
          kind: "multi_choice"
          score: 5, # 每题分值
          test_wares: ['id2-1', 'id2-2', 'id2-3']
        }
        {
          kind: "bool"
          score: 5, # 每题分值
          test_wares: ['id3-1', 'id3-2', 'id3-3', 'id3-4', 'id3-5', 'id3-6']
        }
      ]

  wares_res: [
    {
      question: {id: 'q1'}
    }
    {
      question: {id: 'q2'}
    }
    {
      question: {id: 'q3'}
    }
  ]


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
    status_data: null

  render: ->
    <div className='kc-test-dispatcher'>
    {
      switch @state.status
        when 'INIT'
          <InitLoader init={@init} />
        when 'NOT_START'
          <NotStart start={@start} status_data={@state.status_data} />
        when 'RUNNING'
          <RunningTest status_data={@state.status_data} timeup={@timeup} parent={@} />
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
      @show_status res

  start: ->
    jQuery.ajax
      url: @props.test_control_url
      type: 'POST'
      data:
        action: 'start'
    .done (_res)=>
      res = if @props.sample then SAMPLE.start_res else _res
      @show_status res

  show_status: (res)->
    @setState 
      status: res.status
      status_data: res

  timeup: ->
    @setState
      status: 'FINISHED'



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
      <a className='ui button green large' onClick={@props.start}>
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

RunningTest = React.createClass
  getInitialState: ->
    wares: []

  render: ->
    user_name = @props.status_data?.current_user?.name
    remain_seconds = @props.status_data?.remain_seconds
    wares_index = @props.status_data?.test_wares_index

    <div>
      <div className='running-status'>
        <span className='user'>测验人：{user_name}</span>
        <span>测验正在进行，剩余计时</span>
        <span className='remain-time'>
          <RemainTimeString remain_seconds={remain_seconds} timeup={@props.timeup} />
        </span>
        <SelectWares wares_index={wares_index} />
      </div>

      <TestWares wares={@state.wares} />

      <TestPaginate />
    </div>

  componentDidMount: ->
    jQuery.ajax
      url: @props.parent.props.test_wares_url
      type: 'GET'
    .done (_res)=>
      res = if @props.parent.props.sample then SAMPLE.wares_res else _res
      @setState wares: res


RemainTimeString = React.createClass
  getInitialState: ->
    local_deadline_time: new Date().getTime() + @props.remain_seconds * 1000
    remain_seconds: @props.remain_seconds

  render: ->
    hours = ~~(@state.remain_seconds / 3600)
    minutes = ~~((@state.remain_seconds - hours * 3600) / 60)
    seconds = @state.remain_seconds - hours * 3600 - minutes * 60

    <span>
      {hours} 小时 {minutes} 分钟 {seconds} 秒
    </span>

  componentDidMount: ->
    @timer = setInterval =>
      now = new Date().getTime()
      delta = ~~((@state.local_deadline_time - now) / 1000)
      @setState remain_seconds: delta
      if delta == 0
        @props.timeup()
    , 50

  componentWillUnmount: ->
    clearInterval @timer

TestWares = React.createClass
  render: ->
    <div className='test-wares'>
    {
      for ware in @props.wares
        key = ware?.question?.id
        <div key={key} className='test-ware' />
    }
    </div>

SelectWares = React.createClass
  render: ->
    <a className='ui button mini green select-wares' onClick={@select}>
      <i className='icon block layout' /> 选择题目
    </a>

  select: ->
    jQuery.open_modal(
      <Selector wares_index={@props.wares_index} />
      className: 'test-dispatcher-select-wares-modal'
      modal_config:
        blurring: true
    )

Selector = React.createClass
  render: ->
    sections = @props.wares_index?.sections
    <div>
      <h3>选择并跳转到题目位置</h3>
      {
        for section, idx in sections
          <div key={idx} className='section'>
            <h4>第 {idx + 1} 部分 - {section.kind}</h4>
          {
            for ware, idx1 in section?.test_wares
              <a key={idx1} className='ware' href='javascript:;' onClick={@select(ware)} />
          }
          </div>
      }
    </div>

  select: (ware_id)->
    =>
      console.log ware_id

TestPaginate = React.createClass
  render: ->
    <div className='test-paginate'>
      <a className='ui labeled icon button green'>
        <i className='icon arrow left' /> 上一页
      </a>
      <a className='ui right labeled icon button green'>
        <i className='icon arrow right' /> 下一页
      </a>
    </div>
