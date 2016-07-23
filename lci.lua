-- CC-LCI (Computercraft LOLCODE Interpreter)
-- Interprets a given LOLCODE source file
-- Copyright (C) 2016  Bryan Becar AKA Incinirate
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local version = 0.01

local workingDir = fs.getDir(shell.getRunningProgram()) or "/"

function resolveFile(file)
	return ((file:sub(1, 1) == "/" or file:sub(1, 1) == "\\") and file) or fs.combine(workingDir, file)
end

local requireCache = {}

function require(file)
    local path = resolveFile(file)

    if requireCache[path] then
        return requireCache[path]
    else
        local env = {
            shell = shell,
            require = require,
            resolveFile = resolveFile
        }

        setmetatable(env, { __index = _G })

        local chunk, err = loadfile(path, env)

        if chunk == nil then
            return error("Error loading file " .. path .. ":\n" .. (err or "N/A"), 0)
        end

        requireCache[path] = chunk()
        return requireCache[path]
    end
end

--Speshul functions that should be native ;p

--Switch implementation taken from http://lua-users.org/wiki/SwitchStatement
Default, Nil = {}, setmetatable({}, {__call = function () end}) -- for uniqueness
function switch (i)
	return setmetatable({ i }, {
		__call = function (t, cases)
			local item = #t == 0 and Nil or t[1]
			return (cases[item] or cases[Default] or Nil)(item)
		end
	})
end

--CLI
local cli = require("cli.lua")
local cliArgs = require("cli-args.lua")
local pargs = cli.parseArgs({...}, cliArgs)
if pargs == "INTERRUPT" then
	return
end
print(textutils.serialize(pargs))
