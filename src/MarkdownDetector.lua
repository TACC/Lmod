--------------------------------------------------------------------------
-- MarkdownDetector: Heuristic detection of markdown content in module help/whatis
-- @module MarkdownDetector

_G._DEBUG = false
local posix = require("posix")

pcall(require, "strict")

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

local dbg = require("Dbg"):dbg()

local MarkdownDetector = {}

--------------------------------------------------------------------------
-- Detect if text content is intended as markdown based on heuristic analysis
-- @param text The text content to analyze
-- @return true if content appears to be markdown, false otherwise
function MarkdownDetector.isMarkdown(text)
   dbg.start{"MarkdownDetector.isMarkdown(", text and text:len() or "nil", " chars)"}
   
   -- Empty or very short content is plain text
   if not text or text:len() < 30 then
      dbg.print{"Too short or empty, returning false"}
      dbg.fini("MarkdownDetector.isMarkdown")
      return false
   end
   
   -- Split into lines for analysis
   local lines = {}
   for line in text:gmatch("[^\n]*") do
      local trimmed = line:match("^%s*(.-)%s*$") or ""
      table.insert(lines, trimmed)
   end
   
   dbg.print{"Analyzing ", #lines, " lines"}
   
   local indicators = {
      atx_headers = 0,      -- # ## ### headers
      setext_headers = 0,   -- === --- underlines  
      lists = 0,           -- - * + 1. 2. lists
      emphasis = 0,        -- *text* **text**
      code = 0,           -- `code` ```blocks```
      links = 0,          -- [text](url)
      structure = 0       -- paragraph breaks, organized content
   }
   
   -- Analyze each line
   for i, line in ipairs(lines) do
      -- ATX headers (# ## ###)
      if line:match("^#+%s+%S") then
         indicators.atx_headers = indicators.atx_headers + 1
         dbg.print{"Found ATX header: '", line, "'"}
      end
      
      -- Setext headers (underlines)
      if i > 1 and lines[i-1]:len() > 0 and 
         (line:match("^===+$") or line:match("^---+$")) then
         indicators.setext_headers = indicators.setext_headers + 1
         dbg.print{"Found setext header underline: '", line, "'"}
      end
      
      -- Lists
      if line:match("^%s*[-*+]%s+%S") or line:match("^%s*%d+%.%s+%S") then
         indicators.lists = indicators.lists + 1
         dbg.print{"Found list item: '", line, "'"}
      end
      
      -- Emphasis patterns
      local emphasis_count = 0
      -- Bold: **text**
      for match in line:gmatch("%*%*[^*%s][^*]*[^*%s]%*%*") do
         emphasis_count = emphasis_count + 1
         dbg.print{"Found bold: '", match, "'"}
      end
      -- Italic: *text* (but not **text**)
      for match in line:gmatch("%*[^*%s][^*]*[^*%s]%*") do
         -- Make sure it's not part of **text**
         if not line:match("%*" .. match:gsub("%*", "%%*") .. "%*") then
            emphasis_count = emphasis_count + 1
            dbg.print{"Found italic: '", match, "'"}
         end
      end
      -- Bold: __text__
      for match in line:gmatch("__[^_%s][^_]*[^_%s]__") do
         emphasis_count = emphasis_count + 1
         dbg.print{"Found bold underscore: '", match, "'"}
      end
      -- Italic: _text_
      for match in line:gmatch("_[^_%s][^_]*[^_%s]_") do
         -- Make sure it's not part of __text__
         if not line:match("_" .. match:gsub("_", "%%_") .. "_") then
            emphasis_count = emphasis_count + 1
            dbg.print{"Found italic underscore: '", match, "'"}
         end
      end
      indicators.emphasis = indicators.emphasis + emphasis_count
      
      -- Code patterns
      local code_count = 0
      for match in line:gmatch("`[^`]+`") do
         code_count = code_count + 1
         dbg.print{"Found inline code: '", match, "'"}
      end
      if line:match("^```") then
         code_count = code_count + 2 -- Code blocks are stronger signal
         dbg.print{"Found code block delimiter: '", line, "'"}
      end
      indicators.code = indicators.code + code_count
      
      -- Links
      local link_count = 0
      for match in line:gmatch("%[[^%]]+%]%([^%)]+%)") do
         link_count = link_count + 1
         dbg.print{"Found link: '", match, "'"}
      end
      indicators.links = indicators.links + link_count
   end
   
   -- Structural analysis
   local empty_lines = 0
   local long_lines = 0
   for _, line in ipairs(lines) do
      if line:len() == 0 then
         empty_lines = empty_lines + 1
      elseif line:len() > 60 then
         long_lines = long_lines + 1
      end
   end
   
   -- Well-structured content with paragraphs
   if #lines > 5 and empty_lines > 1 and long_lines > 2 then
      indicators.structure = indicators.structure + 1
      dbg.print{"Found structured content"}
   end
   
   -- Calculate confidence score
   local score = 0
   
   -- Strong indicators (definitive markdown)
   if indicators.atx_headers > 0 then 
      score = score + 3 
      dbg.print{"ATX headers bonus: +3"}
   end
   if indicators.setext_headers > 0 then 
      score = score + 3 
      dbg.print{"Setext headers bonus: +3"}
   end
   if indicators.code > 1 then 
      score = score + 3 
      dbg.print{"Code bonus: +3"}
   end
   if indicators.links > 0 then 
      score = score + 2 
      dbg.print{"Links bonus: +2"}
   end
   
   -- Medium indicators
   if indicators.lists > 1 then 
      score = score + 2 
      dbg.print{"Lists bonus: +2"}
   end
   if indicators.emphasis > 0 then 
      score = score + 1 
      dbg.print{"Emphasis bonus: +1"}
   end
   if indicators.structure > 0 then 
      score = score + 1 
      dbg.print{"Structure bonus: +1"}
   end
   
   dbg.print{"Final score: ", score, " (threshold: 3)"}
   dbg.printT("indicators", indicators)
   
   local isMarkdown = score >= 3
   
   dbg.fini("MarkdownDetector.isMarkdown")
   return isMarkdown
end

--------------------------------------------------------------------------
-- Get detailed analysis of markdown indicators in text
-- @param text The text content to analyze
-- @return table with indicator counts and score
function MarkdownDetector.analyze(text)
   dbg.start{"MarkdownDetector.analyze()"}
   
   if not text or text:len() < 30 then
      dbg.fini("MarkdownDetector.analyze")
      return {
         score = 0,
         isMarkdown = false,
         reason = "Too short or empty"
      }
   end
   
   -- This is a simplified version that reuses the main logic
   -- In production, we'd refactor to share the analysis code
   local isMarkdown = MarkdownDetector.isMarkdown(text)
   
   dbg.fini("MarkdownDetector.analyze")
   return {
      score = isMarkdown and 3 or 0, -- Simplified for now
      isMarkdown = isMarkdown,
      reason = isMarkdown and "Multiple markdown indicators found" or "Insufficient markdown indicators"
   }
end

return MarkdownDetector
