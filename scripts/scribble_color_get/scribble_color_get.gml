// Feather disable all

/// Returns the colour for the given colour name
/// If the colour doesn't exist, this function will return <undefined>
/// 
/// @param name

function scribble_color_get(_name)
{
    static _tagDict = __scribble_system().__tagDict;
    
    var _tagStruct = _tagDict[$ _name];
    if (is_struct(_tagStruct) && (_tagStruct.__type == __SCRIBBLE_TAG_COLOR))
    {
        return _tagStruct.__data;
    }
    else
    {
        return undefined;
    }
}
