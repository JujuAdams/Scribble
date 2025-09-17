// Feather disable all

/// @param sprite
/// @param image

function __scribble_sprite_get_material(_sprite, _image)
{
    static _sprite_texture_material_map = __ScribbleSystem().__sprite_texture_material_map;
    
    var _textureIndex = __scribble_sprite_get_texture_index(_sprite, _image);
    var _material = _sprite_texture_material_map[? _textureIndex];
    if (_material == undefined)
    {
        var _material = __ScribbleGetMaterial(sprite_get_name(_sprite), _textureIndex, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
        _sprite_texture_material_map[? _textureIndex] = _material;
    }
    
    return _material;
}