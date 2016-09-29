module.exports = ChatPage = React.createClass
  render: ->
    <div className='chat-page'>
      <Sidebar {...@props} />
    </div>

Sidebar = React.createClass
  render: ->
    <div className='sidebar'>
      <div className='header'>示例组织机构</div>
      <OrganizationTree data={@props.organization_tree} />
    </div>

{ Tree } = antd
TreeNode = Tree.TreeNode

OrganizationTree = React.createClass
  render: ->
    root = @props.data

    <div className='org-tree'>
      <Tree defaultExpandAll>
        <TreeNode title={root.name} key={root.id}>
        {@subtree(root.children) if root.children.length}
        </TreeNode>
      </Tree>
    </div>

  subtree: (children)->
    for child in children
      <TreeNode title={child.name} key={child.id}>
      {@subtree(child.children) if child.children.length}
      </TreeNode>
