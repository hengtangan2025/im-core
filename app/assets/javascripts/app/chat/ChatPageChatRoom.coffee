{ Alert, Icon, Spin } = antd
{ ChatCharAvatar } = AppComponents

module.exports = ChatPageChatRoom = React.createClass
  render: ->
    room = @abstract_room()

    <div className='chat-room' key={room.key}>
      <Header {...@props} room={room} />
      <ChatList {...@props} room={room} />
      <ChatInputer {...@props} />
    </div>

  abstract_room: ->
    if @props.with_member
      return {
        type: 'SINGLE'
        key: [current_user.member_id, @props.with_member.id].sort().join('-')
        sender_id: current_user.member_id
      }

    if @props.with_org
      return {
        type: 'ORGANIZATION'
        key: @props.with_org.id
        sender_id: current_user.member_id
      }

Header = React.createClass
  render: ->
    if @props.with_member
      <div className='header'>
        <span className='info member-info'><FaIcon type='user' /> {@props.with_member.name}</span>
        <span>room_key: {@props.room.key}</span>
      </div>
    else if @props.with_org
      <div className='header'>
        <span className='info org-info'><FaIcon type='circle-o' /> {@props.with_org.name}</span>
        <span>room_key: {@props.room.key}</span>
        <a href="/organizations/#{@props.room.key}" target='_blank'>[查看机构信息]</a>
        <div className='members'>
          <Icon type='team' /> {@props.with_org.members.length}
        </div>
      </div>

ChatList = React.createClass
  getInitialState: ->
    loading: true # 读取历史信息
    messages: []

  render: ->
    <div className='chat-list'>
      {@cinfo()}
      <div className='messages'>
      {
        for message in @state.messages
          <ChatItem key={message.id} message={message} />
      }
      </div>
    </div>

  cinfo: ->
    <div className='channel-info'>
      <Spin size='large' spinning={@state.loading}>
      {
        if @props.with_member
          <Alert message="你正在和 @#{@props.with_member.name} 单聊" type="info" />
        else if @props.with_org
          <Alert message="你正在组织机构 @#{@props.with_org.name} 中群聊" type="info" />
      }
      </Spin>
    </div>

  componentDidMount: ->
    @load_history_messages()

    jQuery(document)
      .off 'received-message'
      .on 'received-message', (evt, data)=>
        @receive_message(data)

  receive_message: (data)->
    # console.log 'received message data'
    if data.room.key == @props.room.key
      # console.log 'show message', data
      messages = @state.messages
      messages.push data
      @setState messages: messages

      @send_notification(data)
    else
      # console.log 'not in the room, so remind message'
      @remind_message(data)

  send_notification: (data)->
    if data.talker.member_id != current_user.member_id
      new Notification("有一条新消息", {
        body: "#{data.talker.name}: #{data.content.text}"
        # icon: 'http://i.teamkn.com/i/fvnih9Ar.png'
        icon: 'http://i.teamkn.com/i/jysbxKvq.png'
      })

  remind_message: (data)->
    jQuery(document).trigger 'show-remind-message', data

  load_history_messages: ->
    history_messages_url = '/chat_messages/history'

    jQuery.ajax
      type: 'GET'
      url: history_messages_url
      data:
        room: @props.room
    .done (res)=>
      console.log res
      @setState 
        loading: false
        messages: res

ChatItem = React.createClass
  render: ->
    # message = {
    #   id: '...'
    #   time: '...'
    #   talker: {
    #     member_id: '...'
    #     name: '...'
    #   }
    #   content: {
    #     text: '...'
    #   }
    # }

    message = @props.message

    <div key={message.id} className='chat-item'>
      <ChatCharAvatar user={message.talker} />
      <div className='m-content'>
        <div className='talker'>
          <span className='name'>{message.talker.name}</span>
          <span className='time'>{new Date(message.time).format('hh:mm:ss')}</span>
        </div>
        <div className='text'>{message.content.text}</div>
      </div>
    </div>


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

    content = { text: @state.text }
    @setState text: ''

    # 单聊
    if @props.with_member
      receiver_id = @props.with_member.id
      App.room.speak_single receiver_id, content

    # 机构群聊
    if @props.with_org
      org_id = @props.with_org.id
      App.room.speak_organization org_id, content
