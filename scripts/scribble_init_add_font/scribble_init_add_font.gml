/// Adds a standard font definition for Scribble
///
/// Scribble requires all standard fonts to have their .yy file added as an included file
/// This means every time you modify a font you also need to update the included .yy file
///
/// (Including .yy files isn't necessary for spritefonts)
///
/// @param fontName   String name of the font to add

if ( !variable_global_exists( "__scribble_init_complete" ) )
{
    show_error( "scribble_init_add_font() should be called after scribble_init_start()\n ", true );
    return undefined;
}

if ( global.__scribble_init_complete )
{
    show_error( "scribble_init_add_font() should be called before scribble_init_end()\n ", true );
    return undefined;
}

var _font = argument0;

if ( ds_map_exists( global.__scribble_font_data, _font ) )
{
    show_error( "Font \"" + _font + "\" has already been defined\n ", false );
    return undefined;
}

if ( !is_string( _font ) )
{
    if ( is_real( _font ) )
    {
        show_error( "Fonts should be initialised using their name as a string.\n(Input was \"" + string( _font ) + "\", which might be font \"" + font_get_name( _font ) + "\")\n ", false );
    }
    else
    {
        show_error( "Fonts should be initialised using their name as a string.\n(Input was an invalid datatype)\n ", false );
    }
    exit;
}

if ( asset_get_type( _font ) == asset_sprite )
{
    show_error( "To add a spritefont, please use scribble_init_add_spritefont()\n ", false );
    return scribble_init_add_spritefont( _font );
}

if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;

var _data;
_data[ __E_SCRIBBLE_FONT.NAME         ] = _font;
_data[ __E_SCRIBBLE_FONT.TYPE         ] = __E_SCRIBBLE_FONT_TYPE.FONT;
_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP   ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPH_MIN    ] = 32;
_data[ __E_SCRIBBLE_FONT.GLYPH_MAX    ] = 32;
_data[ __E_SCRIBBLE_FONT.TEXTURE      ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH  ] = undefined;
_data[ __E_SCRIBBLE_FONT.MAPSTRING    ] = undefined;
_data[ __E_SCRIBBLE_FONT.SEPARATION   ] = undefined;
global.__scribble_font_data[? _font ] = _data;

show_debug_message( "Scribble: Defined \"" + _font + "\" as a standard font" );