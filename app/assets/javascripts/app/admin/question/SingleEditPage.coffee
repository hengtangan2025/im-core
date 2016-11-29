{ Form, Input, Button,Select, Radio  } = antd

FormItem = Form.Item
Option = Select.Option
RadioGroup = Radio.Group

Page = React.createClass
  getInitialState: ()->
    radio_count: @props.choice_count || 4
    value: @props.questions.answer["correct"] || 1
    input_value_ary: @props.questions.answer["choices"] || []
    radio_checked: ''

  render: ->
    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 3 },
    }
    tailFormItemLayout = {
      wrapperCol: {
        offset: 2,
      },
    }

    ary = @state.input_value_ary
    if ary.length < @state.radio_count
      for j in [1..@state.radio_count]
        ary.push({id: "#{j}", text: ""})
    else
      ary = @state.input_value_ary

    <div className='user-new-page'>
      <div className='user-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="问题"
          >
          {getFieldDecorator('Questions[content]', {
            rules: [{
              required: true, message: '请输入问题'
            }],
            initialValue: @props.questions.content
          })(
            <Input className="form-textarea" placeholder="请输入问题" type="textarea" rows={6} />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="类型"
          >
          {getFieldDecorator('Questions[kind]', {
            rules: [{
              required: true, message: '请输入类型',
            }],
            initialValue: "单选"
          })(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
            <RadioGroup onChange={@onChange} value={@state.value}>
              { 
                if  @props.questions.answer != null
                  for i in [1..@state.radio_count] 
                    <Radio  className="radio-event-style" key={ary[i-1].id+ary[i-1].text}  value={@props.questions.answer["choices"][i - 1].id} >
                      <Input className="in-radio-input" placeholder="请输入选项内容" type="textarea" id="#{i}" rows={6} onBlur={@input_on_change} 
                        defaultValue={@props.questions.answer["choices"][i - 1].text} />
                      <a href="javascript:;" onClick={@delete_radio.bind(this, i)}>删除选项</a>
                    </Radio>
                else
                  for i in [1..@state.radio_count]
                    <Radio  className="radio-event-style" key={ary[i-1].id+ary[i-1].text}  value={i}>
                      <Input className="in-radio-input" placeholder="请输入选项内容" type="textarea" id="#{i}" rows={6} onBlur={@input_on_change} defaultValue={ary[i-1].text} />
                      <a href="javascript:;" onClick={@delete_radio.bind(this, i)}>删除选项</a>
                    </Radio>
              }
            </RadioGroup>
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
            <a className='ant-btn ant-btn-primary' href="javascript:;" onClick={@add_radio_event.bind(null, this)}>增加选项</a>
          </FormItem>

          <FormItem
            {...tailFormItemLayout}
          >
            <Button type="primary" htmlType="submit" className="form-button">
              <FaIcon type='check' /> 确定
            </Button>
            <a className='ant-btn ant-btn-primary' href={@props.cancel_url}>
              <FaIcon type='close' /> 取消
            </a>
          </FormItem>

        </Form>
      </div>
    </div>

  onChange: (e)->
    console.log('radio checked', e.target.value)
    @setState
      radio_checked: e.target.value
      value: e.target.value

  input_on_change: (e)->
    if @props.questions.answer != null
      data = @props.questions.answer.choice
    else
      data = @state.input_value_ary

    need_value_push = {id: e.target.id, text:e.target.value}
    id_ary = []
    for i in data
      id_ary.push(i.id)

    if data.length == 0 && e.target.value != "" 
      data.push(need_value_push)
    else
      if id_ary.indexOf(need_value_push.id) == -1 && e.target.value != ""
        data.push(need_value_push)

      if id_ary.indexOf(need_value_push.id) != -1 && e.target.value != ""
        for i in data 
          if need_value_push.id == i.id
            i.text = need_value_push.text

      @setState
        input_value_ary:data

  add_radio_event: ()->
    temp_ary = @state.input_value_ary
    temp_ary.push({id:"#{parseInt(temp_ary[temp_ary.length-1].id) + 1}", text: ""})
    console.log temp_ary
    @setState
      radio_count: @state.radio_count + 1
      input_value_ary: temp_ary

  delete_radio: (key_num)->
    temp_ary = @state.input_value_ary
    if @state.radio_count > 1
      for i in [0...temp_ary.length]
        if temp_ary[i].id == String(key_num)
          temp_ary.splice(i, 1)
          break

      if temp_ary[0].id == "2"
            temp_ary[0].id = String(parseInt(temp_ary[0].id) - 1)

      for j in [0...temp_ary.length]
        if j < temp_ary.length - 1
          if parseInt(temp_ary[j+1].id) - parseInt(temp_ary[j].id) == 2
            temp_ary[j+1].id = String(parseInt(temp_ary[j+1].id) - 1)

      data = @state.radio_count - 1
      @setState
        radio_count: data
        input_value_ary: temp_ary

  submit: (evt)->
    evt.preventDefault()
    this.props.form.validateFields (err, data)->
      return if !err

    data = @props.form.getFieldsValue()
    if data["Questions[kind]"] == "单选"
      data["Questions[kind]"] = "single_choice"

    # 当修改选项时
    if @state.input_value_ary.length >= 1
      checked_correct = ''
      if @state.radio_checked == '' && @props.questions.answer != null
        checked_correct = @props.questions.answer.correct
      else
        checked_correct = @state.radio_checked

      data["Questions[answer]"] = {
        choice: @state.input_value_ary,
        correct: checked_correct
      }

    method = ''
    if @props.questions.content == null
      method = "POST"
    else
      method = "PUT"

    if data["Questions[answer]"].choice.length == 0
      alert "请输入选项内容"
    else if data["Questions[answer]"].correct == ''
      alert '请选择正确答案'
    else
      json_string = JSON.stringify data
      jQuery.ajax
        type: method,
        url: @props.submit_url,
        data: 
          "json_string": json_string

module.exports = SingleEditPage = Form.create()(Page)