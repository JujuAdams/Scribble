// Feather disable all

/// Defines an event - a script that can be executed (with parameters) by an in-line command tag
/// 
/// @param name              Name of the new formatting tag to add e.g. portrait adds the tag [portrait] for use
/// @param function/method   Function or method to execute

function scribble_typists_add_event(_name, _function)
{
    if (not is_string(_name))
    {
        __scribble_error("Event names should be strings\n(Input to script was \"", _name, "\")");
        return;
    }
    
    _name = string_trim(_name);
    
    if (not is_callable(_function))
    {
        __scribble_error("Invalid function provided\n(Input datatype was \"", typeof(_function), "\")");
        return;
    }
    
    __scribble_add_tag(_name, __SCRIBBLE_TAG_EVENT, { __function: _function }, false);
}
