-- File: create-release.lua
-- Copyright 2026 Jasper Habicht (mail(at)jasperhabicht.de).

-- Create a .zip archive as release from the current project repo.

-- Run texlua from within `build` subdirectory with following command:
-- create-release.lua

os.execute('cd .. && git archive --prefix=hawkdraw/ --output=hawkdraw.zip HEAD')

-- EOF