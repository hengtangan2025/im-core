module.exports = ChatPage = React.createClass
  getInitialState: ->
    selected_node: @props.organization_tree

  render: ->
    <div className='chat-page'>
      <Sidebar {...@props} select_node={@select_node} />
      <MembersTable node={@state.selected_node} />
      <ChatRoom />
    </div>

  select_node: (node)->
    @setState selected_node: node

Sidebar = React.createClass
  render: ->
    <div className='sidebar'>
      <div className='header'>示例组织机构</div>
      <OrganizationTree data={@props.organization_tree}  select_node={@props.select_node} />
    </div>

{ Tree } = antd
TreeNode = Tree.TreeNode

OrganizationTree = React.createClass
  render: ->
    root = @props.data

    <div className='org-tree'>
      <Tree 
        defaultExpandAll
        defaultSelectedKeys={[root.id]}
        onSelect={@select_node}
      >
        <TreeNode title={root.name} key={root.id} org={root}>
        {@subtree(root.children) if root.children.length}
        </TreeNode>
      </Tree>
    </div>

  subtree: (children)->
    for child in children
      <TreeNode title={child.name} key={child.id} org={child}>
      {@subtree(child.children) if child.children.length}
      </TreeNode>

  select_node: (selected_keys, evt)->
    node = evt.node.props.org
    @props.select_node(node)


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


ChatRoom = React.createClass
  getInitialState: ->
    talker_name = localStorage['chatter_name'] || "访客-#{randstr()}"
    localStorage['chatter_name'] = talker_name

    talker: {
      name: talker_name
    }

  render: ->
    <div className='chat-room'>
      <ChatList />
      <ChatInputer talker={@state.talker} />
    </div>

ChatList = React.createClass
  getInitialState: ->
    messages: []

  render: ->
    <div className='chat-list'>
    {
      for message, idx in @state.messages
        <div key={idx}>
          <strong>{message.talker.name}: </strong>
          <span>{message.text}</span>
        </div>
    }
    </div>

  componentDidMount: ->
    jQuery(document)
      .off 'received-message'
      .on 'received-message', (evt, data)=>
        messages = @state.messages
        messages.push data
        @setState messages: messages


ChatInputer = React.createClass
  getInitialState: ->
    text: ''

  render: ->
    <div className='chat-inputer'>
      <textarea 
        placeholder='在这里说话~' 
        value={@state.text} 
        onChange={@change} 
        onKeyDown={@keydown}
      />
    </div>

  change: (evt)->
    @setState text: evt.target.value

  keydown: (evt)->
    if evt.which is 13
      evt.preventDefault()
      if @state.text != ''
        App.room.speak {
          text: @state.text
          talker: @props.talker
        }
        @setState text: ''