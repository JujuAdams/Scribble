// Feather disable all

function __scribble_parse_sound_array_string(_string)
{
    var _sound_array_string = string_trim_start(_string);
    
    if (string_char_at(_sound_array_string, 1) == "[")
    {
        try
        {
            var _sound_array = json_parse(_sound_array_string);
        }
        catch(_error)
        {
            __scribble_trace(_string);
            __scribble_error("Could not parse sound array string (please check the debug log)");
        }
        
        var _i = 0;
        repeat(array_length(_sound_array))
        {
            _sound_array[_i] = asset_get_index(_sound_array[_i]);
            ++_i;
        }
        
        return _sound_array;
    }
    else
    {
        return asset_get_index(_string);
    }
}