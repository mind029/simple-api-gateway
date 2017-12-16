-- 验证模块
-- @since 2017-12-15 10:54
-- @author mind <294433706@qq.com>
-- version 1.0.1
-- 工具模块
local Utils = require("libs.utils")
local cjson = require("cjson")
local TableInsert = table.insert

local Validate = {}

-- 验证黑名单ip
-- @param ip 访客ip
-- @param blacklist 黑名单ip数组
function Validate:checkIp(ip, blacklist)
    local isBan = false
    for k, v in pairs(blacklist) do
        -- 当用户ip在数组中的时候，跳出循环
        if v.ip == ip then
            isBan = true
            break
        end
    end
    return isBan, ip
end

-- @param params 请求参数数组
-- @param
function Validate:check(params, validateResult)
    -- 错误提示信息
    local message

    local isEmpty = Utils:table_is_empty(validateResult)
    -- 判断是否有验证参数
    if isEmpty then
        -- 说明没有验证参数，返回提示
        message = "验证项为空，跳过所有验证"
        return true, message
    end

    -- 验证参数数组
    local validateKeys = {}

    -- 从返回验证项遍历得到所有 能过滤出 缺少的字段和不符合条件的字段
    for k, validateItem in pairs(validateResult) do
        -- 验证字段名称
        local Field_Name = validateItem.Field_Name
        -- 往验证参数数组里面插入验证字段名称
        TableInsert(validateKeys, Field_Name)
        -- 取得输入参数的值
        local paramItemValue = params[Field_Name]

        -- 是否需要校验
        local isNeedCheck = true
        -- 判断输入当前字段的值是否为空
        if paramItemValue == nil then
            -- 说明是可选参数，跳过本次循环
            -- 为空，判断是否是可选
            if validateItem.Option == 0 then
                -- 不可选，当为空还是不可选的时候返回错误提示
                message = "缺少参数，" .. Field_Name
                return false, message
            end

            -- 说明是可选参数，则跳过后面的验证,设置阈值字段
            isNeedCheck = false
        end

        -- 判断是否为可选参数，如果是可选参数当为空的时候，就跳过数据校验
        -- 判断参数是否需要校验
        if isNeedCheck and validateItem.Check == 1 then
            -- 取得验证正则字符串
            local regularStr = validateItem.Regexp
            -- 验证参数是否合理
            local matchResult, err = ngx.re.match(paramItemValue, regularStr)

            if matchResult == nil then
                -- 不合理
                if err then
                    ngx.log(ngx.ERR, "error: ", err)
                    return
                end
                -- 返回错误信息
                message = validateItem.Tips
                return false, message
            end
        end
    end

    -- 判断是否多出参数
    for k, v in pairs(params) do
        -- 排除掉类型数组对象，只比对参数
        if k ~= "VA_GET" and k ~= "VA_POST" and k ~= "VA_FILE" then
            local isInclude = false
            -- 遍历查找是参数是否有多出的，如果多出则为false
            for k1, v1 in pairs(validateKeys) do
                if k == v1 then
                    isInclude = true
                end
            end

            -- 判断结果
            if isInclude == false then
                -- 说明是参数有多余的
                message = "参数" .. k .. "是多出的参数，请去掉!"
                return false, message
            end
        end
    end

    return true, "全部正确"
end

return Validate
