// Feather disable all
/// @param name
/// @param function

function scribble_add_macro(_name, _function)
{
    static _system                = __scribble_initialize();
    static _effects_map           = _system.__effects_map;
    static _macros_map            = _system.__macros_map;
    static _typewriter_events_map = _system.__typewriter_events_map;
    
    if (!is_string(_name))
    {
        __scribble_error("Macro names should be strings.\n(Input to script was \"", _name, "\")");
        exit;
    }
    
    if (is_undefined(_function) || (!is_method(_function) && !script_exists(_function)))
    {
        __scribble_error("Invalid function provided\n(Input datatype was \"", typeof(_function), "\")");
        exit;
    }
    
    if (variable_struct_exists(__scribble_config_colours(), _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as a colour");
        exit;
    }
    
    if (ds_map_exists(_effects_map, _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as an effect");
        exit;
    }
    
    if (ds_map_exists(_typewriter_events_map, _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as a typist event");
        exit;
    }
    
    var _old_function = _macros_map[? _name];
    if (!is_undefined(_old_function))
    {
        __scribble_trace("Warning! Overwriting event [" + _name + "] tied to \"" + (is_method(_old_function)? string(_old_function) : script_get_name(_old_function)) + "\"");
    }
    
    _macros_map[? _name] = _function;
    if (SCRIBBLE_VERBOSE) __scribble_trace("Tying macro [" + _name + "] to \"" + (is_method(_function)? string(_function) : script_get_name(_function)) + "\"");
}
