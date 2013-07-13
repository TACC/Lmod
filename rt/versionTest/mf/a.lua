LmodMessage("5.0rc2: ",versionTest("5.0rc2"),"\n")
if (versionTest(LmodVersion()) > versionTest("5.0")) then
   LmodMessage("(1) Passed Module Test\n")
end

if (versionTest(LmodVersion()) < versionTest("100000000000.0")) then
   LmodMessage("(2) Passed Module Test\n")
end

if (versionTest(LmodVersion()) > versionTest("100000000000.0")) then
   LmodMessage("(3) Failed Module Test\n")
end
