/// Sets Scribble's MSDF anti-aliasing property
/// 
/// @param thickness   Thickness of the anti-aliased border
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

var _thickness = argument0;

global.scribble_state_msdf_aa = _thickness;