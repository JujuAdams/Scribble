// Feather disable all

function __ScribbleParseSoundArrayString(_string)
{
    static _system  = __ScribbleSystem();
    static _externalSoundMap = _system.__externalSoundMap;
    
    var _soundArrayString = string_trim_start(_string);
    
    if (string_char_at(_soundArrayString, 1) == "[")
    {
        try
        {
            var _soundArray = json_parse(_soundArrayString);
        }
        catch(_error)
        {
            __ScribbleTrace(_string);
            __ScribbleError("Could not parse sound array string (please check the debug log)");
        }
        
        var _i = array_length(_soundArray)-1;
        repeat(array_length(_soundArray))
        {
            var _soundName = _soundArray[_i];
            
            var _sound = _externalSoundMap[? _soundName] ?? asset_get_index(_soundName);
            if (audio_exists(_sound))
            {
                _soundArray[_i] = _sound;
            }
            else
            {
                array_delete(_soundArray, _i, 1);
            }
            
            --_i;
        }
        
        return _soundArray;
    }
    else
    {
        return asset_get_index(_string);
    }
}