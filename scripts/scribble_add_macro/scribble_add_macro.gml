/// @param name
/// @param function

function scribble_add_macro(_name, _function)
{
    __scribble_initialize();
    
    if (!is_string(_name))
    {
        __scribble_error("Macro names should be strings.\n(Input to script was \"", _name, "\")");
        exit;
    }
    
    if (!is_method(_function))
    {
        if (is_real(_function))
        {
            if (!script_exists(_function))
            {
                __scribble_error("Script with asset index ", _function, " doesn't exist\n ", false);
                exit;
            }
        }
        else
        {
            __scribble_error("Invalid function provided\n(Input datatype was \"", typeof(_function), "\")");
            exit;
        }
    }
    
    if (ds_map_exists(__scribble_config_colours(), _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as a colour");
        exit;
    }
    
    if (ds_map_exists(__scribble_get_effects_map(), _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as an effect");
        exit;
    }
    
    if (ds_map_exists(__scribble_get_typewriter_events_map(), _name))
    {
        __scribble_trace("Warning! Macro name \"" + _name + "\" has already been defined as a typist event");
        exit;
    }
    
    var _macros_map = __scribble_get_macros_map();
    var _old_function = _macros_map[? _name];
    if (!is_undefined(_old_function))
    {
        if (is_numeric(_old_function) and (_old_function < 0))
        {
            __scribble_trace("Warning! Overwriting event [" + _name + "] tied to <invalid script>");
        }
        else
        {
            __scribble_trace("Warning! Overwriting event [" + _name + "] tied to \"" + (is_method(_old_function)? string(_old_function) : script_get_name(_old_function)) + "\"");
        }
    }
    
    _macros_map[? _name] = _function;
    if (SCRIBBLE_VERBOSE) __scribble_trace("Tying macro [" + _name + "] to \"" + (is_method(_function)? string(_function) : script_get_name(_function)) + "\"");
}