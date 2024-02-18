glyph = (glyph + 1) mod string_length(source);
if (glyph == 0) show_debug_message("loop!");
alarm[0] = alarm_delay;