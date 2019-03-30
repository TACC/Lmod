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
--  Copyright (C) 2008-2018 Robert McLay
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
   %{LANG} = {

     --------------------------------------------------------------------------
     -- Error/Warning Titles
     --------------------------------------------------------------------------
     errTitle  = nil,
     warnTitle = nil,

     --------------------------------------------------------------------------
     -- ml messages
     --------------------------------------------------------------------------

     ml_help               = nil,
     ml_opt                = nil,
     ml_2many              = nil,
     ml_misplaced_opt      = nil,
     
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_Args_Not_Strings    = nil,
     e_Avail_No_MPATH      = nil,
     e_BrokenCacheFn       = nil,
     e_BrokenQ             = nil,
     e_Conflict            = nil,
     e_Execute_Msg         = nil,
     e_Failed_2_Find       = nil,
     e_Failed_2_Inherit    = nil,
     e_Failed_Hashsum      = nil,
     e_Failed_Load         = nil,
     e_Failed_Load_2       = nil,
     e_Family_Conflict     = nil,
     e_Illegal_Load        = nil,
     e_LocationT_Srch      = nil,
     e_Missing_Value       = nil,
     e_MT_corrupt          = nil,
     e_No_AutoSwap         = nil,
     e_No_Hashsum          = nil,
     e_No_Matching_Mods    = nil,
     e_No_Mod_Entry        = nil,
     e_No_Period_Allowed   = nil,
     e_No_PropT_Entry      = nil,
     e_No_UUID             = nil,
     e_No_ValidT_Entry     = nil,
     e_Prereq              = nil,
     e_Prereq_Any          = nil,
     e_Spdr_Timeout        = nil,
     e_Swap_Failed         = nil,
     e_Unable_2_Load       = nil,
     e_Unable_2_parse      = nil,
     e_Unknown_Coll        = nil,
     e_coll_corrupt        = nil,
     e_dbT_sn_fail         = nil,
     e_missing_table       = nil,
     e_setStandardPaths    = nil,

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m_Activate_Modules    = nil,
     m_Additional_Variants = nil,
     m_Collection_disable  = nil,
     m_Depend_Mods         = nil,
     m_Description         = nil,
     m_Direct_Load         = nil,
     m_Family_Swap         = nil,
     m_For_System          = nil,
     m_Inactive_Modules    = nil,
     m_Module_Msgs         = nil,
     m_No_Named_Coll       = nil,
     m_No_Search_Cmd       = nil,
     m_Other_matches       = nil,
     m_Other_possible      = nil,
     m_Properties          = nil,
     m_Regex_Spider        = nil,
     m_Reload_Modules      = nil,
     m_Reload_Version_Chng = nil,
     m_Restore_Coll        = nil,
     m_Reset_SysDflt       = nil,
     m_Save_Coll           = nil,
     m_Spdr_L1             = nil,
     m_Spider_Title        = nil,
     m_Spider_Tail         = nil,
     m_Sticky_Mods         = nil,
     m_Sticky_Unstuck      = nil,
     m_Versions            = nil,
     m_Where               = nil,

     
     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w_Broken_Coll         = nil,
     w_Broken_FullName     = nil,
     w_Empty_Coll          = nil,
     w_Failed_2_Find       = nil,
     w_MissingModules      = nil,
     w_MPATH_Coll          = nil,
     w_Mods_Not_Loaded     = nil,
     w_No_Coll             = nil,
     w_No_dot_Coll         = nil,
     w_Save_Empty_Coll     = nil,
     w_SYS_DFLT_EMPTY      = nil,
     w_System_Reserved     = nil,
     w_Undef_MPATH         = nil,
     w_Unknown_Hook        = nil,


     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline         = nil,
     help_title            = nil,
     help1                 = nil,
     help2                 = nil,

     load_title            = nil,
     load1                 = nil,
     load2                 = nil,
     load3                 = nil,
     load4                 = nil,
     load5                 = nil,
     load6                 = nil,
     load7                 = nil,

     list_title            = nil,
     list1                 = nil,
     list2                 = nil,
     list3                 = nil,
     list4                 = nil,
     list5                 = nil,
     list6                 = nil,
     list7                 = nil,
     list8                 = nil,
     list9                 = nil,
     list10                = nil,

     srch_title            = nil,
     srch0                 = nil,
     srch1                 = nil,
     srch2                 = nil,
     srch3                 = nil,

     collctn_title         = nil,
     collctn1              = nil,
     collctn2              = nil,
     collctn3              = nil,
     collctn4              = nil,
     collctn5              = nil,
     collctn6              = nil,
     collctn7              = nil,
     collctn8              = nil,
     collctn9              = nil,

     depr_title            = nil,
     depr1                 = nil,
     depr2                 = nil,
     depr3                 = nil,
     depr4                 = nil,

     misc_title            = nil,
     misc1                 = nil,
     misc2                 = nil,
     misc3                 = nil,
     misc4                 = nil,


     env_title             = nil,
     env1                  = nil,
     web_sites             = nil,
     rpt_bug               = nil,

     --------------------------------------------------------------------------
     -- module help strings
     --------------------------------------------------------------------------


     StickyM   = nil,
     LoadedM   = nil,
     ExplM     = nil,
     TstM      = nil,
     ObsM      = nil,

     help_hlp  = nil,
     style_hlp = nil,
     rt_hlp    = nil,
     dbg_hlp   = nil,
     pin_hlp   = nil,
     avail_hlp = nil,
     quiet_hlp = nil,
     exprt_hlp = nil,
     terse_hlp = nil,
     initL_hlp = nil,
     latest_H  = nil,
     cache_hlp = nil,
     novice_H  = nil,
     raw_hlp   = nil,
     width_hlp = nil,
     v_hlp     = nil,
     rexp_hlp  = nil,
     gitV_hlp  = nil,
     dumpV_hlp = nil,
     chkSyn_H  = nil,
     config_H  = nil,
     jcnfig_H  = nil,
     MT_hlp    = nil,
     timer_hlp = nil,
     force_hlp = nil,
     redirect_H= nil,
     nrdirect_H= nil,
     hidden_H  = nil,
     spdrT_H   = nil,
     Where     = nil,
     Inactive  = nil,
     DefaultM  = nil,
     HiddenM   = nil,

     avail     = nil,
     list      = nil,
     spider    = nil,
     aliasMsg  = nil,
     noModules = nil,
     noneFound = nil,

     --------------------------------------------------------------------------
     -- Other strings:
     --------------------------------------------------------------------------
     coll_contains  = nil,
     currLoadedMods = nil,
     keyword_msg    = nil,
     lmodSystemName = nil,
     matching       = nil,
     namedCollList  = nil,
     noModsLoaded   = nil,
     specific_hlp   = nil,

   }
}
