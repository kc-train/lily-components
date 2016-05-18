sample_text = [
  '随着 INTERNET 的迅速发展，越来越多的银行客户开始寻求不出门的金融服务。一些金融机构开始'
  '将现有的银行业务扩展到 INTERNET 上，在 INTERNET 上开设新的服务窗口，开办网上银行（Internet '
  'Bank），进行网上支付，实现网上转帐、信贷和股票买卖等。这一类网络资金转移、支付并不复'
  '杂，事实上通过 INTERNET 进行电子支付与我们常常在商店中使用的销售点系统（POS）的处理过程'
  '非常相似。主要的不同在于网络支付中，客户通过个人计算机和 Web 服务器进行通信的。只要客户'
  '有一台可联入 INTERNET 的个人计算机即可进入网上银行，进行支票、储蓄、货币市场、存款帐户的'
  '信息查询和管理。利用理财软件，个人还可进行在线支付，结清支票簿。对企业来说，更是可以利'
  '用网上银行进行货币支付、储蓄业务、结算等。中国银行于 1998 年 3 月 6 日在 INTERNET 上完成第一'
  '笔“网上银行”交易，客户若拥有中国银行发行的长城卡，就可通过中行主页申请网上银行服务，'
  '得到银行的服务许可后，即可随时进行网上支付。此外，招商银行的“一卡通”业务在上海、深'
  '圳、广州、北京等城市也开展了个人银行、企业银行、网上支付等业务。目前我国其他商业银行如'
  '工商银行、建设银行的网上金融业务都在积极建设之中。'
].join('')

TextSpliter = React.createClass
  render: ->
    result = TextSpliter.split @props.text
    <table className='ui celled table'>
    <tbody>
    {
      for item, idx in result
        [
          <tr key="#{idx}_1">
          {
            for s, idx1 in item
              <td key={idx1}>{s.str}</td>
          }
          </tr>
          <tr key="#{idx}_2">
          {
            for s, idx1 in item
              <td key={idx1}>{s.length}</td>
          }
          </tr>
        ]
    }
    </tbody>
    </table>

  statics:
    split: (text, line_length = 30)->
      arr = text.match /\w+|[\u4E00-\u9FA5]|[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b]|\s/g
      arr = arr.map (x)->
        l = 2 if x.match /[\u4E00-\u9FA5]/
        l = 2 if x.match /[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b]/
        l = 1 if x.match /\s/
        l = x.length if x.match /\w+/
        {len: l, str: x}
      
      result = []
      _arr = []
      _len = 0
      
      _line_length = line_length * 2

      while arr.length > 0
        x = arr.shift()
        _arr.push x
        _len += x.len
        if _len >= _line_length || arr.length == 0
          result.push _arr
          _arr = []
          _len = 0

      return result


@KcTeller.TextInputTester = React.createClass
  getInitialState: ->
    lines = TextSpliter.split(sample_text, 30).map (s)->
      jQuery.trim s.map((x)-> x.str).join('')

    total_chars_count = 0
    lines.forEach (x)->
      total_chars_count += x.length

    lines: lines
    inputed_lines: EmptyArray(lines.length, null)
    current_line: 0

    total_chars_count: total_chars_count
    inputed_chars_count: 0

  render: ->
    lines_style =
      marginTop: - 70 * @state.current_line

    <div className='kc-teller-text-input-tester'>
      {
        <div className='panel'>
          <div>文章总字数：{@state.total_chars_count}</div>
          <div>目前已输入：{@state.inputed_chars_count}</div>
        </div>
      }
      <div className='scene'>
        <div className='lines' style={lines_style}>
        {
          for text, idx in @state.lines
            _props =
              key: idx
              idx: idx
              current_line: @state.current_line
              text: text
              inputed_text: @state.inputed_lines[idx]
            <Line {..._props} />
        }
        </div>

        {
          _props =
            text: @get_current_line_text()
            onKeyDown: @inputer_key_down
            onLineInputed: @inputer_line_inputed
            recount: @recount
          <Inputer {..._props} ref='inputer' />
        }
      </div>
    </div>

  get_current_line_text: ->
    @state.lines[@state.current_line]

  next_line: ->
    if @state.current_line < @state.lines.length - 1
      @setState current_line: @state.current_line + 1

  prev_line: ->
    if @state.current_line > 0
      @setState current_line: @state.current_line - 1

  inputer_key_down: (evt)->
    switch evt.which
      when 8 # 退格
        if @refs.inputer.is_line_empty() and @state.current_line > 0
          inputed_lines = @state.inputed_lines
          @refs.inputer.set_value inputed_lines[@state.current_line - 1]
          inputed_lines[@state.current_line - 1] = null
          @setState inputed_lines: inputed_lines
          @prev_line()

  inputer_line_inputed: (inputed_text, overflow_text)->
    @next_line()
    inputed_lines = @state.inputed_lines
    inputed_lines[@state.current_line] = inputed_text
    @setState inputed_lines: inputed_lines
    @refs.inputer.set_value overflow_text

  recount: (current_inputer_text)->
    count = current_inputer_text.length
    @state.inputed_lines.forEach (x)->
      count += x.length if x?
    @setState
      inputed_chars_count: count


Line = React.createClass
  propTypes:
    idx:          React.PropTypes.number.isRequired
    current_line: React.PropTypes.number.isRequired
    text:         React.PropTypes.string.isRequired
    inputed_text: React.PropTypes.string

  render: ->
    if @is_inputed()
      <div className='inputed-line'>
        <CompareLine origin={@props.text} compare={@props.inputed_text} />
        <SpansText text={@props.inputed_text} className='inputed' />
      </div>
    else if @is_current()
      <div className='current-line' />
    else
      <SpansText className='line' text={@props.text} />

  is_inputed: ->
    @props.idx < @props.current_line

  is_current: ->
    @props.idx == @props.current_line


Inputer = React.createClass
  propTypes:
    text:          React.PropTypes.string.isRequired
    onKeyDown:     React.PropTypes.func.isRequired
    onLineInputed: React.PropTypes.func.isRequired

  getInitialState: ->
    inputed_value: ''
    showing_value: ''
    cn_ipt_flag: false # 中文输入法是否打开

  render: ->
    <div className='inputer'>
      <CompareLine origin={@props.text} compare={@state.inputed_value} />
      <div className='ui input'>
        <input 
          type='text' 
          value={@state.showing_value} 
          onKeyDown={@props.onKeyDown} 
          onChange={@change}
          ref='input'
        />
      </div>
      {
        l0 = @props.text.length
        l1 = @state.showing_value.length
        l2 = l0 - l1
        <div className='ipt-stat'>剩 {l2} 字</div>
      }
    </div>

  set_value: (value)->
    @setState 
      showing_value: value
      inputed_value: value

  is_line_empty: ->
    @state.showing_value == ''

  change: (evt)->
    value = evt.target.value
    text_length = @props.text.length
    @setState showing_value: value
    unless @state.cn_ipt_flag
      @setState inputed_value: value
      @props.recount value
      if value.length >= text_length
        t1 = value.substring 0, text_length
        t2 = value.substring text_length
        @props.onLineInputed t1, t2

  # 参考 http://www.cnblogs.com/chyingp/p/3599641.html
  # 处理中文输入法问题

  componentDidMount: ->
    jQuery ReactDOM.findDOMNode @refs.input
      .on 'compositionstart', => @setState cn_ipt_flag: true
      .on 'compositionend', => @setState cn_ipt_flag: false


CompareLine = React.createClass
  propTypes:
    origin:  React.PropTypes.string.isRequired
    compare: React.PropTypes.string.isRequired

  render: ->
    arr0 = @props.origin.split('')
    arr1 = @props.compare.split('')

    incorrect_count = 0
    correct_count = 0

    <div className='compare-line'>
    {
      for char0, idx in arr0
        char1 = arr1[idx]
        is_incorrect = char1? and char0 != char1
        is_correct = char1? and char0 == char1
        incorrect_count += 1 if is_incorrect
        correct_count += 1 if is_correct

        klass = new ClassName
          'incorrect': is_incorrect
          'correct': is_correct
          'char': true
        <span key={idx} className={klass}>{char0}</span>
    }
    {
      if @props.origin.length == @props.compare.length
        total = @props.origin.length
        percent = Math.round(correct_count * 100 / total)
        <div className='cl-stat'>正确率 {percent}%</div>
    }
    </div>