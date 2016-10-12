## 工程初始化步骤



**!!! 以下都是 ben7th 的临时记录，请勿参考**



### 修改 Gemfile

```ruby
source 'https://gems.ruby-china.org'
```



### 添加 config/mongoid.yml

```yaml
development:
  clients:
    default:
      database: im_core_development
      hosts:
        - localhost:27017

test:
  clients:
    default:
      database: im_core_test
      hosts:
        - localhost:27017
      options:
        read:
          mode: :primary
        max_pool_size: 1
```



### 添加 package.json

```json
{
  "name": "bbn-weixin-reply",
  "dependencies": {
    "browserify": "~> 10.2.4",
    "browserify-incremental": "^3.0.1",
    "coffee-reactify": "~> 5.0.0",
    "urijs": "^1.18.1"
  },
  "license": "MIT",
  "engines": {
    "node": ">= 0.10"
  }
}
```

```shell
npm install
```





### 修改 .gitignore

```
application.yml

/node_modules
```



### 修改 config/application.rb

```ruby
### 各种猴子补丁
config.to_prepare do
  # Load application's model / class decorators
  Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
    Rails.configuration.cache_classes ? require(c) : load(c)
  end
end

### browserify coffee 引用
config.browserify_rails.commandline_options = "-t coffee-reactify --extension='.coffee'"
```



### 添加基础 js

libs.coffee

```coffeescript
#= require jquery
#= require jquery_ujs
#= require turbolinks

#= require react
#= require react_ujs

#= require antd/antd-1.6.4.min

window.URI = require 'urijs'
```

application.coffee

```coffeescript
# utils
window.ClassName = require 'utils/ClassName'

# http://fontawesome.io/icons/
window.FaIcon = require 'utils/FaIcon'

# # layouts
window.YieldComponent = require 'react/layouts/YieldComponent'
window.ConfigLayout = require 'react/layouts/ConfigLayout'

# components
window.WeixinConfig = require 'react/weixin/WeixinConfig'
```



### 添加 app/views/layouts/application.html.haml

```haml
!!!
%html
  %head
    %meta{:'http-equiv' => 'Content-Type', content: 'text/html; charset=UTF-8'}
    %meta{:'http-equiv' => 'X-UA-Compatible', content: 'IE=edge, chrome=1'}
    %meta{name: 'viewport', content: 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'}
    %meta{name: 'renderer', content: 'webkit'}

    %title Homepage

    = stylesheet_link_tag 'application', media: 'all', :'data-turbolinks-track' => true

    = javascript_include_tag 'libs', :'data-turbolinks-track' => true
    = javascript_include_tag 'application', :'data-turbolinks-track' => true

    = csrf_meta_tags

  %body
    :ruby
      content_component = {
        name: @component_name,
        data: @component_data || {}
      }

    = react_component 'ConfigLayout', content_component: content_component
```



### 修改 application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def default_render
    if @component_name.present?
      @component_name = @component_name.camelize
      return render template: '/index/component'
    else
      super
    end
  end
end
```



### 修改 config/initializers/assets.rb

```ruby
### 以下是自己添加的
Rails.application.config.assets.precompile += %w( libs.js )
```



### 去除 active_record 依赖

```shell
# 生成不依赖数据库的工程
rails new test-app -O
```

复制 application.rb 代码

```ruby
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
```

覆盖 config/environments 下三个文件，覆盖 config/initializers/new_framework_defaults.rb



### 设置 action_cable

在 config/environments/development.rb 中添加

```ruby
  # Mount Action Cable outside main process or domain
  config.action_cable.allowed_request_origins = [ /http:\/\/*/ ]
```

以去除访问的 IP 限制



### 为 action_cable 增加验证

```ruby
# app/config/initializers/warden_hooks.rb
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = user.id.to_s
end
```



```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.login
    end

    protected
      def find_verified_user
        if verified_user = User.find_by(id: cookies.signed['user.id'])
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
```

参考：http://www.rubytutorial.io/actioncable-devise-authentication/



-----------------------



### 其他备注

ant-design 的 js 和 css 是自己从他的源码编译的，编译之前修改了字号

修改 `components/style/themes/default.less`中的

```les
@font-size-base         : 14px;
```

如果有其他想改的也可以在这里改

```shell
npm install
npm run dist
```



## 参考资料

### rspec 3.0 expect 写法

https://www.relishapp.com/rspec/rspec-expectations/v/3-2/docs/built-in-matchers



### action cable & active job 配置

http://wulfric.me/2016/09/active-job-action-cable-in-rails/



### 部署 action cable 特性到 heroku

http://www.thegreatcodeadventure.com/deploying-action-cable-to-heroku/