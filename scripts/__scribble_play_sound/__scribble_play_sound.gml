// Feather disable all

/// @param asset
/// @param gain
/// @param pitch

function __scribble_play_sound(_asset, _gain, _pitch)
{
    static _sound_whitelist_map = __scribble_initialize().__state.__sound_whitelist_map;
    static _external_sound_map  = __scribble_initialize().__external_sound_map;
    
    if (is_string(_asset))
    {
        _asset = _external_sound_map[? _asset] ?? asset_get_index(_asset);
    }
    
    if (not audio_exists(_asset))
    {
        return -1;
    }
    
    if ((not SCRIBBLE_USE_SOUND_WHITELIST) || (_sound_whitelist_map[? _asset] ?? false))
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