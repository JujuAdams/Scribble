// Feather disable all

function __ScribbleGetImageSpeed(_sprite)
{
    return (sprite_get_speed_type(_sprite) == spritespeed_framespergameframe)? sprite_get_speed(_sprite) : (sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps));
}