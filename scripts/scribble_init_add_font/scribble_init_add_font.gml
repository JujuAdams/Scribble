/// @param font

if ( !variable_global_exists( "__scribble_init_font_array" ) ) || ( global.__scribble_init_font_array == undefined )
{
    show_error( "scribble_init_add_font() can only be used after scribble_init_start() and before scribble_init_end()\n ", true );
    exit;
}

var _font = argument0;

if ( asset_get_type( _font ) == asset_sprite )
{
    show_error( "To add a spritefont, please use scribble_init_add_spritefont()\n ", false );
}

global.__scribble_init_font_array[ array_length_1d( global.__scribble_init_font_array ) ] = _font;
if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;