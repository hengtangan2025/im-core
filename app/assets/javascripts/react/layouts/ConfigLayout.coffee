module.exports = ConfigLayout = React.createClass
  render: ->
    <div className='config-layout'>
      <YieldComponent component={@props.content_component} />
    </div>