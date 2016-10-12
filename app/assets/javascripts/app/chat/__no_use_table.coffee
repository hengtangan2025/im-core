{ Table } = antd
MembersTable = React.createClass
  render: ->
    data_source = @props.node.members
    columns = [
      {
        title: '工号'
        dataIndex: 'job_number'
        key: 'job_number'
      }
      {
        title: '姓名'
        dataIndex: 'name'
        key: 'name'
      }
    ]


    <div className='members-table'>
      <div className='header'>机构成员</div>
      <div className='table-c' style={maxWidth: 900}>
        <div style={paddingBottom: 20}>{@props.node.name}</div>
        <Table bordered size='middle' dataSource={data_source} columns={columns} rowKey="job_number" />
      </div>
    </div>