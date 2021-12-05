/// @param character  The character to delay after. Can either be a string or a UTF-8 character code
/// @param delay      Delay time in milliseconds

function scribble_typewriter_add_character_delay(_character, _delay)
{
    if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> to use per-character delay");
    
    var _char_1 = _character;
    var _char_2 = 0;
    
    if (is_string(_character))
    {
        _char_1 = ord(string_char_at(_character, 1));
        if (string_length(_character) >= 2) _char_2 = ord(string_char_at(_character, 2));
    }
    
    global.__scribble_character_delay = true;
    global.__scribble_character_delay_map[? _char_1 | (_char_2 << 32)] = _delay;
}