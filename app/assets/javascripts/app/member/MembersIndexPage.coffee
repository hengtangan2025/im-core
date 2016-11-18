{ Table,Button } = antd

module.exports = MembersIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "用户名"
        dataIndex: "membername"
      }
      {
        title: "邮箱"
        dataIndex: "email"
      }
      {
        title: "工号"
        dataIndex: "job_number"
      }
      {
        title: "所属机构"
        dataIndex: "organization_nodes"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div>
            <Button type="primary"><a href="/members/#{record}/edit">编辑</a></Button>
            <Button type="primary" data={record} onClick={@delete.bind(this,record)}>删除</Button>
          </div>
      }
    ]

    data = @props.members
    console.log(data)

    <div className='sample-users-table'>
      <Button type="primary"><a href="/members/new">新增用户</a></Button>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    delete_url = "/members/#{data}"
    # DELETE /members/:id
    jQuery.ajax
      type: 'DELETE'
      url: delete_url
    .done (res)->
      console.log(res.message)

