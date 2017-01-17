--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2017 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

return {
   zh = {
     errTitle  = "Lmod has detected the following error: ",
     warnTitle = "Lmod Warning: ",
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_No_Hashsum = "找不到程序HashSum (sha1sum, shasun, md5sum or md5)",
     e_Unable_2_parse = "不能解析 \"%{path}\". 已退出！\n",      
     e_LocationT_Srch = "LocationT:search() 出现错误", 
     e_No_Mod_Entry = "%{routine}: 找不到模块条目 \"%{name}\". 这不应该发生! \n", 
     e_No_PropT_Entry = "%{routine}: 系统属性列表中不存在\"%{name}\"的%{location}. 请检查名字拼写以及大小写.\n",
     m401 = "\nLmod 已经自动将 \"%{oldFullName}\" 替换为 \"%{newFullName}\"\n",   
     w502 = "模块版本行格式不正确：模块名称必须完全限定：％{fullName} 不符合.\n",
     w503 = "系统MODULEPATH 已被修改：请重建您保存的模块集",
     w504 = "由于\"%{collectionName}\" 为空, 未载入任何模块!\n",
     w505 = "下列模块没有被载入: %{module_list}\n\n",
     w506 = "找不到\"%{collection}\" .",
   }
}

