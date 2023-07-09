//Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour
#macro SCRIBBLE_HASH_NEWLINE  false

//Replaces newline literals ("\\n") with an actual newline ("\n")
#macro SCRIBBLE_FIX_ESCAPED_NEWLINES  false

//Whether to use sprite origins. Setting this to <false> will vertically centre sprites on the line of text
#macro SCRIBBLE_ADD_SPRITE_ORIGINS  false

//Character to use when another character is missing from a font
#macro SCRIBBLE_MISSING_CHARACTER  "?"

//Whether to use text element sizes (false) or page sizes (true) for bounding box calculations
#macro SCRIBBLE_BOUNDING_BOX_USES_PAGE  true

//Width of a horizontal tab, as a number of spaces
#macro SCRIBBLE_TAB_WIDTH  4

//Controls if spaces and tabs have a fixed, unchanging size. Setting this to <false> will ensure that spaces are always the same size, which is useful for monospaced fonts
#macro SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH  true

//Sets whether pin alignments use the size of the page for positioning, or the size of the text element (the bounding box across all pages)
#macro SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE  false

//Set to <true> to enable the .get_text() method on text elements. This will apply to all text elements and carries a performance penalty
#macro SCRIBBLE_ALLOW_TEXT_GETTER  false

//Set to <true> to enable the .get_glyph_data() method on text elements (and a few other features too). This will apply to all text elements and carries a performance penalty
#macro SCRIBBLE_ALLOW_GLYPH_DATA_GETTER  false

//Whether to automatically scale sprites to fit into the line of text. This is based on the font height of the current font
#macro SCRIBBLE_AUTOFIT_INLINE_SPRITES  false

//Whether to automatically scale surfaces to fit into the line of text. This is based on the font height of the current font
#macro SCRIBBLE_AUTOFIT_INLINE_SURFACES  false

#macro SCRIBBLE_USE_KERNING  true

#macro SCRIBBLE_DELAY_LAST_CHARACTER  false

//Whether spritefonts should default to having bilinear texture filtering or not
#macro SCRIBBLE_DEFAULT_SPRITEFONT_BILINEAR  false

//Whether standard fonts should default to having bilinear texture filtering or not
#macro SCRIBBLE_DEFAULT_STANDARD_BILINEAR  true

#macro SCRIBBLE_ALWAYS_USE_FULL_PAGE_HEIGHT  false