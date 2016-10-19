module.exports = OrganizationNodeShow = React.createClass
  render: ->
    node = @props.node_data
    <div>
      <div>{node.name}</div>
      {
        if node.parent?
          <div>上级：{node.parent?.name}</div>
      }
      <div>
      {
        for child in node.children
          <div key={child.id}>下级：{child.name}</div>
      }
      </div>
      <div>
        <a href="/organizations/#{node.id}/show_tree">[显示机构树]</a>
      </div>
    </div>