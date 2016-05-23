# 数据结构参考：
# http://markdown.4ye.me/OZqnksBw

@KcTest.Dispatcher = React.createClass
  propTypes:
    load_test_data_url: React.PropTypes.string.isRequired

  getInitialState: ->
    # INIT      组件初始化
    # LOADING   读取数据
    # NOT_START 测验未开始 
    # START     测验正在进行 
    # FINISH    测验已结束

    status: 'NOT_START' 

  render: ->
    <div className='kc-test-dispatcher'>
    {
      switch @state.status
        when 'NOT_START'
          <div>
            <div className='ui message warning'>
              测验尚未开始，请点击下方按钮开始测验
            </div>
            <a className='ui button green large'><i className='icon play' /> 开始测验</a>
          </div>
    }
    </div>