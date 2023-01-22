#macro __font_delete__ font_delete
#macro font_delete __scribble_font_delete_from_file

function __scribble_font_delete_from_file(_font) {
    static _font_data_map = __scribble_get_font_data_map();
    
    if (!font_exists(_font)) || (!ds_map_exists(_font_data_map, font_get_name(_font))) {
        __scribble_error("font " + string(_font) + " doesn't exist!");
    }
    
    var _name = font_get_name(_font);
    _font_data_map[? _name].__destroy();
    ds_map_delete(_font_data_map, _name);
    __font_delete__(_font);
}