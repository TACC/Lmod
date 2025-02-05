timestampFn = {
  false,
}
mrcT = {
  alias2modT = {},
  hiddenT = {},
  version2modT = {},
}

mrcMpathT = {}
spiderT = {
  ["%testDir%/mfF/Compiler/xcc/1.0"] = {
    Foo = {
      defaultA = {
        {
          barefn = ".modulerc.lua",
          defaultIdx = 2,
          fn = "%testDir%/mfF/Compiler/xcc/1.0/Foo/.modulerc.lua",
          fullName = "Foo/.modulerc",
          luaExt = 10,
          mpath = "%testDir%/mfF/Compiler/xcc/1.0",
          value = false,
        },
      },
      defaultT = {
        barefn = ".modulerc.lua",
        defaultIdx = 2,
        fn = "%testDir%/mfF/Compiler/xcc/1.0/Foo/.modulerc.lua",
        fullName = "Foo/.modulerc",
        luaExt = 10,
        mpath = "%testDir%/mfF/Compiler/xcc/1.0",
        value = false,
      },
      dirT = {},
      fileT = {
        ["Foo/invisible"] = {
          Version = "invisible",
          canonical = "invisible",
          fn = "%testDir%/mfF/Compiler/xcc/1.0/Foo/invisible.lua",
          luaExt = 10,
          mpath = "%testDir%/mfF/Compiler/xcc/1.0",
          pV = "*invisible.*zfinal",
          wV = "*invisible.*zfinal",
        },
        ["Foo/visible"] = {
          Version = "visible",
          canonical = "visible",
          fn = "%testDir%/mfF/Compiler/xcc/1.0/Foo/visible.lua",
          luaExt = 8,
          mpath = "%testDir%/mfF/Compiler/xcc/1.0",
          pV = "*visible.*zfinal",
          wV = "*visible.*zfinal",
        },
      },
    },
  },
  ["%testDir%/mfF/Core"] = {
    xcc = {
      defaultA = {},
      defaultT = {},
      dirT = {},
      fileT = {
        ["xcc/1.0"] = {
          Version = "1.0",
          canonical = "1.0",
          changeMPATH = true,
          fn = "%testDir%/mfF/Core/xcc/1.0.lua",
          luaExt = 4,
          mpath = "%testDir%/mfF/Core",
          pV = "000000001.*zfinal",
          wV = "000000001.*zfinal",
        },
      },
    },
  },
  version = 5,
}
mpathMapT = {
  ["%testDir%/mfF/Compiler/xcc/1.0"] = {
    ["xcc/1.0"] = "%testDir%/mfF/Core",
  },
}

