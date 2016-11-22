{ Table } = antd

module.exports = ReferencesIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "资料名"
        dataIndex: "name"
      }
      {
        title: "资料描述"
        dataIndex: "description"
      }
      {
        title: "资料类型"
        dataIndex: "type"
      }
      {
        title: "关键词"
        dataIndex: "tags"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div>
            <a className='ant-btn ant-btn-primary' href="#">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' href="#">
              删除
            </a>
          </div>
      }
    ]

    data = [
      {
        name: "参考资料1",
        description: "描述描述",
        type: "文章",
        tags: "TAG1"
        id: "",
      },
      {
        name: "参考资料2",
        description: "描述描述",
        type: "文档",
        tags: "TAG2"
        id: "",
      },
      {
        name: "参考资料3",
        description: "描述描述",
        type: "链接",
        tags: "TAG3"
        id: "",
      },
      {
        name: "参考资料4",
        description: "描述描述",
        type: "视频",
        tags: "TAG4"
        id: "",
      }
    ]

      
    <div className='sample-references-table'>
      <a className='ant-btn ant-btn-primary' href="#">新增参考资料</a>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "XXXXX"
    .done (res)->
      console.log(res.message)