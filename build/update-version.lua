-- File: update-version.lua
-- Copyright 2026 Jasper Habicht (mail(at)jasperhabicht.de).

-- Update version number and date in all relevant files in the project repo.

-- Run texlua from within `build` subdirectory with following command:
-- update-version.lua <version> <date>

-- Format of <version>: <major>.<minor>.<patch>
-- -- <major>, <minor>, <patch>: one or more digits.

-- Format of <date>: <year>-<month>-<day>
-- -- <year>: four digits
-- -- <month>, <day>: two digits.

-- Replacement patterns in `update-version-files.json` in `build` subdirectory.
-- For each file type, the following entries are given:
-- "pattern_file": Lua pattern to identify the file type by extension.
-- "pattern_version": Lua pattern for replacement of version.
-- "pattern_daze": Lua pattern for replacement of date.
-- "date_format" (optional): Boolean, date will be formatted naturally if set.

-- "pattern_version", "pattern_date": part before and after version or date
-- -- as group in parenthesis and in replacement as `%1` and `%2`.

if #arg ~= 2 then
    error('Usage: update-version.lua <version> <date>.')
end

local update_version = arg[1]
local update_date = arg[2]

if string.match(update_version, '%d+%.%d+%.%d+') == nil then
    error('Version requires format: <major>.<minor>.<patch>.')
end

if string.match(update_date, '%d%d%d%d%-%d%d%-%d%d') == nil then
    error('Date requires format: <year>-<month>-<day>.')
end

local _, _, date_year, date_month, date_day =
    string.find(update_date, '(%d%d%d%d)%-(%d%d)%-(%d%d)')
local update_date_format = string.format('%d', date_day) .. ' ' ..
    os.date('%B %Y', os.time{year=date_year, month=date_month, day=date_day})

package.path = package.path .. ';C:/texlive/2026/texmf-dist/tex/luatex/lualibs/?.lua'
require('lualibs')
local json_file = io.open('update-version-files.json', 'rb')
local json_data = json_file:read('*a')
json_file:close()
local update_replacements = utilities.json.tolua(json_data)

require('lfs')
lfs.chdir('..')
for i = 1, #update_replacements do
    for dir_file in lfs.dir('.') do
        if string.match(dir_file, update_replacements[i]['pattern_file']) ~= nil then
            local update_file = io.open(dir_file, 'rb')
            local update_data = update_file:read('*a')
            update_file:close()
            update_data = string.gsub(update_data, update_replacements[i]['pattern_version'], '%1' .. update_version .. '%2', 1)
            if update_replacements[i]['date_format'] then
                update_data = string.gsub(update_data, update_replacements[i]['pattern_date'], '%1' .. update_date_format .. '%2', 1)
            else
                update_data = string.gsub(update_data, update_replacements[i]['pattern_date'], '%1' .. update_date .. '%2', 1)
            end
            local update_file = io.open(dir_file, 'wb')
            update_file:write(update_data)
            update_file:close()
        end
    end
end

-- EOF