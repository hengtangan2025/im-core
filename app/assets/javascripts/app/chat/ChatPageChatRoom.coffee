{ Alert } = antd

module.exports = ChatRoom = React.createClass
  render: ->
    <div className='chat-room'>
      <div className='header'>
        <FaIcon type='user' /> {@props.with_member.name}
      </div>
      <ChatList with_member={@props.with_member} />
      <ChatInputer />
    </div>

ChatList = React.createClass
  getInitialState: ->
    messages: []

  render: ->
    <div className='chat-list'>
      <Alert message="你正在和 @#{@props.with_member.name} 聊天" type="info" />
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
      if @state.text != ''
        App.room.speak {
          text: @state.text
        }
        @setState text: ''