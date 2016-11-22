{ Table } = antd

module.exports = TagsIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "TAG名"
        dataIndex: "name"
      }
      {
        title: "TAG 关联 FAQ"
        dataIndex: "faqs"
      }
      {
        title: "TAG 关联参考资料"
        dataIndex: "references"
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
        name: "TAG1",
        faqs: "FAQ1, FAQ2",
        references: "资料1，资料2",
        id: "",
      },
      {
        name: "TAG2",
        faqs: "FAQ2, FAQ3",
        references: "资料2，资料3",
        id: "",
      }
    ]


    <div className='sample-tags-table'>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "XXXXX"
    .done (res)->
      console.log(res.message)