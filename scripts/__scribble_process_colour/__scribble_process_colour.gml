// Feather disable all

function __scribble_process_colour(_value)
{
    static _tagDict = __scribble_system().__tagDict;
    
    if (is_string(_value))
    {
        var _tagStruct = _tagDict[$ _value];
        if not (is_struct(_tagStruct) && (_tagStruct.__type == __SCRIBBLE_TAG_COLOR))
        {
            __scribble_error("Colour \"", _value, "\" not recognised");
        }
        
        return (_tagStruct.__data & 0xFFFFFF);
    }
    else
    {
        return _value;
    }
}