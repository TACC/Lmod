LmodMessage("5.0rc2: ",versionTest("5.0rc2"),"\n")
LmodMessage("5.0:    ",versionTest("5.0"),"\n")
LmodMessage("5.1:    ",versionTest("5.1"),"\n")
LmodMessage("5.1.0:  ",versionTest("5.1.0"),"\n")
LmodMessage("5.1.1:  ",versionTest("5.1.1"),"\n")
if (versionTest(LmodVersion()) > versionTest("5.0")) then
   LmodMessage("(1) Passed Module Test\n")
end

if (versionTest(LmodVersion()) < versionTest("100000000000.0")) then
   LmodMessage("(2) Passed Module Test\n")
end

if (versionTest(LmodVersion()) > versionTest("100000000000.0")) then
   LmodMessage("(3) Failed Module Test\n")
end
