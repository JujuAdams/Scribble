/// Sets Scribble's scaling and rotation state
/// 
/// @param xscale   x-scale of the text element
/// @param yscale   y-scale of the text element
/// @param angle    Rotation angle of the text element
/// 
/// The transform operates relative to the origin of the text element i.e. rotation will happen using the origin
/// as the centre of rotation. scribble_set_box_alignment() can be used to draw the text offset from the origin.
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

function scribble_set_transform()
{
	global.scribble_state_xscale = argument0;
	global.scribble_state_yscale = argument1;
	global.scribble_state_angle  = argument2;
}