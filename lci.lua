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
do
	local ext = require("ext.lua")

	local INTERRUPT = false

	local options = {
		["help"] = {
			aliases = "h",
			params = 0,
			action = function()
				print("Help")
				INTERRUPT = true
			end
		},
		["test"] = {
			aliases = "t",
			params = 1,
			action = function(inp)
				print(tostring(inp))
			end
		}
	}

	--Populate aliases
	local modify = {}
	for k, v in pairs(options) do
		if v.aliases then
			v.trueName = k
			local t = ext.split(v.aliases, "%s")
			for i=1, #t do
				modify[t[i]] = v
			end
			v.aliases = nil
		end
	end
	for k, v in pairs(modify) do
		options[k] = v
	end

	local rawargs = {...}
	local pargs = {args={},options={}}
	local seek = 0
	local seeko = {}
	local seekf = ""
	local currc
	for i=1, #rawargs do
		local str = rawargs[i]
		local misjudge = false
		local hasSook = false
		if seek > 0 then
			if str:sub(1, 1) == "-" or str:sub(1, 2) == "--" then
				--Not gonna supply that arg I guess
				seek = 0 --stop searching
				misjudge = true --do normal parse on this guy
			else
				seeko[#seeko + 1] = str
				seek = seek - 1
			end

			local done
			if seek <= 0 then
				done = true
			end
			if done and currc then
				pargs.options[#pargs.options + 1] = {name = seekf, args = seeko}
				currc(unpack(seeko))
				currc = nil
			end
			hasSook = true
		end

		if misjudge or (seek <= 0 and not hasSook) then --should never be less than 0 but just to be safe
			if str:sub(1, 2) == "--" then
				local opcode = str:sub(3)
				local ref = options[opcode]
				if ref then
					if ref.params then
						seek = ref.params
						seekf = ref.trueName
					end
					if ref.action then
						if seek <= 0 then
							--Just call it now
							ref.action()
						else
							currc = ref.action
						end
					end
				else
					printError("\nERROR PARSING OPTIONS:")
					printError("Unknown option '"..oplist[j].."'")
					printError("Try -h or --help")
					INTERRUPT = true
				end
			elseif str:sub(1, 1) == "-" then
				-- String of minized options
				local oplist = ext.split(str:sub(2))
				for j=1, #oplist do
					local ref = options[oplist[j]]
					if ref then
						if ref.params and j==#oplist then --only do params if we're last like commit -am "Yo"
							seek = ref.params
							seekf = ref.trueName
						end
						if ref.action then
							if seek <= 0 then
								--Just call it now
								ref.action()
							else
								currc = ref.action
							end
						end
					else
						printError("\nERROR PARSING OPTIONS:")
						printError("Unknown option '"..oplist[j].."'")
						printError("Try -h or --help")
						INTERRUPT = true
					end
					if INTERRUPT then break end
				end
			else
				-- Not an option but a legit argument, just append it to pargs
				pargs.args[#pargs.args + 1] = str
			end
		end

		if INTERRUPT then return end
	end
	if seek > 0 then
		--Alrighty then
		currc(unpack(seeko))
	end
	print(textutils.serialize(pargs))
end
