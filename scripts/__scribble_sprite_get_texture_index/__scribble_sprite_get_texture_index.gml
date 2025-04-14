// Feather disable all

/// @param sprite
/// @param image

function __scribble_sprite_get_texture_index(_sprite, _image)
{
    static _sprite_texture_index_map = __scribble_initialize().__sprite_texture_index_map;
    
    if (not sprite_exists(_sprite))
    {
        if (GM_build_type == "run")
        {
            __scribble_error($"Sprite \"{_sprite}\" does not exist");
        }
        
        return -1;
    }
    
    var _count = sprite_get_number(_sprite);
    
    //Check the cache for pre-calculated texture indexes
    var _array = _sprite_texture_index_map[? _sprite];
    if (not is_array(_array))
    {
        //No array found, extract texture indexs from sprite info into a new array for the cache
        _array = array_create(_count);
        
        var _sprite_info = sprite_get_info(_sprite);
        var _frame_array = _sprite_info.frames;
        
        var _i = 0;
        repeat(_count)
        {
            _array[_i] = _frame_array[_i].texture;
            ++_i;
        }
    }
    
    //Wrap the image value around safely. This is a "wrapping modulo" rather than GM's native
    //modulo which handles `(-a) mod b` as `-(a mod b)`
    _image = _image - _count*floor(_image/_count);
    
    return _array[_image];
}