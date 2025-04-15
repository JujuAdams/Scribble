// Feather disable all

/// @param sprite
/// @param image

function __scribble_sprite_get_material(_sprite, _image)
{
    static _sprite_texture_material_map = __scribble_initialize().__sprite_texture_material_map;
    
    var _texture_index = __scribble_sprite_get_texture_index(_sprite, _image);
    var _material = _sprite_texture_material_map[? _texture_index];
    if (_material == undefined)
    {
        var _material = __scribble_get_material(sprite_get_name(_sprite), _texture_index, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
        _sprite_texture_material_map[? _texture_index] = _material;
    }
    
    return _material;
}