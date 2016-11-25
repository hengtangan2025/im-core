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
    data = []
    for i in @props.questions
      kind_s = ''
      answer_s = ''
      if i.kind == "single_choice"
        kind_s = "单选题"
      if i.kind == "multi_choice"
        kind_s = "多选题"
      if i.kind == "bool"
        kind_s = "判断题"

      if i.answer instanceof Array
        for j in i.answer
          answer_s += "#{j}，"
        answer_s = answer_s.substring(0, answer_s.length - 1)
      else
        answer_s = i.answer

      data.push({
        content: i.content,
        kind: kind_s,
        answer: answer_s
      })

      

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

