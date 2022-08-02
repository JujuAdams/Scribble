/// @param name

function scribble_font_delete(_name)
{
    if (!ds_map_exists(global.__scribble_font_data, _name)) return;
    
    global.__scribble_font_data[? _name].__destroy();
    ds_map_delete(global.__scribble_font_data, _name);
}
