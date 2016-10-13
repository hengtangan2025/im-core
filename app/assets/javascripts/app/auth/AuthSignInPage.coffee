{ Form, Input, Button, Checkbox } = antd
{ Table } = antd

FormItem = Form.Item

Page = React.createClass
  render: ->
    { getFieldDecorator } = @props.form

    <div className='auth-sign-in-page'>
      <div className='auth-form'>
        <Form onSubmit={@submit}>
          <FormItem label='邮箱'>
          {getFieldDecorator('user[email]')(
            <Input placeholder="输入邮箱" />
          )}
          </FormItem>

          <FormItem label='密码'>
          {getFieldDecorator('user[password]')(
            <Input placeholder="输入密码" />
          )}
          </FormItem>

          <FormItem>
          {getFieldDecorator('user[remember_me]')(
            <Checkbox>记住我</Checkbox>
          )}
          </FormItem>

          <FormItem>
            <Button type="primary" htmlType="submit">
              <FaIcon type='check' /> 确定登录
            </Button>
          </FormItem>
        </Form>
      </div>

      <SampleTable users={@props.users} />
    </div>

  submit: (evt)->
    evt.preventDefault()
    data = @props.form.getFieldsValue()

    console.log data
    
    jQuery.ajax
      type: 'POST'
      url: @props.submit_url
      data: data



SampleTable = React.createClass
  render: ->
    columns = [
      {
        title: '邮箱'
        dataIndex: 'email'
      }
      {
        title: '用户名'
        dataIndex: 'name'
      }
      {
        title: '密码'
        dataIndex: 'password'
      }
    ]

    data = @props.users

    <div className='sample-users-table'>
      <h3>你可以使用这些测试用户登录：</h3>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

module.exports = AuthSignInPage = Form.create()(Page)