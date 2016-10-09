{ Tree, Icon } = antd
TreeNode = Tree.TreeNode

module.exports = OrganizationTree = React.createClass
  render: ->
    root = @props.data

    <div className='org-tree'>
      <Tree 
        defaultExpandAll
        defaultSelectedKeys={[root.id]}
        onSelect={@select_node}
      >
        {@org_node(root)}
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
      title={<span><FaIcon type='circle-o' /> {org.name}</span>} 
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
              title={<span><FaIcon type='user' /> {member.name}</span>}
              key={member.id} member={member} 
            />
    }
    </TreeNode>

  select_node: (selected_keys, evt)->
    node = evt.node

    if org = node.props.org
      @props.select_node(org)
    if member = node.props.member
      @props.select_node(member)