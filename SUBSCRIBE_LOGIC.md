## 消息广播和订阅策略



### 消息广播策略

```coffeescript
# 消息发送成员 id
sender_id = current_user.member_id
```



#### 单聊消息广播

```coffeescript
# 房间标识
room_key = sender_id
# 接收者清单
receivers = [receiver]
```

客户端消息包装：

```coffeescript
# 消息发送者不传，在服务端获取认证信息
App.room.speak {
  room: {
  	type: 'SINGLE'
    key: '...' # ChatRoom.get_single_key(sender, receiver)
  }
  content: {
    text: '...'
  }
}
```



#### 机构聊天消息广播

```coffeescript
# 房间标识
room_key = org.id
# 接收者清单
receivers = org.nested_members # 组织机构的全部成员
```

客户端消息包装：

```coffeescript
# 消息发送者不传，在服务端获取认证信息
App.room.speak {
  room: {
  	type: 'ORGANIZATION'
    key: '...'
  }
  content: {
    text: '...'
  }
}
```



#### 群组聊天消息广播

```coffeescript
# 房间标识
room_key = group.id
# 接收者清单
receivers = group.members
```

客户端消息包装：

```coffeescript
# 消息发送者不传，在服务端获取认证信息
App.room.speak {
  room: {
  	type: 'GROUP'
    key: '...'
  }
  content: {
    text: '...'
  }
}
```

