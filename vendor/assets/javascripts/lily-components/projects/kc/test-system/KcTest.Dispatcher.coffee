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
    test_wares_index: [
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
    a = jQuery.ajax
      url: @props.test_status_url
      data:
        rnd: Math.random()
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
    wares_index = @props.status_data?.test_wares_index

    ware_indexes = []
    for section, section_idx in wares_index
      for wi, idx in section.test_wares
        wi.section = section_idx + 1
        wi.num = idx + 1
        ware_indexes.push wi

    pages = []
    tmp = []
    while ware_indexes.length > 0
      tmp.push ware_indexes.shift()
      if tmp.length is 4 or ware_indexes.length is 0
        pages.push tmp
        tmp = []

    wares: []
    pages: pages
    current_page: parseInt(localStorage['java-test-page'] || 1)

  render: ->
    user_name = @props.status_data?.current_user?.name
    remain_seconds = @props.status_data?.remain_seconds
    wares_index = @props.status_data?.test_wares_index

    # console.log @state.pages

    <div>
      <div className='running-status'>
        <span className='user'>测验人：{user_name}</span>
        <span>测验正在进行，剩余计时</span>
        <span className='remain-time'>
          <RemainTimeString remain_seconds={remain_seconds} timeup={@props.timeup} />
        </span>
        <SelectWares wares_index={wares_index} to_page_for={@to_page_for} />
      </div>

      <TestWares wares={@state.wares} on_answer_change={@handle_answer_change} />

      <TestPaginate pages={@state.pages} current_page={@state.current_page} to_page={@to_page} />
    </div>

  componentDidMount: ->
    @to_page @state.current_page

  handle_answer_change: (ware_id, answer)->
    console.log id: ware_id, answer: answer

    jQuery.ajax
      url: @props.parent.props.test_save_url
      type: "POST"
      data:
        id: ware_id
        answer: answer
      dataType: "json"
      success: (res) =>
        console.log res
        @mark_ware_filled(ware_id, res.filled)

  mark_ware_filled: (id, filled)->
    pages = @state.pages

    for ware_indexes in pages
      for wi in ware_indexes
        if wi.id == id
          wi.filled = filled

    @setState pages: pages

  to_page: (page)->
    wares = @state.pages[page - 1]
    ids = wares.map (wi)-> wi.id
    numbers = wares.map (wi)-> wi.num
    section_numbers = wares.map (wi)-> wi.section

    jQuery.ajax
      url: @props.parent.props.test_wares_url
      type: 'GET'
      data:
        ids: ids
    .done (_res)=>
      res = if @props.parent.props.sample then SAMPLE.wares_res else _res
      for w, idx in res
        w.number = numbers[idx]
        w.section = section_numbers[idx]
      @setState 
        wares: res
        current_page: page
      localStorage['java-test-page'] = page

  to_page_for: (ware)->
    id = ware.id
    page = 1
    for ware_indexes, idx in @state.pages
      ids = ware_indexes.map (wi)-> wi.id
      page = idx + 1 if ids.indexOf(id) > -1
    @to_page(page)



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
        key = ware?.id
        params =
          data: ware
          on_answer_change: @props.on_answer_change

        <div key={key} className='test-ware'>
          {
            if ware.number == 1
              onum = '一二三四五六七八九十'.split('')
              kind_str = {
                single_choice:  '单选题'
                multi_choice:   '多选题'
                bool:           '判断题'
                essay:          '论述题'
                file_upload:    '编码题'
              }[ware.kind]

              <div className='section-label'>
                <span className='snum'>第{onum[ware.section - 1]}部分</span>
                <span className='kind'>{kind_str}</span>
              </div>
          }

          <div className='number'>{ware.number}.</div>
          <div className='ware-component'>
          {
            switch ware.kind
              when "single_choice"
                <SingleChoiceTestWare {...params} />
              when "multi_choice"
                <MultiChoiceTestWare {...params} />
              when "bool"
                <BoolTestWare {...params} />
              when "essay"
                <EssayTestWare {...params} />
              when "file_upload"
                <FileUploadTestWare {...params} />
          }
          </div>
        </div>
    }
    </div>

SelectWares = React.createClass
  render: ->
    <a className='ui button mini green select-wares' onClick={@select}>
      <i className='icon block layout' /> 选择题目
    </a>

  select: ->
    @modal_handle = jQuery.open_modal(
      <Selector wares_index={@props.wares_index} to_page_for={@props.to_page_for} parent={@} />
      className: 'test-dispatcher-select-wares-modal'
      modal_config:
        blurring: true
    )

  close_modal: ->
    @modal_handle.close()

Selector = React.createClass
  render: ->
    <div>
      <h3>选择并跳转到题目位置</h3>
      <div className='tuli'>
        <span>图例：</span>
        <span className='not-filled' /><span>未作答</span>
        <span className='filled' /><span>已作答</span>
      </div>
      <a className='ui button mini close' href='javascript:;' onClick={@close}>
        <i className='icon close' /> 关闭
      </a>
      {
        for section, idx in @props.wares_index
          kind_str = {
            single_choice:  '单选题'
            multi_choice:   '多选题'
            bool:           '判断题'
            essay:          '论述题'
            file_upload:    '编码题'
          }[section.kind]

          onum = '一二三四五六七八九十'.split('')

          <div key={idx} className='section'>
            <h4>第{onum[idx]}部分 - {kind_str}</h4>
          {
            for ware, idx1 in section?.test_wares
              klass = new ClassName
                'ware': true
                'filled': ware.filled
              <a key={idx1} className={klass} href='javascript:;' title={ware.id} onClick={@select(ware)} >{idx1 + 1}</a>
          }
          </div>
      }
    </div>

  select: (ware_id)->
    =>
      @props.to_page_for(ware_id)
      @props.parent.close_modal()

  close: ->
    @props.parent.close_modal()

TestPaginate = React.createClass
  render: ->
    klass1 = new ClassName
      'ui labeled icon button green': true
      'disabled': @props.current_page is 1

    klass2 = new ClassName
      'ui right labeled icon button green': true
      'disabled': @props.current_page is @props.pages.length

    <div className='test-paginate'>
      <span className='text'>第 {@props.current_page} 页，共 {@props.pages.length} 页</span>
      <a className={klass1} onClick={@to_page(@props.current_page - 1)}>
        <i className='icon arrow left' /> 上一页
      </a>
      <a className={klass2} onClick={@to_page(@props.current_page + 1)}>
        <i className='icon arrow right' /> 下一页
      </a>
    </div>

  to_page: (page)->
    =>
      # console.log page
      @props.to_page(page)