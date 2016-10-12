module.exports = ChatPage = React.createClass
  getInitialState: ->
    selected_node: @load_selected_node()

  render: ->
    <div className='chat-page'>
      <Sidebar {...@props} 
        do_select_node={@do_select_node}
        selected_node={@state.selected_node}
      />
      <ChatPageCurrentUser />
      {@render_chat_room()}
    </div>

  render_chat_room: ->
    if @state.selected_node.members
      <ChatPageChatRoom with_org={@state.selected_node} />
    else
      <ChatPageChatRoom with_member={@state.selected_node} />

  do_select_node: (node)->
    @setState selected_node: node
    localStorage['selected_room_id'] = node.id

  load_selected_node: ->
    if localStorage['selected_room_id']?# and false
      # 递归找到被选中的节点
      node = @_r_load_selected_node(localStorage['selected_room_id'], @props.organization_tree)
    else
      node = @props.organization_tree
      localStorage['selected_room_id'] = node.id

    node

  _r_load_selected_node: (id, node)->
    return node if id == node.id
    re = null
    for child in (node.children || [])
      break if re?
      re = @_r_load_selected_node(id, child)
    for member in (node.members || [])
      break if re?
      re = @_r_load_selected_node(id, member)

    return re

  componentDidMount: ->
    return if not Notification?

    if Notification.permission == 'granted'
      # 已授权
      # new Notification('hello!', {
      #   body: '这是一条通知消息'
      #   # icon: 'http://i.teamkn.com/i/fvnih9Ar.png'
      #   icon: 'http://i.teamkn.com/i/jysbxKvq.png'
      # })
    else
      # 未授权，请求授权
      Notification?.requestPermission ->
        new Notification("已经允许浏览器通知 :)")


Sidebar = React.createClass
  render: ->
    <div className='sidebar'>
      <div className='header'>示例组织机构</div>
      <ChatPageOrganizationTree {...@props} />
    </div>
