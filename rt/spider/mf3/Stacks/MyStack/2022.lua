-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

local TEST_root = myFileName():match( '(.*)/mf3/Stacks/.*' )
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ': Detected root of the module system is ' .. ( TEST_root or '') )
end

--
-- Update the MODULEPATH with the applications for this software stack
--
prepend_path( 'MODULEPATH', pathJoin( TEST_root, 'mf3/Software', myModuleFullName () ) )

-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
