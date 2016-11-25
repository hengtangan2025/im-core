{ Table,Button } = antd

module.exports = QuestionIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "问题"
        dataIndex: "content"
      }
      {
        title: "类型"
        dataIndex: "kind"
      }
      {
        title: "选项"
        dataIndex: "answer"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div className="admin-option-tag-a">
            <a className='ant-btn ant-btn-primary' href="#">编辑</a>
            <a className='ant-btn ant-btn-primary' href="#" onClick={@delete.bind(this, record)} >删除</a>
          </div>
      }
    ]
    # data = []
    # for i in @props.questions
    #   question_s = ''
    #   for j in i.answer
    #     question_s += "#{j}，"

    #   data.push({
    #     content: i.content,
    #     kind: i.kind,
    #     answer: question_s,
    #     id: i.id
    #   })
    data = [
      {
        content: "中国有几个直辖市？",
        kind: "单选",
        answer: "3个，4个，5个，6个",
        id: "11111111"
      },{
        content: "下列哪个是直辖市？",
        kind: "多选",
        answer: "北京，广州，深圳，上海，",
        id: "222222222"
      },{
        content: "天津市是沿海城市吗？",
        kind: "判断题",
        answer: "对，错",
        id: "3333333333"
      }
    ]

    <div className='sample-users-table'>
      <div className="admin-tag-a">
        <a className='ant-btn ant-btn-primary' href={@props.single_new_url}>新增单选题</a>
        <a className='ant-btn ant-btn-primary' href={@props.multi_new_url}>新增多选题</a>
        <a className='ant-btn ant-btn-primary' href={@props.bool_new_url}>新增判断题</a>
      </div>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "#"
    .done (res)->
      console.log(res.message)

