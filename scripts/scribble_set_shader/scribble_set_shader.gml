/// Forces Scribble to render using a specific shader
/// 
/// @param shader   Shader to use
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

global.scribble_state_force_shader = argument0;