module.exports = OrganizationTreePage = React.createClass
  render: ->
    node = @props.tree_data
    <TreeNode key={node.id} node={node} />

TreeNode = React.createClass
  render: ->
    children_style = {
      marginLeft: 20
    }

    node = @props.node

    show_path = "/organizations/#{@props.node.id}"

    <div>
      <div>
        {node.name}: <a href={show_path}>{show_path}</a>
      </div>
      <div className='children' style={children_style}>
      {
        for child in node.children
          <TreeNode key={child.id} node={child} />
      }
      </div>
    </div>