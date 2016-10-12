module.exports = ChatCharAvatar = React.createClass
  render: ->
    user = @props.user
    char = user.name[0]

    astyle = {
      backgroundColor: color20(user.member_id)
    }

    <div className='avatar-first-char' style={astyle}>
      {char}
    </div>