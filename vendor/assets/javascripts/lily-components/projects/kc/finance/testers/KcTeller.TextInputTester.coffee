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
    splits = TextSpliter.split sample_text, 35
    lines = splits.map (s)->
      s.map((x)-> x.str).join('')

    lines: lines
    current_line: 0

  render: ->
    lines_top_offset = - 24 * @state.current_line

    <div className='kc-teller-text-input-tester'>
      <div className='lines' style={marginTop: lines_top_offset}>
      {
        for str, idx in @state.lines
          if idx == @state.current_line
            <div key={idx} className='current-line' />
          else
            <div key={idx} className='line'>{str}</div>
      }
      </div>

      <div className='inputer'>
        <div className='current-line-text'>{@state.lines[@state.current_line]}</div>
        <div className='ui input'>
          <input type='text' onKeyDown={@change_line}/>
        </div>
      </div>
    </div>

  change_line: (evt)->
    switch evt.which
      when 37
        current_line = @state.current_line
        return if current_line == 0
        @setState current_line: current_line - 1
      when 39
        current_line = @state.current_line
        return if current_line == @state.lines.length - 1
        @setState current_line: current_line + 1