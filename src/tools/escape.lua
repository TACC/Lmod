isLua51 = _VERSION:match('5%.1$')

function escape(s)
    local res = s:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1')
    if isLua51 then
        res = res:gsub('%z','%%z')
    end
    return res
end
