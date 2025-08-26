// Feather disable all

/// @param name
/// @param type
/// @param data
/// @param protected
/// @param [debugText]

function __scribble_add_tag(_name, _type, _data, _protected, _debugText = "")
{
    static _system  = __scribble_system();
    static _tagDict = _system.__tagDict;
    
    var _existingTag = _tagDict[$ _name];
    if (is_struct(_existingTag))
    {
        if (_existingTag.__protected)
        {
            __scribble_error("Tag [", _name, "] is protected and cannot be replaced");
        }
        else
        {
            __scribble_trace("Warning! Overwriting tag [", _name, "]");
        }
    }
    
    var _tag = new __scribble_class_tag(_name, _type, _data, _protected);
    _tagDict[$ _name] = _tag;
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Added ", _protected? "protected " : "", "tag type ", _type, " [" + _name + "] ", _debugText);
    
    if (is_struct(_existingTag))
    {
        scribble_flush_everything();
    }
    
    return _tag;
}