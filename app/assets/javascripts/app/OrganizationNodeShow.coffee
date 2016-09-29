module.exports = OrganizationNodeShow = React.createClass
  render: ->
    node = @props.node_data
    <div>{node.name}</div>