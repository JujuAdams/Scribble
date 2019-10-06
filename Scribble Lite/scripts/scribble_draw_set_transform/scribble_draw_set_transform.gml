/// Sets Scribble's scaling and rotation state.
/// 
/// 
/// @param xscale   The x scale of the text element.
/// @param yscale   The y scale of the text element.
/// @param angle    The rotation angle of the text element.
/// 
/// 
/// The transform operates relative to the origin of the text element i.e. rotation will happen using the origin
/// as the centre of rotation. scribble_set_box_alignment() can be used to draw the text offset from the origin.
/// 
/// This script "sets state". All text drawn with scribble_draw() will use these settings until they're overwritten,
/// either by calling this script again or by calling scribble_draw_reset() / scribble_draw_set_state().

global.scribble_state_xscale = argument0;
global.scribble_state_yscale = argument1;
global.scribble_state_angle  = argument2;