// Feather disable all

function __scribble_parse_sound_array_string(_string)
{
    static _system  = __scribble_initialize();
    static _external_sound_map = _system.__external_sound_map;
    
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
            var _sound_name = _sound_array[_i];
            
            var _sound = _external_sound_map[? _sound_name] ?? asset_get_index(_sound_name);
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
        return asset_get_index(_string);
    }
}