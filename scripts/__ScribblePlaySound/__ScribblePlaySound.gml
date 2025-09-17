// Feather disable all

/// @param asset
/// @param gain
/// @param pitch

function __ScribblePlaySound(_asset, _gain, _pitch)
{
    static _soundWhitelistMap = __ScribbleSystem().__state.__soundWhitelistMap;
    static _externalSoundMap  = __ScribbleSystem().__externalSoundMap;
    
    if (is_string(_asset))
    {
        _asset = _externalSoundMap[? _asset] ?? asset_get_index(_asset);
    }
    
    if (not audio_exists(_asset))
    {
        return -1;
    }
    
    if ((not SCRIBBLE_USE_SOUND_WHITELIST) || (_soundWhitelistMap[? _asset] ?? false))
    {
        var _func = SCRIBBLE_AUDIO_PLAY_FUNCTION;
        if (is_callable(_func))
        {
            return _func(_asset, 1, false, _gain, 0, _pitch);
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -1;
    }
}