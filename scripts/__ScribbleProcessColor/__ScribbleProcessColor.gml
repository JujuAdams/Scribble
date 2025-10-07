// Feather disable all

function __ScribbleProcessColor(_value)
{
    static _tagDict = __ScribbleSystem().__tagDict;
    
    if (is_string(_value))
    {
        var _tagStruct = _tagDict[$ _value];
        if not (is_struct(_tagStruct) && (_tagStruct.__type == __SCRIBBLE_TAG_COLOR))
        {
            __ScribbleError("Colour \"", _value, "\" not recognised");
        }
        
        return (_tagStruct.__data.__color & 0xFFFFFF);
    }
    else
    {
        return _value;
    }
}