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



-----------------------



## 参考资料

### rspec 3.0 expect 写法

https://www.relishapp.com/rspec/rspec-expectations/v/3-2/docs/built-in-matchers