// Feather disable all

/// @param sound
/// @param gain
/// @param pitch

function __scribble_play_sound(_sound, _gain, _pitch)
{
    static _sound_whitelist_map = __scribble_initialize().__state.__sound_whitelist_map;
    
    if ((not SCRIBBLE_USE_SOUND_WHITELIST) || (_sound_whitelist_map[? _sound] ?? false))
    {
        return audio_play_sound(_sound, 1, false, _gain, 0, _pitch);
    }
    else
    {
        return -1;
    }
}