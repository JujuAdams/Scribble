// Feather disable all

/// @param key
/// @param fontName
/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __scribble_class_material(_key, _font_name, _texture_index_or_pointer, _render_type, _sdf_pxrange, _sdf_thickness_offset, _bilinear) constructor
{
    //FIXME - Can we remove `__SCRIBBLE_GEN_GLYPH.__FONT_NAME` and `SCRIBBLE_GLYPH.FONT_NAME`?
    
    __key                  = _key;
    __font_name            = _font_name; //Not used anywhere, added for debugging purposes
    __texture              = _texture_index_or_pointer;
    __texel_width          = texture_get_texel_width(_texture_index_or_pointer);
    __texel_height         = texture_get_texel_height(_texture_index_or_pointer);
    __render_type          = _render_type;
    __sdf_pxrange          = _sdf_pxrange;
    __sdf_thickness_offset = _sdf_thickness_offset;
    __bilinear             = _bilinear; //Can be `true`, `false`, or `undefined`
}