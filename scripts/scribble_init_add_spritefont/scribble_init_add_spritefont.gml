/// Adds a spritefont definition for Scribble
///
/// Scribble's spritefonts emulate GameMaker's native behaviour. Spritefonts otherwise behave indentically to standard fonts
/// All Scribble spritefonts are proportional (see font_add_sprite() for more details).
///
/// @param fontName       String name of the spritefont to add
/// @param [spaceWidth]   Pixel width of the space character. Defaults to emulating GameMaker's behaviour
/// @param [mapString]    Same behaviour as GameMaker's native font_add_sprite(). Defaults to the value set in __scribble_config()
/// @param [separation]   Same behaviour as GameMaker's native font_add_sprite(). Defaults to the value set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

if ( !variable_global_exists( "__scribble_init_complete" ) )
{
    show_error( "scribble_init_add_spritefont() should be called after scribble_init_start() and before scribble_init_end()\n ", true );
    exit;
}

if ( global.__scribble_init_complete )
{
    show_error( "scribble_init_add_spritefont() should be called before scribble_init_end()\n ", true );
    return undefined;
}

var _font        =                                                       argument[0];
var _space_width =  (argument_count > 1)?                                argument[1] : undefined;
var _mapstring   = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
var _separation  = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;

if ( ds_map_exists( global.__scribble_font_data, _font ) )
{
    show_error( "Font \"" + _font + "\" has already been defined\n ", false );
    return undefined;
}

if ( !is_string( _font ) )
{
    if ( is_real( _font ) )
    {
        show_error( "Fonts should be initialised using their name as a string.\n(Input to script was \"" + string( _font ) + "\", which might be sprite \"" + sprite_get_name( _font ) + "\")\n ", false );
    }
    else
    {
        show_error( "Fonts should be initialised using their name as a string.\n(Input to script was an invalid datatype)\n ", false );
    }
    exit;
}

if ( asset_get_type( _font ) != asset_sprite )
{
    show_error( "To add a normal font, please use scribble_init_add_font()\n ", false );
    return scribble_init_add_font( _font );
}

if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;

var _data;
_data[ __E_SCRIBBLE_FONT.NAME           ] = _font;
_data[ __E_SCRIBBLE_FONT.TYPE           ] = __E_SCRIBBLE_FONT_TYPE.SPRITE;
_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP     ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY   ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPH_MIN      ] = 32;
_data[ __E_SCRIBBLE_FONT.GLYPH_MAX      ] = 32;
_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] = undefined;
_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH    ] = _space_width;
_data[ __E_SCRIBBLE_FONT.MAPSTRING      ] = _mapstring;
_data[ __E_SCRIBBLE_FONT.SEPARATION     ] = _separation;
_data[ __E_SCRIBBLE_FONT.IMPORT_SPRITE  ] = undefined;
_data[ __E_SCRIBBLE_FONT.PACKED_SPRITE  ] = asset_get_index( _font );
_data[ __E_SCRIBBLE_FONT.SPRITE_X       ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE_Y       ] = undefined;
global.__scribble_font_data[? _font ] = _data;

show_debug_message( "Scribble: Defined \"" + _font + "\" as a spritefont" );