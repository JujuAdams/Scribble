/// Creates a collection of colour names that map to 24-bit BGR colours
/// Use scribble_rgb_to_bgr() to convert from industry standard RGB colour codes to GM's native BGR format
///
/// N.B. That this script is executed on boot. You never need to run this script yourself!

//Create a colours map if we don't already have one
//We have to do this in case another system function is executed before this one
if (!variable_global_exists("__scribble_colours")) global.__scribble_colours = ds_map_create();

//Duplicate GM's native colour constants
global.__scribble_colours[? "c_aqua"   ] = c_aqua;
global.__scribble_colours[? "c_black"  ] = c_black;
global.__scribble_colours[? "c_blue"   ] = c_blue;
global.__scribble_colours[? "c_dkgray" ] = c_dkgray;
global.__scribble_colours[? "c_dkgrey" ] = c_dkgray;
global.__scribble_colours[? "c_fuchsia"] = c_fuchsia;
global.__scribble_colours[? "c_gray"   ] = c_gray;
global.__scribble_colours[? "c_green"  ] = c_green;
global.__scribble_colours[? "c_grey"   ] = c_gray;
global.__scribble_colours[? "c_lime"   ] = c_lime;
global.__scribble_colours[? "c_ltgray" ] = c_ltgray;
global.__scribble_colours[? "c_ltgrey" ] = c_ltgray;
global.__scribble_colours[? "c_maroon" ] = c_maroon;
global.__scribble_colours[? "c_navy"   ] = c_navy;
global.__scribble_colours[? "c_olive"  ] = c_olive;
global.__scribble_colours[? "c_orange" ] = c_orange;
global.__scribble_colours[? "c_purple" ] = c_purple;
global.__scribble_colours[? "c_red"    ] = c_red;
global.__scribble_colours[? "c_silver" ] = c_silver;
global.__scribble_colours[? "c_teal"   ] = c_teal;
global.__scribble_colours[? "c_white"  ] = c_white;
global.__scribble_colours[? "c_yellow" ] = c_yellow;

//Here are some example colours
global.__scribble_colours[? "c_coquelicot"] = scribble_rgb_to_bgr(0xff3800);
global.__scribble_colours[? "c_smaragdine"] = scribble_rgb_to_bgr(0x50c875);
global.__scribble_colours[? "c_xanadu"    ] = scribble_rgb_to_bgr(0x738678);
global.__scribble_colours[? "c_amaranth"  ] = scribble_rgb_to_bgr(0xe52b50);