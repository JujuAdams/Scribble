/// @param font

if ( !variable_global_exists( "__scribble_default_font" ) )
{
    show_error( "scribble_init_add_font() can only be called after scribble_init_start()\n ", true );
    return undefined;
}

var _font = argument0;

if ( ds_map_exists( global.__scribble_font_data, _font ) )
{
    show_error( "Font \"" + _font + "\" has already been defined\n ", false );
    return undefined;
}

if ( asset_get_type( _font ) == asset_sprite )
{
    show_error( "To add a spritefont, please use scribble_init_add_spritefont()\n ", false );
    return scribble_init_add_spritefont( _font );
}

if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;

var _data;
_data[ __E_SCRIBBLE_FONT.NAME           ] = _font;
_data[ __E_SCRIBBLE_FONT.TYPE           ] = asset_font;
_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] = undefined;
_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH    ] = undefined;
_data[ __E_SCRIBBLE_FONT.MAPSTRING      ] = undefined;
_data[ __E_SCRIBBLE_FONT.SEPARATION     ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE         ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE_X       ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE_Y       ] = undefined;
global.__scribble_font_data[? _font ] = _data;