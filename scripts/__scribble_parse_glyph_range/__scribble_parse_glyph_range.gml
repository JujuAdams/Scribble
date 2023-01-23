/// @param value
/// @param [fontName]
/// @param [sort=false]

function __scribble_parse_glyph_range_root(_value, _font_name = undefined, _sort = false)
{
    var _output_dict  = {};
    var _output_array = [];
    
    if (is_string(_value))
    {
        __scribble_parse_glyph_range_string(_output_dict, _output_array, _value);
    }
    else if (is_numeric(_value))
    {
        if (_value > 0)
        {
            array_push(_output_array, _value);
        }
        else if (_value == all)
        {
            if (_font_name == undefined)
            {
                __scribble_error("The keyword <all> is not supported for this function");
            }
            
            var _font_data = __scribble_get_font_data(_font_name);
            if (!is_struct(_font_data))
            {
                __scribble_error("Font \"", _font_name, "\" was not recognised");
            }
            
            var _keys_array = ds_map_keys_to_array(_font_data.__glyphs_map);
            var _i = 0;
            repeat(array_length(_keys_array))
            {
                var _key = _keys_array[_i];
                if (!variable_struct_exists(_output_dict, _key))
                {
                    _output_dict[$ _key] = true;
                    array_push(_output_array, _key);
                }
                
                ++_i;
            }
        }
        else if (_value == 0)
        {
            //Skip
        }
        else
        {
            __scribble_error("Glyph indices should be positive integers");
        }
    }
    else if (is_array(_value))
    {
        if (array_length(_value) == 2)
        {
            __scribble_parse_glyph_range_range(_output_dict, _output_array, _value);
        }
        else
        {
            __scribble_parse_glyph_range_array(_output_dict, _output_array, _value);
        }
    }
    else
    {
        __scribble_error("Glyph ranges must be a number, the keyword <all>, a string, or an array (datatype was ", typeof(_value), ")");
    }
    
    if (_sort) array_sort(_output_array, true);
    return _output_array;
}

function __scribble_parse_glyph_range_string(_output_dict, _output_array, _string)
{
    var _size = string_length(_string);
    var _i = 1;
    repeat(_size)
    {
        var _value = string_char_at(_string, _i);
        if (!variable_struct_exists(_output_dict, _value))
        {
            _output_dict[$ _value] = true;
            array_push(_output_array, ord(_value));
        }
        
        ++_i;
    }
}

function __scribble_parse_glyph_range_array(_output_dict, _output_array, _array)
{
    var _i = 0;
    repeat(array_length(_array))
    {
        var _value = _array[_i];
        
        if (is_string(_value))
        {
            __scribble_parse_glyph_range_string(_output_dict, _output_array, _value);
        }
        else if (is_numeric(_value))
        {
            if (_value > 0)
            {
                array_push(_output_array, _value);
            }
            else if (_value == all)
            {
                __scribble_error("Cannot use keyword <all> in nested arrays");
            }
            else if (_value == 0)
            {
                //Skip
            }
            else
            {
                __scribble_error("Glyph indices should be positive integers");
            }
        }
        else if (is_array(_value))
        {
            if (array_length(_value) == 2)
            {
                __scribble_parse_glyph_range_range(_output_dict, _output_array, _value);
            }
            else
            {
                __scribble_error("Nested arrays must be ranges i.e. they should have length 2 (length=", array_length(_value), ")");
            }
        }
        else
        {
            __scribble_error("Glyph ranges must be a number, the keyword <all>, a string, or an array (datatype was ", typeof(_value), ")");
        }
        
        ++_i;
    }
}

function __scribble_parse_glyph_range_range(_output_dict, _output_array, _array)
{
    var _min = _array[0];
    var _max = _array[1];
    
    if (!is_numeric(_min))
    {
        __scribble_error("Minimum glyph index for range must be a number (datatype=", typeof(_min), ")");
    }
    
    if (!is_numeric(_max))
    {
        __scribble_error("Maximum glyph index for range must be a number (datatype=", typeof(_max), ")");
    }
    
    if (_min <= 0)
    {
        __scribble_error("Minimum glyph index for range must be larger than 0 (min=", _min, ")");
    }
    
    if (_max <= 0)
    {
        __scribble_error("Maximum glyph index for range must be larger than 0 (max=", _max, ")");
    }
    
    if (_max < _min)
    {
        __scribble_error("Minimum glyph index for range must be smaller than maximum glyph index (min=", _min, ", max=", _max, ")");
    }
    
    if (1 + _max - _min > 2000)
    {
        __scribble_trace("Warning! Very large glyph range specified (min=", _min, ", max=", _max, ")");
    }
    
    var _i = _min;
    repeat(1 + _max - _min)
    {
        if (!variable_struct_exists(_output_dict, _i))
        {
            _output_dict[$ _i] = true;
            array_push(_output_array, _i);
        }
        
        ++_i;
    }
}