// Feather disable all

/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __scribble_make_material_key(_texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear)
{
    return string_join(":", _texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear);
}