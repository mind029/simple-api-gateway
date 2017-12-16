local cjson = require("cjson")
-- 加载请求参数处理库
local Request = require("libs.request"):new()
-- 工具模块
local Utils = require("libs.utils")
-- 验证模块
local Validate = require("libs.validate")

-- 获取请求的host
local host = ngx.var.host
-- 客户端ip地址
local remote_addr = ngx.var.remote_addr
-- 用户所有请求参数
local params = Request:getParams()
-- 获取用户请求方式、GET/POST/PUT/DELETE 等
local method = Request:getMethod()

local validateResult = {
    {
        Id = "5e3307b0-70df-11e7-9f7f-252b0a40fd6e",
        Field_Name = "Page",
        Regexp = "^[0-9]{1,4}$",
        Check = 1,
        Option = 0,
        Tips = "页数参数错误，数字1-6位",
        Desc = "页数"
    },
    {
        Id = "5e332ec0-70df-11e7-9f7f-252b0a40fd6e",
        Field_Name = "Rows",
        Regexp = "^[0-9]{1,4}$",
        Check = 1,
        Option = 0,
        Tips = "条数参数错误，数字1-6位",
        Desc = "条数"
    }
}

-- 得到验证结果
local status, message = Validate:check(params, validateResult)

-- 设置校验返回信息
ngx.var.validateContent = cjson.encode({status = status,message = message})

-- 判断是否需要跳转到错误拦截显示页面
if status ~= true then
    return ngx.exec("@content")
end
