// Feather disable all

/// @param fontName
/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __scribble_get_material(_font_name, _texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear)
{
    static _material_map = __scribble_initialize().__material_map;
    
    var _key = __scribble_make_material_key(_texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear);
    
    var _material = _material_map[? _key];
    if (_material == undefined)
    {
        _material = new __scribble_class_material(_key, _font_name, _texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear);
        _material_map[? _key] = _material;
    }
    
    return _material;
}