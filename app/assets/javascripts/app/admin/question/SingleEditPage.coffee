{ Form, Input, Button,Select, Radio  } = antd

FormItem = Form.Item
Option = Select.Option
RadioGroup = Radio.Group

Page = React.createClass
  getInitialState: ()->
    radio_count: 4
    value: 1

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


    radio_data =
      on_change: @onChange
      del_radio: @delete_radio
      add_radio: @add_radio_event
      radio_count: @state.radio_count
      value: @state.value


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
            initialValue: "单选"
          })(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
          {getFieldDecorator('Questions[answer]')(
            <RadioEvent data={radio_data} />
          )}
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
    this.setState({
      value: e.target.value,
    })

  add_radio_event: ()->
    @setState
      radio_count: @state.radio_count + 1

  delete_radio: (data)->
    @setState
      radio_count: data

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

RadioEvent = React.createClass
  render: ->
    <RadioGroup onChange={@props.data.on_change}>
      { 
        for i in [1..@props.data.radio_count]
          <Radio  className="radio-event-style" key="#{i}"  value={i}>
            <Input className="in-radio-input" placeholder="请输入选项内容" type="textarea" rows={6} />
            <a href="javascript:;" onClick={@del_radio_event.bind(null, this)}>删除选项</a>
          </Radio>
      }
    </RadioGroup>

  del_radio_event: ()->
    if @props.data.radio_count > 1
      data = @props.data.radio_count - 1
      @props.data.del_radio(data)

module.exports = SingleEditPage = Form.create()(Page)