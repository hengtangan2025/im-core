{ Form, Input, Button,Select, Checkbox  } = antd

FormItem = Form.Item
Option = Select.Option
CheckboxGroup = Checkbox.Group

Page = React.createClass
  getInitialState: ()->
    check_box_count: 4
    value: 1

  render: ->
    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 2 },
    }
    tailFormItemLayout = {
      wrapperCol: {
        offset: 2,
      },
    }

    check_data = 
      check_box_count: @state.check_box_count
      on_change: @onChange
      del_function:@delete_check_box

    <div className='user-new-page'>
      <div className='user-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="问题"
          >
          {getFieldDecorator('Questions[name]', {
            rules: [{
              required: true, message: '请输入问题'
            }]
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
            initialValue: "多选"
          })(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
          {getFieldDecorator('Questions[answer]')(
            <CheckboxEvent data={check_data} />
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
             <a className='ant-btn ant-btn-primary' href="javascript:;" onClick={@add_check_box.bind(null, this)}>增加选项</a>
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

  submit: (evt)->
    evt.preventDefault()
    this.props.form.validateFields (err, values)->
      if !err
        console.log('Received values of form: ', values)
        
    # data = @props.form.getFieldsValue()
    # if @props.questions.name == null
    #   jQuery.ajax
    #     type: 'POST'
    #     url: @props.submit_url
    #     data: data
    # else
    #   jQuery.ajax
    #     type: 'PUT'
    #     url: @props.submit_url
    #     data: data
  onChange: (checkedValues)->
    console.log('checked = ', checkedValues)

  add_check_box: ()->
    data = @state.check_box_count + 1
    @setState
      check_box_count: data

  delete_check_box: (data)->
    @setState
      check_box_count: data

CheckboxEvent = React.createClass
  render: ->
    <div className="multi-question-check-box">
      {
        for i in [1..@props.data.check_box_count]
          <Checkbox className="form-textarea" onChange={@props.data.on_change} key="#{i}" value={i}>
            <Input className="form-radio-input" placeholder="请输入选项内容" type="textarea" rows={5} />
            <a href="javascript:;" onClick={@delete_box.bind(null, this)}>删除选项</a>
          </Checkbox>
      }
    </div>

  delete_box: ()->
    if @props.data.check_box_count > 1
      data = @props.data.check_box_count - 1
      @props.data.del_function(data)

module.exports = MultiEditPage = Form.create()(Page)