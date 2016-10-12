{ Tree, Icon } = antd
TreeNode = Tree.TreeNode

module.exports = OrganizationTree = React.createClass
  getInitialState: ->
    reminds: {} # 用来记录各个聊天室积累了多少未读消息

  render: ->
    tree = @props.organization_tree

    <div className='org-tree'>
      <Tree 
        defaultExpandAll
        defaultSelectedKeys={[@props.selected_node.id]}
        onSelect={@do_select_node}
      >
        {@org_node(tree)}
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

    <TreeNode 
      title={@org_title(org)} 
      key={org.id} org={org}
    >
    {
      for item in arr
        switch item.type
          when 'org'
            @org_node(item.org)
          when 'member'
            member = item.member
            <TreeNode className='member-node'
              title={@member_title(member)}
              key={member.id} member={member} 
            />
    }
    </TreeNode>

  org_title: (org)->
    room_key = org.id
    remind = @state.reminds[room_key]

    <span className='tree-node-title'>
      <FaIcon type='circle-o' />
      <span className='name'>{org.name}</span>
      {
        if remind
          <span className='remind'>{remind}</span>
      }
    </span>

  member_title: (member)->
    room_key = [current_user.member_id, member.id].sort().join('-')
    remind = @state.reminds[room_key]

    <span className='tree-node-title'>
      <FaIcon type='user' />
      <span className='name'>{member.name}</span>
      {
        if remind
          <span className='remind'>{remind}</span>
      }
    </span>

  do_select_node: (selected_keys, evt)->
    node = evt.node

    if org = node.props.org
      @props.do_select_node(org)
      reminds = @state.reminds
      delete reminds[org.id]
      @setState reminds: reminds

    if member = node.props.member
      @props.do_select_node(member)
      reminds = @state.reminds
      room_key = [current_user.member_id, member.id].sort().join('-')
      delete reminds[room_key]
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
