/// @param character   The character to delay after. Can either be a string or a UTF-8 character code
/// @param delay       Delay time in milliseconds

function scribble_typewriter_add_character_delay(_character, _delay)
{
    if (is_string(_character)) _character = ord(_character);
    global.__scribble_character_delay = true;
    global.__scribble_character_delay_map[? _character] = _delay;
}