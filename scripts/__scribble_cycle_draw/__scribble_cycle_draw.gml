// Feather disable all\

/// @param name

function __scribble_cycle_draw(_name)
{
    static _data_map = __scribble_system().__cycle_data_map;
    
    var _data = _data_map[? _name];
    if (_data == undefined)
    {
        __scribble_error("Cycle \"", _name, "\" doesn't exist");
    }
    
    with(_data)
    {
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        if (is_array(__data))
        {
            var _array = __data;
            var _arrayLength = array_length(_array);
            
            if (_arrayLength == 1)
            {
                draw_sprite_stretched_ext(scribble_fallback_dot, 0, 0, __index, SCRIBBLE_CYCLE_TEXTURE_WIDTH, 1, _array[0], 1);
            }
            else
            {
                if (__smooth)
                {
                    if (__legacyBlend)
                    {
                        var _x = 0;
                        repeat(SCRIBBLE_CYCLE_TEXTURE_WIDTH)
                        {
                            var _i = _x / SCRIBBLE_CYCLE_TEXTURE_WIDTH;
                            
                            var _indexA = _arrayLength*_i;
                            var _frac   = frac(_indexA);
                                _indexA = floor(_indexA);
                            var _indexB = (1 + _indexA) mod _arrayLength;
                            
                            draw_sprite_ext(scribble_fallback_dot, 0,
                                            _x, __index,
                                            1, 1, 0,
                                            merge_color(_array[_indexA], _array[_indexB], _frac), 1);
                            ++_x;
                        }
                    }
                    else
                    {
                        var _x = 0;
                        repeat(SCRIBBLE_CYCLE_TEXTURE_WIDTH)
                        {
                            var _i = _x / SCRIBBLE_CYCLE_TEXTURE_WIDTH;
                            
                            var _indexA = _arrayLength*_i;
                            var _frac   = frac(_indexA);
                                _indexA = floor(_indexA);
                            var _indexB = (1 + _indexA) mod _arrayLength;
                            
                            draw_sprite_ext(scribble_fallback_dot, 0,
                                            _x, __index,
                                            1, 1, 0,
                                            __scribble_merge_color_oklab(_array[_indexA], _array[_indexB], _frac), 1);
                            ++_x;
                        }
                    }
                }
                else
                {
                    var _x = 0;
                    repeat(SCRIBBLE_CYCLE_TEXTURE_WIDTH)
                    {
                        draw_sprite_ext(scribble_fallback_dot, 0,
                                        _x, __index,
                                        1, 1, 0,
                                        _array[floor(_arrayLength * _x / SCRIBBLE_CYCLE_TEXTURE_WIDTH)], 1);
                        ++_x;
                    }
                }
            }
        }
        else
        {
            var _oldFilter = gpu_get_tex_filter();
            gpu_set_blendmode(__smooth);
            draw_sprite_stretched(__data, __image, 0, __index, SCRIBBLE_CYCLE_TEXTURE_WIDTH, 1);
            gpu_set_blendmode(_oldFilter);
        }
        
        gpu_set_blendmode(bm_normal);
    }
}