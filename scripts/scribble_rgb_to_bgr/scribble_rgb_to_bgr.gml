/// Convertes an RGB colour code (the industry standard) to GameMaker's native BGR format

function scribble_rgb_to_bgr(_rgb)
{
    return make_colour_rgb(colour_get_blue(_rgb), colour_get_green(_rgb), colour_get_red(_rgb));
}