/// void scribble_add_colour(name, colour, [colourIsGameMakerBGR]);
/// Adds a custom colour for use as an in-line colour definition for scribble_create() 
///
/// This script allows for the definition of a custom colour that can be referenced by name in scribble_create()
/// This script assumes you're *NOT* using GameMaker's wacky BGR colour format.
///
/// @param name                     String name of the colour
/// @param colour                   The colour itself as a 24-bit integer
/// @param [colourIsGameMakerBGR]   Whether the colour is a native GM colour value. Defaults to <false>
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _name   = argument[0];
var _colour = argument[1];
var _native = ternary((argument_count > 2) && (argument[2] != undefined), argument[2], false);

if ( global.__scribble_init_complete ) {
    show_error( "scribble_add_colour() should be called after initialising Scribble.", false );
    exit;
}

if ( !is_string( _name ) ) {
    show_error( "Custom colour names should be strings.", false );
    exit;
}

if ( !is_real( _colour ) ) {
    show_error( "Custom colours should be specificed as 24-bit integers.", false );
    exit;
}

if ( !_native ) {
    _colour = make_colour_rgb( colour_get_blue( _colour ), colour_get_green( _colour ), colour_get_red( _colour ) );
}

global.__scribble_colours[? _name ] = _colour;

show_debug_message( "Scribble: Added colour name " + _name + " as colour " + string(colour_get_red(_colour)) + "," + string(colour_get_green(_colour)) + "," + string(colour_get_blue(_colour)) + " (" + string(_colour) + ")" );
