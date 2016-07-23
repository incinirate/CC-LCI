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

local ext = {}

function ext.split(str, delim)
    local t = {}
    local regex = delim and "[^" .. delim .. "]+" or "."
    for n in str:gmatch(regex) do
        t[#t + 1] = n
    end
    return t
end

return ext
