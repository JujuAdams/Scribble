// Feather disable all

/// @param name

function __ScribbleRemoveTag(_name)
{
    static _system  = __ScribbleSystem();
    static _tagDict = _system.__tagDict;
    
    var _existingTag = _tagDict[$ _name];
    if (is_struct(_existingTag))
    {
        if (_existingTag.__protected)
        {
            __ScribbleError("Tag [", _name, "] is protected and cannot be removed");
        }
        
        variable_struct_remove(_tagDict, _name);
        
        scribble_flush_everything();
    }
}