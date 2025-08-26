// Feather disable all

/// @param name
/// @param function
/// @param [dynamic=false]

function scribble_add_macro(_name, _function, _dynamic = false)
{
    static _system  = __scribble_system();
    static _tagDict = _system.__tagDict;
    
    if (not is_string(_name))
    {
        __scribble_error("Macro names should be strings.\n(Input to script was \"", _name, "\")");
        return;
    }
    
    _name = string_trim(_name);
    
    if (not is_callable(_function))
    {
        __scribble_error("Invalid function provided\n(Input datatype was \"", typeof(_function), "\")");
        return;
    }
    
    __scribble_add_tag(_name, __SCRIBBLE_TAG_MACRO, { __function: _function, __dynamic: _dynamic }, false, "(", _dynamic? "dynamic" : "static", ")");
}
