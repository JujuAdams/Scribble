/// @param name
/// @param script

if ( !variable_global_exists( "__scribble_init_complete" ) )
{
    show_error( "scribble_add_event() should be called after initialising Scribble.\n ", false );
    exit;
}

global.__scribble_events[? argument0 ] = argument1;