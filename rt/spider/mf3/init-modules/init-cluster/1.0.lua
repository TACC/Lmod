-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

local TEST_root = myFileName():match( '(.*)/mf3/init%-modules/init%-cluster/.*' )
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ': Detected root of the module system is ' .. ( TEST_root or '') )
end

--
-- Add the software stack modules
--
prepend_path( 'MODULEPATH', pathJoin( TEST_root, 'mf3/Stacks' ) )

--
-- Bump init-modules to the front of the MODULEPATH.
-- DANGER: This breaks module spider.
--
if os.getenv( 'TRIGGER_BUG' ) ~=  nil then
    prepend_path( 'MODULEPATH', pathJoin( TEST_root, 'mf3/init-modules' ) )
end

-- Debug message
if os.getenv( '_TEST_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
