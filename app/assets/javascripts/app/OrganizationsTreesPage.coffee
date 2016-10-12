{ Button, Alert } = antd

module.exports = OrganizationsTreesPage = React.createClass
  render: ->
    root = @props.tree_roots[0]

    url = root.path

    <div style={maxWidth: 500}>
      <Alert type='info' 
        message='你正在访问开发中的体验环境'
        description="测试机构 ID: #{root.id}" 
      />
      <a className='ant-btn ant-btn-primary' href={url}>
        <FaIcon type='arrow-right' /> 进入测试环境
      </a>
    </div>