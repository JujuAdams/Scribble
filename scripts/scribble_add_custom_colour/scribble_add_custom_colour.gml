/// @param name
/// @param colour
/// @param [colourIsGameMakerBGR]

var _name   = argument[0];
var _colour = argument[1];
var _native = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;

if ( !variable_global_exists( "__scribble_init_complete" ) )
{
    show_error( "scribble_add_custom_colour() should be called after initialising Scribble.\n ", false );
    exit;
}

if ( !is_string( _name ) )
{
    show_error( "Custom colour names should be strings.\n ", false );
    exit;
}

if ( !is_real( _colour ) )
{
    show_error( "Custom colours should be specificed as 24-bit integers.\n ", false );
    exit;
}

if ( !_native )
{
    _colour = make_colour_rgb( colour_get_blue( _colour ), colour_get_green( _colour ), colour_get_red( _colour ) );
}

global.__scribble_colours[? _name ] = _colour;

show_debug_message( "Scribble: Added colour name \"" + _name + "\" as colour " + string(colour_get_red(_colour)) + "," + string(colour_get_green(_colour)) + "," + string(colour_get_blue(_colour)) + " (" + string(_colour) + ")" );