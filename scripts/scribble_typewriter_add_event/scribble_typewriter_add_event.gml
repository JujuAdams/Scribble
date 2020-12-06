/// Defines an event - a script that can be executed (with parameters) by an in-line command tag
/// 
/// @param name              Name of the new formatting tag to add e.g. portrait adds the tag [portrait] for use
/// @param function/method   Function or method to execute

function scribble_typewriter_add_event(_name, _function)
{
    if (!variable_global_exists("__scribble_typewriter_events")) global.__scribble_typewriter_events = ds_map_create();
    
    if (!is_string(_name))
    {
        show_error("Scribble:\nEvent names should be strings.\n(Input to script was \"" + string(_name) + "\")\n ", false);
        exit;
    }
    
    if (!is_method(_function))
    {
        if (is_real(_function))
        {
            if (!script_exists(_function))
            {
                show_error("Scribble:\nScript with asset index " + string(_function) + " doesn't exist\n ", false);
                exit;
            }
        }
        else
        {
            show_error("Scribble:\nInvalid function provided\n(Input datatype was \"" + typeof(_function) + "\")\n ", false);
            exit;
        }
    }
    
    if (ds_map_exists(global.__scribble_colours, _name))
    {
        __scribble_trace("WARNING! Event name \"" + _name + "\" has already been defined as a colour");
        exit;
    }
    
    if (ds_map_exists(global.__scribble_effects, _name))
    {
        __scribble_trace("WARNING! Event name \"" + _name + "\" has already been defined as an effect");
        exit;
    }
    
    var _old_function = global.__scribble_typewriter_events[? _name];
    if (!is_undefined(_old_function))
    {
        __scribble_trace("WARNING! Overwriting event [" + _name + "] tied to \"" + (is_method(_old_function)? string(_old_function) : script_get_name(_old_function)) + "\"");
    }
    
    global.__scribble_typewriter_events[? _name] = _function;
    if (SCRIBBLE_VERBOSE) __scribble_trace("Tying event [" + _name + "] to \"" + (is_method(_function)? string(_function) : script_get_name(_function)) + "\"");
}