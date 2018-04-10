# simple-api-gateway
使用openresty的api网关程序

## 命令

启动

```
sudo openresty -p /Users/mind/development/code/Openresty/Github/simple-api-gateway -c conf/nginx.conf

```

## 网关开发思路

1. 在 `access_by_lua_file` 阶段对请求参数、api接口等进行验证
2. 在 `body_filter_by_lua_file` 阶段对api接口响应的 json 数据进行 JSON SCHEMA ，判断是否符合对应规则，如果不符合。


## 开发日志
### 2017-12-16 更改日志

1. 验证请求参数基本模块开发完成
2. 加入自定义显示错误内部location模块
3. 黑名单验证模块

下一步开发，加入上传文件验证信息。