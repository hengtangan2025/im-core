{ Alert, Icon } = antd

module.exports = ChatRoom = React.createClass
  render: ->
    <div className='chat-room'>
      <Header {...@props} />
      <ChatList {...@props} />
      <ChatInputer {...@props} />
    </div>

Header = React.createClass
  render: ->
    if @props.with_member
      <div className='header'>
        <span className='info member-info'><FaIcon type='user' /> {@props.with_member.name}</span>
      </div>
    else if @props.with_org
      <div className='header'>
        <span className='info org-info'><FaIcon type='circle-o' /> {@props.with_org.name}</span>
        <div className='members'>
          <Icon type='team' /> {@props.with_org.members.length}
        </div>
      </div>

ChatList = React.createClass
  getInitialState: ->
    messages: []

  render: ->
    <div className='chat-list'>
      {
        if @props.with_member
          <Alert message="你正在和 @#{@props.with_member.name} 单聊" type="info" />
        else if @props.with_org
          <Alert message="你正在组织机构 @#{@props.with_org.name} 中群聊" type="info" />
      }
      {
        for message, idx in @state.messages
          <div key={idx} className='chat-item'>
            <strong>
              <span>{message.talker.name} </span>
              <span>[{new Date(message.time).format('hh:mm:ss')}]: </span>
            </strong>
            <span>{message.text}</span>
          </div>
      }
    </div>

  componentDidMount: ->
    jQuery(document)
      .off 'received-message'
      .on 'received-message', (evt, data)=>
        console.log 'received', data
        messages = @state.messages
        messages.push data
        @setState messages: messages


ChatInputer = React.createClass
  getInitialState: ->
    text: ''

  render: ->
    <div className='chat-inputer'>
      <textarea 
        placeholder='在这里说话~' 
        value={@state.text} 
        onChange={@change} 
        onKeyDown={@keydown}
      />
    </div>

  change: (evt)->
    @setState text: evt.target.value

  keydown: (evt)->
    if evt.which is 13
      evt.preventDefault()
      @speak()

  speak: ->
    return if jQuery.trim(@state.text) == ''

    if @props.with_member
      room = {
        type: 'Single'
        id: @props.with_member.id
      }

    if @props.with_org
      room = {
        type: 'Organization'
        id: room_id = @props.with_org.id
      }

    data = {
      text: @state.text
      room: room
    }
    @setState text: ''

    App.room.speak data
    