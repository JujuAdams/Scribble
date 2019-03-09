/// @param spritefont
/// @param [spaceWidth]
/// @param [mapString]
/// @param [separation]

if ( !variable_global_exists( "__scribble_default_font" ) )
{
    show_error( "scribble_init_add_spritefont() can only be called after scribble_init_start() and before scribble_init_end()\n ", true );
    exit;
}

var _font        = argument[0];
var _space_width =  (argument_count > 1)?                                argument[1] : undefined;
var _mapstring   = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
var _separation  = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;

if ( ds_map_exists( global.__scribble_font_data, _font ) )
{
    show_error( "Font \"" + _font + "\" has already been defined\n ", false );
    return undefined;
}

if ( asset_get_type( _font ) != asset_sprite )
{
    show_error( "To add a normal font, please use scribble_init_add_font()\n ", false );
    return scribble_init_add_font( _font );
}

if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;

var _data;
_data[ __E_SCRIBBLE_FONT.NAME           ] = _font;
_data[ __E_SCRIBBLE_FONT.TYPE           ] = asset_sprite;
_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] = undefined;
_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH    ] = _space_width;
_data[ __E_SCRIBBLE_FONT.MAPSTRING      ] = _mapstring;
_data[ __E_SCRIBBLE_FONT.SEPARATION     ] = _separation;
_data[ __E_SCRIBBLE_FONT.SPRITE         ] = asset_get_index( _font );
_data[ __E_SCRIBBLE_FONT.SPRITE_X       ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE_Y       ] = undefined;
global.__scribble_font_data[? _font ] = _data;