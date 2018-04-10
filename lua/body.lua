-- ngx.log(ngx.ERR, "ngx.arg[1]===========", ngx.arg[1])
-- ngx.log(ngx.ERR, "ngx.arg[2]===========", ngx.arg[2])
-- if ngx.arg[1] and not ngx.is_subrequest then
--   ngx.log(ngx.ERR, "last ===========", ngx.arg[1])
-- end

local resp_body = string.sub(ngx.arg[1], 1, 1000)
ngx.log(ngx.ERR, "start ===========", ngx.ctx.buffered)

ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
if ngx.arg[2] then
  ngx.var.resp_body = ngx.ctx.buffered
  -- 获取到完整的响应内容
  ngx.log(ngx.ERR, "last ===========", ngx.ctx.buffered)
end
