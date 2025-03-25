// Feather disable all

function __scribble_parse_sound_array_string(_string)
{
    static _system  = __scribble_initialize();
    var _sound_lookup_func = _system.__sound_lookup_func;
    
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
        
        var _i = array_length(_sound_array)-1;
        repeat(array_length(_sound_array))
        {
            var _sound = _sound_lookup_func(_sound_array[_i]);
            if (audio_exists(_sound))
            {
                _sound_array[_i] = _sound;
            }
            else
            {
                array_delete(_sound_array, _i, 1);
            }
            
            --_i;
        }
        
        return _sound_array;
    }
    else
    {
        return _sound_lookup_func(_string);
    }
}