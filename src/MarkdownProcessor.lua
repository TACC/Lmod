--------------------------------------------------------------------------
-- MarkdownProcessor: Convert markdown content to terminal-friendly format
-- @module MarkdownProcessor

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
require("TermWidth")

local MarkdownProcessor = {}

--------------------------------------------------------------------------
-- Split text into lines using string.find (version-independent; see LUA_GMATCH_BEHAVIOR.md)
-- @param text The text to split
-- @return array of lines (untrimmed)
local function splitLines(text)
   local lines = {}
   local pos = 1
   local len = text:len()
   while pos <= len do
      local lineEnd = text:find("\n", pos, true)
      local line
      if lineEnd then
         line = text:sub(pos, lineEnd - 1)
         pos = lineEnd + 1
      else
         line = text:sub(pos)
         pos = len + 1
      end
      table.insert(lines, line)
   end
   return lines
end

-- ANSI color codes for terminal formatting
local ANSI = {
   RESET = "\027[0m",
   BOLD = "\027[1m", 
   DIM = "\027[2m",
   ITALIC = "\027[3m",
   UNDERLINE = "\027[4m",
   RED = "\027[31m",
   GREEN = "\027[32m",
   YELLOW = "\027[33m",
   BLUE = "\027[34m",
   MAGENTA = "\027[35m",
   CYAN = "\027[36m",
   WHITE = "\027[37m"
}

-- Check if terminal supports color
local function supportsColor()
   -- Check if we're in regression testing mode (use Lmod's standard way)
   local function isRegressionTesting()
      local status, optionTbl = pcall(require, "utils")
      if status and optionTbl and type(optionTbl) == "function" then
         local opts = optionTbl()
         return opts and opts.rt == true
      end
      return false
   end
   
   -- Disable colors during regression testing
   if isRegressionTesting() then
      return false
   end
   
   local term = os.getenv("TERM") or ""
   local colorize = os.getenv("LMOD_COLORIZE") or ""
   
   return colorize:upper() == "YES" or 
          term:match("color") or 
          term:match("xterm") or 
          term:match("screen")
end

local USE_COLOR = supportsColor()

--------------------------------------------------------------------------
-- Apply terminal formatting if color is supported
-- @param text The text to format
-- @param ansiCode The ANSI code to apply
-- @return formatted text
local function applyFormat(text, ansiCode)
   if USE_COLOR then
      return ansiCode .. text .. ANSI.RESET
   else
      return text
   end
end

--------------------------------------------------------------------------
-- Convert markdown headers to terminal format
-- @param line The line containing a header
-- @return formatted header line
local function processHeader(line)
   dbg.start{"processHeader(", line, ")"}
   
   local success, result = pcall(function()
      -- ATX headers (# ## ###)
      local level, text = line:match("^(#+)%s+(.+)$")
      if level then
         local headerText = text
         if level:len() == 1 then
            -- Use string.upper() for Lua 5.1 compatibility
            headerText = applyFormat(string.upper(headerText), ANSI.BOLD .. ANSI.CYAN)
         elseif level:len() == 2 then
            headerText = applyFormat(headerText, ANSI.BOLD)
         else
            headerText = applyFormat(headerText, ANSI.UNDERLINE)
         end
         return headerText
      end
      return line
   end)
   
   if not success then
      dbg.fini("processHeader")
      return line
   end
   
   dbg.fini("processHeader")
   return result
end

--------------------------------------------------------------------------
-- Check if next line is a setext header underline
-- @param lines Array of lines
-- @param i Current line index
-- @return true if next line is underline, underline character
local function isSetextHeader(lines, i)
   if i >= #lines then return false end
   local nextLine = lines[i + 1]
   if nextLine:match("^===+$") then
      return true, "="
   elseif nextLine:match("^---+$") then
      return true, "-"
   end
   return false
end

--------------------------------------------------------------------------
-- Process markdown emphasis (bold, italic)
-- @param text The text to process
-- @return text with emphasis converted to terminal format
local function processEmphasis(text)
   dbg.start{"processEmphasis()"}
   
   -- Bold: **text**
   text = text:gsub("(%*%*)([^*]+)(%*%*)", function(start, content, ending)
      return applyFormat(content, ANSI.BOLD)
   end)
   
   -- Bold: __text__
   text = text:gsub("(__)([^_]+)(__)", function(start, content, ending)
      return applyFormat(content, ANSI.BOLD)
   end)
   
   -- Italic: *text* (but not **text**)
   text = text:gsub("([^*])(%*)([^*%s][^*]*)(%*)([^*])", function(before, start, content, ending, after)
      return before .. applyFormat(content, ANSI.ITALIC) .. after
   end)
   
   -- Italic at start of line: *text*
   text = text:gsub("^(%*)([^*%s][^*]*)(%*)", function(start, content, ending)
      return applyFormat(content, ANSI.ITALIC)
   end)
   
   -- Italic: _text_ (but not __text__)
   text = text:gsub("([^_])(_)([^_%s][^_]*)(_)([^_])", function(before, start, content, ending, after)
      return before .. applyFormat(content, ANSI.ITALIC) .. after
   end)
   
   -- Italic at start of line: _text_
   text = text:gsub("^(_)([^_%s][^_]*)(_)", function(start, content, ending)
      return applyFormat(content, ANSI.ITALIC)
   end)
   
   dbg.fini("processEmphasis")
   return text
end

--------------------------------------------------------------------------
-- Process inline code
-- @param text The text to process
-- @return text with code converted to terminal format
local function processInlineCode(text)
   dbg.start{"processInlineCode()"}
   
   text = text:gsub("`([^`]+)`", function(code)
      return applyFormat(code, ANSI.DIM .. ANSI.CYAN)
   end)
   
   dbg.fini("processInlineCode")
   return text
end

--------------------------------------------------------------------------
-- Process markdown links
-- @param text The text to process
-- @return text with links converted to terminal format
local function processLinks(text)
   dbg.start{"processLinks()"}
   
   local success, result = pcall(function()
      return text:gsub("%[([^%]]+)%]%([^%)]*%)", function(linkText, url)
         -- Handle case where URL might be empty or incomplete (multi-line links)
         if not url or url == "" then
            url = "..."
         end
         if USE_COLOR then
            return applyFormat(linkText, ANSI.BLUE .. ANSI.UNDERLINE) .. " (" .. url .. ")"
         else
            return linkText .. " (" .. url .. ")"
         end
      end)
   end)
   
   if not success then
      dbg.fini("processLinks")
      return text
   end
   
   dbg.fini("processLinks")
   return result
end

--------------------------------------------------------------------------
-- Process markdown images
-- @param text The text to process
-- @return text with images converted to terminal format (alt text + URL)
local function processImages(text)
   dbg.start{"processImages()"}
   
   local success, result = pcall(function()
      return text:gsub("!%[([^%]]*)%]%([^%)]*%)", function(altText, url)
         -- Handle case where URL might be empty or incomplete
         if not url or url == "" then
            url = "..."
         end
         -- Use alt text if provided, otherwise use generic "Image"
         local displayText = altText
         if not displayText or displayText == "" then
            displayText = "Image"
         end
         if USE_COLOR then
            return applyFormat("[Image: " .. displayText .. "]", ANSI.CYAN) .. " (" .. url .. ")"
         else
            return "[Image: " .. displayText .. "] (" .. url .. ")"
         end
      end)
   end)
   
   if not success then
      dbg.fini("processImages")
      return text
   end
   
   dbg.fini("processImages")
   return result
end

--------------------------------------------------------------------------
-- Process a list item
-- @param line The line containing a list item
-- @return formatted list item
local function processListItem(line)
   dbg.start{"processListItem(", line, ")"}
   
   local success, result = pcall(function()
      -- Unordered lists
      local indent, marker, content = line:match("^(%s*)([-*+])%s+(.+)$")
      if indent and marker and content then
         -- Process inline formatting in the content
         -- Process images before links to avoid pattern conflicts
         content = processInlineCode(content)
         content = processEmphasis(content)
         content = processImages(content)
         content = processLinks(content)
         
         local bullet = USE_COLOR and applyFormat("•", ANSI.CYAN) or "•"
         return indent .. bullet .. " " .. content
      end
      
      -- Ordered lists  
      indent, marker, content = line:match("^(%s*)(%d+%.)%s+(.+)$")
      if indent and marker and content then
         -- Process inline formatting in the content
         -- Process images before links to avoid pattern conflicts
         content = processInlineCode(content)
         content = processEmphasis(content)
         content = processImages(content)
         content = processLinks(content)
         
         local numberedMarker = USE_COLOR and applyFormat(marker, ANSI.CYAN) or marker
         return indent .. numberedMarker .. " " .. content
      end
      
      return line
   end)
   
   if not success then
      dbg.fini("processListItem")
      return line
   end
   
   dbg.fini("processListItem")
   return result
end

--------------------------------------------------------------------------
-- Convert markdown text to terminal-friendly format
-- @param markdownText The markdown content to convert
-- @return converted text suitable for terminal display
function MarkdownProcessor.toTerminal(markdownText)
   dbg.start{"MarkdownProcessor.toTerminal()"}
   
   if not markdownText or markdownText:len() == 0 then
      dbg.fini("MarkdownProcessor.toTerminal")
      return ""
   end
   
   -- Wrap main processing in error handling
   local success, result = pcall(function()
      return MarkdownProcessor._processInternal(markdownText)
   end)
   
   if not success then
      dbg.fini("MarkdownProcessor.toTerminal")
      return markdownText -- Return original text on error
   end
   
   dbg.fini("MarkdownProcessor.toTerminal")
   return result
end

--------------------------------------------------------------------------
-- Internal processing function (separated for error handling)
-- @param markdownText The markdown content to convert
-- @return converted text suitable for terminal display
function MarkdownProcessor._processInternal(markdownText)
   local lines = splitLines(markdownText)
   
   local result = {}
   local inCodeBlock = false
   local i = 1
   
   while i <= #lines do
      local line = lines[i]
      
      -- Handle code blocks
      if line:match("^```") then
         inCodeBlock = not inCodeBlock
         if inCodeBlock then
            table.insert(result, applyFormat("Code:", ANSI.DIM))
         else
            table.insert(result, "")
         end
         i = i + 1
      elseif inCodeBlock then
         -- Inside code block - output as-is with formatting
         -- Skip empty lines to avoid empty ANSI formatting
         if line ~= "" then
         table.insert(result, "  " .. applyFormat(line, ANSI.DIM .. ANSI.CYAN))
         else
            table.insert(result, "")
         end
         i = i + 1
      else
         -- Handle setext headers (check before processing line)
      local isHeader, headerType = isSetextHeader(lines, i)
      if isHeader then
         local headerText = lines[i]
         if headerType == "=" then
               -- Use string.upper() for Lua 5.1 compatibility
               headerText = applyFormat(string.upper(headerText), ANSI.BOLD .. ANSI.CYAN)
         else
            headerText = applyFormat(headerText, ANSI.BOLD)
         end
         table.insert(result, headerText)
         i = i + 2 -- Skip the underline
         elseif line:match("^===+$") or line:match("^---+$") then
      -- Skip setext underlines (handled above)
         i = i + 1
         else
            -- Process the line normally
      local processedLine = line
      
      -- Headers (ATX style)
      if line:match("^#+%s") then
         processedLine = processHeader(line)
      -- List items
      elseif line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") then
         processedLine = processListItem(line)
      -- Regular text
      else
         -- Apply inline formatting
               -- Process images before links to avoid pattern conflicts
         processedLine = processInlineCode(processedLine)
         processedLine = processEmphasis(processedLine)
               processedLine = processImages(processedLine)
         processedLine = processLinks(processedLine)
      end
      
      table.insert(result, processedLine)
      i = i + 1
         end
      end
   end
   
   local output = table.concat(result, "\n")
   return output
end

--------------------------------------------------------------------------
-- Convert markdown to plain text (strip all formatting)
-- @param markdownText The markdown content to convert
-- @return plain text with markdown formatting removed
function MarkdownProcessor.toPlainText(markdownText)
   dbg.start{"MarkdownProcessor.toPlainText()"}
   
   if not markdownText or markdownText:len() == 0 then
      dbg.fini("MarkdownProcessor.toPlainText")
      return ""
   end
   
   local text = markdownText
   
   -- Remove headers
   text = text:gsub("\n#+%s+", "\n")
   text = text:gsub("^#+%s+", "")
   
   -- Remove setext headers
   text = text:gsub("\n===+\n", "\n")
   text = text:gsub("\n---+\n", "\n")
   
   -- Remove emphasis
   text = text:gsub("%*%*([^*]+)%*%*", "%1")
   text = text:gsub("__([^_]+)__", "%1")
   text = text:gsub("%*([^*]+)%*", "%1") 
   text = text:gsub("_([^_]+)_", "%1")
   
   -- Remove inline code
   text = text:gsub("`([^`]+)`", "%1")
   
   -- Remove code blocks
   text = text:gsub("```[^`]*```", "")
   
   -- Convert links
   text = text:gsub("%[([^%]]+)%]%([^%)]+%)", "%1")
   
   -- Convert images to alt text
   text = text:gsub("!%[([^%]]*)%]%([^%)]+%)", function(altText, url)
      return altText ~= "" and altText or "Image"
   end)
   
   -- Clean up list markers
   text = text:gsub("\n%s*[-*+]%s+", "\n• ")
   text = text:gsub("^%s*[-*+]%s+", "• ")
   text = text:gsub("\n%s*%d+%.%s+", "\n")
   text = text:gsub("^%s*%d+%.%s+", "")
   
   dbg.fini("MarkdownProcessor.toPlainText")
   return text
end

return MarkdownProcessor
