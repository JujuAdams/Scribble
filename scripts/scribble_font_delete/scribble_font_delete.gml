// Feather disable all
/// @param name

function scribble_font_delete(_name)
{
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    if (not ds_map_exists(_fontDataMap, _name)) return;
    
    _fontDataMap[? _name].__Destroy();
    ds_map_delete(_fontDataMap, _name);
}
