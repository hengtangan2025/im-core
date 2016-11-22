{ Table } = antd

module.exports = FaqsIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "问题"
        dataIndex: "question"
      }
      {
        title: "解答"
        dataIndex: "anwser"
      }
      {
        title: "参考资料"
        dataIndex: "references"
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
        question: "1 + 1 = ？",
        anwser: "2",
        references: "资料1",
        tags: "TAG1"
        id: "",
      },
      {
        question: "李白是哪个朝代的人？",
        anwser: "唐朝",
        references: "资料2",
        tags: "TAG2"
        id: "",
      },
      {
        question: "为什么都是先看到闪电，再听到雷声？",
        anwser: "因为光的传播速度比声音的传播速度快。",
        references: "资料3",
        tags: "TAG3"
        id: "",
      },
      {
        question: "参考资料1",
        anwser: "描述描述",
        references: "资料4",
        tags: "TAG4"
        id: "",
      }
    ]

      
    <div className='sample-faqs-table'>
      <a className='ant-btn ant-btn-primary' href="#">新增 FAQ</a>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>


  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "XXXXX"
    .done (res)->
      console.log(res.message)