function declare(name, initval)
   rawset(_G, name, initval or false)
end

function isDefined(name)
   return (rawget(_G, name) ~= nil)
end
