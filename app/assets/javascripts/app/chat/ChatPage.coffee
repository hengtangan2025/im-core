module.exports = ChatPage = React.createClass
  getInitialState: ->
    selected_node: @props.organization_tree

  render: ->
    ChatRoom = ChatPageChatRoom
    CurrentUser = ChatPageCurrentUser

    <div className='chat-page'>
      <Sidebar {...@props} select_node={@select_node} />
      <CurrentUser />
      {
        if @state.selected_node.members
          <MembersTable node={@state.selected_node} />
        else
          <ChatRoom with_member={@state.selected_node} />
      }
    </div>

  select_node: (node)->
    console.log node
    @setState selected_node: node

OrganizationTree = ChatPageOrganizationTree

Sidebar = React.createClass
  render: ->
    <div className='sidebar'>
      <div className='header'>示例组织机构</div>
      <OrganizationTree data={@props.organization_tree}  select_node={@props.select_node} />
    </div>


{ Table } = antd
MembersTable = React.createClass
  render: ->
    data_source = @props.node.members
    columns = [
      {
        title: '工号'
        dataIndex: 'job_number'
        key: 'job_number'
      }
      {
        title: '姓名'
        dataIndex: 'name'
        key: 'name'
      }
    ]


    <div className='members-table'>
      <div className='header'>机构成员</div>
      <div className='table-c' style={maxWidth: 900}>
        <div style={paddingBottom: 20}>{@props.node.name}</div>
        <Table bordered size='middle' dataSource={data_source} columns={columns} rowKey="job_number" />
      </div>
    </div>