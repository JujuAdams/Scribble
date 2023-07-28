// Feather disable all
/// Converts an RGB colour code (the industry standard) to GameMaker's native BGR format
/// 
/// @param RGB   24-bit industry standard RGB colour integer

function scribble_rgb_to_bgr(_rgb)
{
    return (_rgb & 0xFF00FF00) | ((_rgb & 0x00FF0000) >> 16) | ((_rgb & 0x000000FF) << 16);
}
