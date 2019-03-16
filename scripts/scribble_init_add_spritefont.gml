/// something scribble_init_add_spritefont(fontName, [spaceWidth], [mapString], [separation])
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

if ( global.__scribble_init_complete == SCRIBBLE_INIT_START ) {
    show_error( "scribble_init_add_spritefont() should be called after scribble_init_start() and before scribble_init_end()", true );
    exit;
}

if ( global.__scribble_init_complete == SCRIBBLE_INIT_COMPLETE ) {
    show_error( "scribble_init_add_spritefont() should be called before scribble_init_end()", true );
    return undefined;
}

var _font        = argument[0];
var _space_width = undefined;
var _mapstring   = SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
var _separation  = 0;

switch (argument_count){
    case 4:
        if ( argument[3] != undefined ) _separation = argument[3];
    case 3:
        if ( argument[2] != undefined ) _mapstring = argument[2];
    case 2:
        if ( argument[1] != undefined ) _space_width = argument[1];
        break;
}

if ( ds_map_exists( global.__scribble_font_data, _font ) ) {
    show_error( "Font " + _font + " has already been defined", false );
    return undefined;
}

if ( !is_string( _font ) ) {
    if ( is_real( _font ) ) {
        show_error( "Fonts should be initialised using their name as a string. (Input to script was " + string( _font ) + ", which might be sprite " + sprite_get_name( _font ) + ")", false );
    } else {
        show_error( "Fonts should be initialised using their name as a string. (Input to script was an invalid datatype)", false );
    }
    exit;
}

if ( asset_get_type( _font ) != asset_sprite ) {
    show_error( "To add a normal font, please use scribble_init_add_font()", false );
    return scribble_init_add_font( _font );
}

if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;

var _data = array_create( __E_SCRIBBLE_FONT.__SIZE );
_data[ __E_SCRIBBLE_FONT.NAME           ] = _font;
_data[ __E_SCRIBBLE_FONT.TYPE           ] = asset_sprite;
_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP     ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY   ] = undefined;
_data[ __E_SCRIBBLE_FONT.GLYPH_MIN      ] = 32;
_data[ __E_SCRIBBLE_FONT.GLYPH_MAX      ] = 32;
_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] = undefined;
_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH    ] = _space_width;
_data[ __E_SCRIBBLE_FONT.MAPSTRING      ] = _mapstring;
_data[ __E_SCRIBBLE_FONT.SEPARATION     ] = _separation;
_data[ __E_SCRIBBLE_FONT.SPRITE         ] = asset_get_index( _font );
_data[ __E_SCRIBBLE_FONT.SPRITE_X       ] = undefined;
_data[ __E_SCRIBBLE_FONT.SPRITE_Y       ] = undefined;
global.__scribble_font_data[? _font ] = _data;
