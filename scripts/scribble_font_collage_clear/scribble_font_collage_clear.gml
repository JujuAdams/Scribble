function scribble_font_collage_clear(_target)
{
    var _font_data = global.__scribble_font_data[? _target];
    var _glyphs_map = _font_data.glyphs_map;
    ds_map_clear(_glyphs_map);
}