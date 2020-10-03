/// Sets whether command tags should be interpreted or ignored
/// 
/// @param state   Whether to ignore command tags and to write Scribble strings out literally
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

function scribble_set_ignore_command_tags(_state)
{
    global.scribble_state_ignore_commands = _state;
}