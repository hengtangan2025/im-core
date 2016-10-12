module.exports = ChatPageCurrentUser = React.createClass
  render: ->
    <div className='current-user-bar'>
      <ChatCharAvatar user={window.current_user} />
      <Signout />
    </div>

Signout = React.createClass
  render: ->
    <a className='sign-out-link' title='登出' onClick={@sign_out}>
      <FaIcon type='sign-out' />
    </a>

  sign_out: ->
    # DELETE /resource/sign_out
    jQuery.ajax
      type: 'DELETE'
      url: '/users/sign_out'
    .done (res)->
      window.location.href = '/'