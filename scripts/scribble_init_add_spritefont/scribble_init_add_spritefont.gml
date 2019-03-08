/// @param spritefont
/// @param [mapString]
/// @param [separation]

if ( !variable_global_exists( "__scribble_init_font_array" ) ) || ( global.__scribble_init_font_array == undefined )
{
    show_error( "scribble_init_add_spritefont() can only be used after scribble_init_start() and before scribble_init_end()\n ", true );
    exit;
}

var _font = argument[0];

if ( asset_get_type( _font ) != asset_sprite )
{
    show_error( "To add a normal font, please use scribble_init_add_font()\n ", false );
    return scribble_init_add_font( _font );
}

if ( argument_count == 1 )
{
    global.__scribble_init_font_array[ array_length_1d( global.__scribble_init_font_array ) ] = [ _font, SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING, 0 ];
    if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;
}
else if ( argument_count == 2 )
{
    global.__scribble_init_font_array[ array_length_1d( global.__scribble_init_font_array ) ] = [ _font, argument[1], 0 ];
    if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;
}
else if ( argument_count == 3 )
{
    global.__scribble_init_font_array[ array_length_1d( global.__scribble_init_font_array ) ] = [ _font, argument[1], argument[2] ];
    if ( global.__scribble_default_font == "" ) global.__scribble_default_font = _font;
}
else
{
    show_error( "Invalid number of arguments provided for a spritefont (" + string( argument_count ) + ", expecting 1, 2, or 3 arguments)\n ", true );
}