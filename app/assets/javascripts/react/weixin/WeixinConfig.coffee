{ Button } = antd

module.exports = WeixinConfig = React.createClass
  getInitialState: ->
    message: null

  render: ->
    style = {
      padding: 10
    }

    panel_style = {
      backgroundColor: '#F8F8F8'
      border: 'solid 1px #ddd'
      padding: 20
    }

    pre_style = {
      backgroundColor: '#f1f1f1'
      padding: 10
      marginBottom: 10
    }

    msg_style = {
      marginTop: 10
    }

    <div className='weixin-config' style={style}>
      <div className='panel' style={panel_style}>
        <pre style={pre_style}>{@props.menu}</pre>
        <Button type='primary' size='large' onClick={@save_menu} disabled>
          <FaIcon type='cog' /> 上传菜单配置
        </Button>
        {
          if @state.message
            <div style={msg_style}>{@state.message}</div>
        }
      </div>
    </div>

  save_menu: ->
    @setState message: <span>正在上传 …</span>

    jQuery.ajax
      type: 'POST'
      url: '/config/save_menu'
    .done (res)=>
      console.log res
      @setState message: <span><FaIcon type='check' /> 上传完毕</span>