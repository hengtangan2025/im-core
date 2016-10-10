module.exports = ChatPageCurrentUser = React.createClass
  render: ->
    <div className='current-user-bar'>
      <Avatar />
      <Signout />
    </div>

Avatar = React.createClass
  render: ->
    current_user = window.current_user
    <div className='avatar-first-char'>{current_user.name[0]}</div>

Signout = React.createClass
  render: ->
    # DELETE /resource/sign_out

    <a className='sign-out-link' title='登出' onClick={@sign_out}>
      <FaIcon type='sign-out' />
    </a>

  sign_out: ->
    jQuery.ajax
      type: 'DELETE'
      url: '/users/sign_out'
    .done (res)->
      window.location.href = '/'