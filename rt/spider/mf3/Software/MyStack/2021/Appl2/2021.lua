-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

if mode() == 'load' then
    LmodMessage( myModuleFullName() .. ': I\'m just some fill-up of the module tree and don\'t do anything useful.' )
end

-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
