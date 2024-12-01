timestampFn = {
  false,
}
mrcT = {
  alias2modT = {},
  hiddenT = {
    ["cluster/A"] = true,
    ["cluster/B"] = true,
    ["cluster/C"] = true,
  },
  version2modT = {},
}

mrcMpathT = {
  ["%testDir%/mfG/Core"] = {
    hiddenT = {
      ["cluster/A"] = true,
      ["cluster/B"] = true,
      ["cluster/C"] = true,
    },
  },
}
spiderT = {
  ["%testDir%/mfG/Core"] = {
    cluster = {
      defaultA = {
        {
          barefn = ".modulerc.lua",
          defaultIdx = 2,
          fn = "%testDir%/mfG/Core/cluster/.modulerc.lua",
          fullName = "cluster/.modulerc",
          luaExt = 10,
          mpath = "%testDir%/mfG/Core",
          value = false,
        },
      },
      defaultT = {
        barefn = ".modulerc.lua",
        defaultIdx = 2,
        fn = "%testDir%/mfG/Core/cluster/.modulerc.lua",
        fullName = "cluster/.modulerc",
        luaExt = 10,
        mpath = "%testDir%/mfG/Core",
        value = false,
      },
      dirT = {},
      fileT = {
        ["cluster/A"] = {
          Version = "A",
          canonical = "A",
          fn = "%testDir%/mfG/Core/cluster/A.lua",
          luaExt = 2,
          mpath = "%testDir%/mfG/Core",
          pV = "*a.*zfinal",
          wV = "*a.*zfinal",
        },
        ["cluster/B"] = {
          Version = "B",
          canonical = "B",
          fn = "%testDir%/mfG/Core/cluster/B.lua",
          luaExt = 2,
          mpath = "%testDir%/mfG/Core",
          pV = "*b.*zfinal",
          wV = "*b.*zfinal",
        },
        ["cluster/C"] = {
          Version = "C",
          canonical = "C",
          fn = "%testDir%/mfG/Core/cluster/C.lua",
          luaExt = 2,
          mpath = "%testDir%/mfG/Core",
          pV = "*c.*zfinal",
          wV = "*c.*zfinal",
        },
      },
    },
  },
  version = 5,
}
mpathMapT = {}

