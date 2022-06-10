/// Creates a collection of colour names that map to 24-bit BGR colours
/// Use scribble_rgb_to_bgr() to convert from industry standard RGB colour codes to GM's native BGR format
///
/// N.B. That this script is executed on boot. You never need to run this script yourself!

global.__scribble_colours = {
    //Duplicate GM's native colour constants
    c_aqua:    c_aqua,
    c_black:   c_black,
    c_blue:    c_blue,
    c_dkgray:  c_dkgray,
    c_dkgrey:  c_dkgrey,
    c_fuchsia: c_fuchsia,
    c_gray:    c_gray,
    c_green:   c_green,
    c_gray:    c_gray,
    c_grey:    c_grey,
    c_lime:    c_lime,
    c_ltgray:  c_ltgray,
    c_ltgrey:  c_ltgrey,
    c_maroon:  c_maroon,
    c_navy:    c_navy,
    c_olive:   c_olive,
    c_orange:  c_orange,
    c_purple:  c_purple,
    c_red:     c_red,
    c_silver:  c_silver,
    c_teal:    c_teal,
    c_white:   c_white,
    c_yellow:  c_yellow,
    
    //Here are some example colours
    c_coquelicot: scribble_rgb_to_bgr(0xff3800),
    c_smaragdine: scribble_rgb_to_bgr(0x50c875),
    c_xanadu:     scribble_rgb_to_bgr(0x738678),
    c_amaranth:   scribble_rgb_to_bgr(0xe52b50),
}
