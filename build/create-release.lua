-- File: create-release.lua
-- Copyright 2026 Jasper Habicht (mail(at)jasperhabicht.de).

-- Create a .zip archive as release from the current project repo.

-- Run texlua from within `build` subdirectory with following command:
-- create-release.lua

os.execute('cd .. && git archive --prefix=hawkdraw/ --output=hawkdraw.zip HEAD')

local release_file = io.open('../hawkdraw-doc.tex', 'rb')
local release_data = release_file:read('*a')
release_file:close()

local release_version = string.match(release_data, '\\def\\hawkdrawfileversion{(%d+%.%d+%.%d+)}')

local release_changes = string.match(release_data, '\\changes{v' .. release_version .. '}{%d%d%d%d/%d%d/%d%d}{([^}]*)}')
print('Version ' .. release_version .. ':')
print(release_changes)

-- EOF