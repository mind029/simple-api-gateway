local Utils = {}

function Utils:table_is_empty(t)
    return next(t) == nil
end

return Utils
