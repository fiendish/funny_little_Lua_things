-- Author: Avi Kelman 2015

-- MUSHclient's PCRE object exposes only re:exec, re:match, and re:gmatch
-- But there's no exposed gsub equivalent (despite lrexlib having this).
-- So this is like string.gsub but with PCRE, using re:exec and string
-- functions.
require "rex"
rex.gsub = function(str, re, rep)
   if type(re) == "string" then
      re = rex.new(re)
   end
   output = ""
      
   local startfrom = 1
   local s, e, t = re:exec(str, startfrom)
   while s ~= nil do
      local filled_rep = rep:gsub("%%(%d+)", 
         function(index) 
            local i = tonumber(index)*2
            return str:sub(t[i-1], t[i]) or ""
         end)
      output = output..str:sub(startfrom, s-1)..filled_rep
      
      startfrom = e+1
      s, e, t = re:exec(str, startfrom)
   end

   return output..str:sub(startfrom)
end

