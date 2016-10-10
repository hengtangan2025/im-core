{ Alert } = antd

module.exports = ChatRoom = React.createClass
  getInitialState: ->
    talker_name = localStorage['chatter_name'] || "访客-#{randstr()}"
    localStorage['chatter_name'] = talker_name

    talker: {
      name: talker_name
    }

  render: ->
    <div className='chat-room'>
      <div className='header'>
        <FaIcon type='user' /> {@props.with_member.name}
      </div>
      <ChatList with_member={@props.with_member} />
      <ChatInputer talker={@state.talker} />
    </div>

ChatList = React.createClass
  getInitialState: ->
    messages: []

  render: ->
    <div className='chat-list'>
      <Alert message="你正在和 @#{@props.with_member.name} 聊天" type="info" />
      {
        for message, idx in @state.messages
          <div key={idx}>
            <strong>{message.talker.name}: </strong>
            <span>{message.text}</span>
          </div>
      }
    </div>

  componentDidMount: ->
    jQuery(document)
      .off 'received-message'
      .on 'received-message', (evt, data)=>
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
          talker: @props.talker
        }
        @setState text: ''