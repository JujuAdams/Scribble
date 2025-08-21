// Feather disable all

/// @param font

function __scribble_font_add_from_bundle(_font)
{
    static _font_to_texture_group_map = __scribble_system().__font_to_texture_group_map;
    
    var _texture_group = _font_to_texture_group_map[? real(_font)];
    
    var _name        = font_get_name(_font);
    var _asset       = asset_get_index(_name);
    var _texture_uvs = font_get_uvs(_asset);
    var _font_info   = font_get_info(_font);
    var _is_krutidev = __scribble_asset_is_krutidev(_font, asset_font);
    
    var _old_font = draw_get_font();
    draw_set_font(_font);
    var _line_height = string_height(" ");
    draw_set_font(_old_font);
    
    return __scribble_font_add_from_info(_name, _texture_group, _texture_uvs, _font_info, _line_height, _is_krutidev, true);
}