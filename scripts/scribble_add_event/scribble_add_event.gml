/// Defines an event - a script that can be executed (with parameters) by an in-line command tag
///
///
///
/// @param name     Event name, as a string
/// @param script   Numerical script index e.g. your_script

var _name   = argument0;
var _script = argument1;

if ( !variable_global_exists("__scribble_init_complete") )
{
    show_error("scribble_add_event() should be called after initialising Scribble.\n ", false);
    exit;
}

if ( !is_string(_name) )
{
    show_error("Event names should be strings.\n(Input to script was \"" + string(_name) + "\")\n ", false);
    exit;
}

if ( !is_real(_script) )
{
    show_error("Scripts should be numerical script indices e.g. scribble_add_event(\"example\", your_script);\n(Input to script was \"" + string(_name) + "\")\n ", false);
    exit;
}

if ( !script_exists(_script) )
{
    show_error("Script (" + string(_script) + ") doesn't exist!\n ", false);
    exit;
}

global.__scribble_events[? _name ] = _script;