FilePartUpload.config do
  mode :qiniu

  # 配置 qiniu 使用的 bucket 名称
  qiniu_bucket         "alanvideo"

  # 配置 qiniu 使用的 bucket 的 domain
  qiniu_domain         "http://7xsd7r.com1.z0.glb.clouddn.com"

  # 配置要使用 bucket 的 子路径
  # 比如 base_path 如果是 "f",那么文件会上传到 bucket 下的 f 子路径下
  qiniu_base_path      "kc"

  # 配置 qiniu 账号的 app access key
  qiniu_app_access_key "K01Ll1zphthbSZdPDKueD5wfomaiIdyTVm8i-zNI"

  # 配置 qiniu 账号的 app secret key
  qiniu_app_secret_key "ObexIKr4wE0_WIaavaOJJTfXjSbSimBx0_d6qclu"

  # 配置 qiniu callback host
  # 文件上传完毕后，如果需要转码，提交转码请求给七牛后，当转码完毕后，七牛会发送请求给 App-Server
  # 所以这里需要配置 App-Server Host,并且可以被公网访问
  qiniu_callback_host  "http://yy.yy.yy"

  qiniu_audio_and_video_transcode :enable

  qiniu_pfop_pipeline "transfer"

end