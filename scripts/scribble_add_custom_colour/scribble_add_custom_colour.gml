/// @param name
/// @param colour
/// @param [swapRedBlue]

var _name   = argument[0];
var _colour = argument[1];
var _swap   = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;

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

if ( _swap )
{
    _colour = make_colour_rgb( colour_get_blue( _colour ), colour_get_green( _colour ), colour_get_red( _colour ) );
}

global.__scribble_colours[? _name ] = _colour;