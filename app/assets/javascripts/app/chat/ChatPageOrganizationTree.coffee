{ Tree, Icon } = antd
TreeNode = Tree.TreeNode

module.exports = OrganizationTree = React.createClass
  getInitialState: ->
    # 用来记录各个聊天室积累了多少未读消息
    # {
    #   room_key1: 1
    #   room_key2: 3
    #   room_key3: 5
    # }
    reminds: {} 

  render: ->
    <div className='org-tree'>
      <Tree 
        defaultExpandAll
        defaultSelectedKeys={[@props.selected_node.id]}
        onSelect={@do_select_node}
      >
        {@org_node(@props.organization_tree)}
      </Tree>
    </div>

  org_node: (org)->
    children = org.children.map (x)->
      type: 'org'
      org: x

    members = org.members.map (x)->
      type: 'member'
      member: x

    arr = members.concat children

    <TreeNode className='org-node'
      title={@node_title(org)} 
      key={org.id} 
      _node={org}
    >
    {
      for item in arr
        switch item.type
          when 'org'
            @org_node(item.org)
          when 'member'
            member = item.member
            <TreeNode className='member-node'
              title={@node_title(member)}
              key={member.id} 
              _node={member} 
            />
    }
    </TreeNode>

  node_title: (node)->
    <span className='tree-node-title'>
      {@_title_icon(node)}
      <span className='name'>{node.name}</span>
      {
        if remind = @state.reminds[@_room_key(node)]
          <span className='remind'>{remind}</span>
      }
    </span>

  _title_icon: (node)->
    # 机构房间 
    return <FaIcon type='circle-o' /> if node.members
    # 成员房间
    return <FaIcon type='user' />

  _room_key: (node)->
    # 机构房间 
    return node.id if node.members
    # 成员房间
    return [current_user.member_id, node.id].sort().join('-')

  do_select_node: (selected_keys, evt)->
    node = evt.node
    _node = node.props._node

    @props.do_select_node(_node)
    reminds = @state.reminds
    delete reminds[@_room_key(_node)]
    @setState reminds: reminds

  componentDidMount: ->
    jQuery(document)
      .off 'show-remind-message'
      .on 'show-remind-message', (evt, data)=>
        console.log 'show remind', data
        reminds = @state.reminds
        reminds[data.room.key] ||= 0
        reminds[data.room.key] += 1
        @setState reminds: reminds
