{ Tree, Icon } = antd
TreeNode = Tree.TreeNode

module.exports = OrganizationTree = React.createClass
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

  do_select_node: (selected_keys, evt)->
    node = evt.node

    if org = node.props.org
      @props.do_select_node(org)
    if member = node.props.member
      @props.do_select_node(member)