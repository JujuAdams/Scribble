// Feather disable all

/// @param name

function __scribble_remove_tag(_name)
{
    static _system  = __scribble_system();
    static _tagDict = _system.__tagDict;
    
    var _existingTag = _tagDict[$ _name];
    if (is_struct(_existingTag))
    {
        if (_existingTag.__protected)
        {
            __scribble_error("Tag [", _name, "] is protected and cannot be removed");
        }
        
        variable_struct_remove(_tagDict, _name);
        
        scribble_flush_everything();
    }
}