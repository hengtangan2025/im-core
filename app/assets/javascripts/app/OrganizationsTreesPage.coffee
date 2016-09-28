module.exports = OrganizationsTreesPage = React.createClass
  render: ->
    <div>
    {
      for root in @props.tree_roots
        <div key={root.id}>
          {root.name}: <a href={root.path}>{root.path}</a>
        </div>
    }
    </div>