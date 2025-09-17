// Feather disable all
/// @param name

function scribble_font_exists(_name)
{
    static _fontDataMap = __scribble_system().__fontDataMap;
    return ds_map_exists(_fontDataMap, _name);
}
