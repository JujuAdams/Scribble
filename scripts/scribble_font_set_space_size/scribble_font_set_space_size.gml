/// @param font
/// @param width

if ( SCRIBBLE_SAFE_MODE )
{
    if ( !variable_global_exists( "__scribble_init_font_array" ) ) || ( global.__scribble_init_font_array != undefined )
    {
        show_error( "Font properties can only be modified after calling scribble_init_end()\n ", true );
        exit;
    }
}

var _font_glyphs_map = global.__scribble_glyphs_map[? argument0 ];
var _array = _font_glyphs_map[? " " ];
_array[@ __E_SCRIBBLE_GLYPH.W   ] = argument1;
_array[@ __E_SCRIBBLE_GLYPH.SHF ] = argument1;