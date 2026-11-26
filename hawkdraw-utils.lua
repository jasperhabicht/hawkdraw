-- File: hawkdraw-utils.lua
-- Copyright 2026 Jasper Habicht (mail(at)jasperhabicht.de).
--
-- This work may be distributed and/or modified under the
-- conditions of the LaTeX Project Public License version 1.3c,
-- available at http://www.latex-project.org/lppl/.
--
-- This file is part of the `hawkdraw' package (The Work in LPPL)
-- and all files in that bundle must be distributed together.
--
-- This work has the LPPL maintenance status `maintained'.
--
-- BOF

-- v0.12.0 2026-11-26

luatexbase.new_luacommand(
    '__hawkdraw_hex_to_stream_auxi:w',
    function()
        token.put_next(token.new(0x110000 + token.scan_int(), 12))
    end,
    'global'
)

-- EOF