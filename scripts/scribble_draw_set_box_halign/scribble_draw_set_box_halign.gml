/// Sets Scribble's box horizontal alignment state
/// 
/// @param boxHAlign   Horizontal alignment of the text element relative to the text element's origin. Accepts fa_left, fa_right, and fa_center
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until they're overwritten, either by
/// calling this script again or by calling scribble_draw_reset() or scribble_draw_set_state().

global.scribble_state_box_halign = argument0;