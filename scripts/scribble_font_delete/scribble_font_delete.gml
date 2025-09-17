// Feather disable all
/// @param name

function scribble_font_delete(_name)
{
    static _fontDataMap = __scribble_system().__fontDataMap;
    if (!ds_map_exists(_fontDataMap, _name)) return;
    
    _fontDataMap[? _name].__Destroy();
    ds_map_delete(_fontDataMap, _name);
}
