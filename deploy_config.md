## 部署环境增加 sidekiq

### 修改 Gemfile  
```ruby
group :production do
  gem 'redis-namespace', '~> 1.5'
  gem 'sidekiq', '~> 4.2'
 end
```

### 修改 config/environments/production.rb
```ruby
config.active_job.queue_adapter     = :sidekiq
```

### 修改 config/initializers/sidekiq.rb
```ruby
if Rails.env == "production"
  sidekiq_url = "redis://localhost:6379/1"

  Sidekiq.configure_server do |config|
    config.redis = { namespace: 'sidekiq__im_core', url: sidekiq_url }
  end
  Sidekiq.configure_client do |config|
    config.redis = { namespace: 'sidekiq__im_core', url: sidekiq_url }
  end
end
```

### 修改 config/routes.rb
```ruby
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```

## 用 mina sidekiq 管理 sidekiq 进程

### 修改 Gemfile  
```ruby
group :development do
  gem "mina", "0.3.7"
  gem 'mina_util',
    github: "mindpin/mina_util",
    ref: "25f36fd"
  gem 'mina-sidekiq', '~> 0.4.1'
end
```

### 修改 config/deploy.rb
```ruby
require 'mina_sidekiq/tasks'

set :sidekiq_pid, lambda { "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid" }

set :shared_paths, [
  'tmp',
  'log',
]

task :deploy => :environment do
  deploy do
    invoke :'sidekiq:quiet' # -> 更新代码前，先暂停 sidekiq 处理
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    to :launch do
      invoke :'sidekiq:restart' # -> 更新代码后，重启 sidekiq
    end
  end

end
```


## nginx 支持 ws 需要特殊的配置

nginx 配置示例
```bash
upstream im-core_server {
  server unix:/web/im-core/current/tmp/sockets/unicorn.sock fail_timeout=0;
}

server {
listen       80;
server_name  im-core.teamkn.com;
root /web/im-core/current/public;
access_log  /var/log/nginx/im-core.access.log  main;

location / {
  try_files $uri @app;
}

# 增加如下几行配置用来支持 ws
location /cable {
  proxy_pass http://im-core_server;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "Upgrade";
}

location @app {
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header Host $http_host;
  proxy_redirect off;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;

  proxy_pass http://im-core_server;
}


}

```