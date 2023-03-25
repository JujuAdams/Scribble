draw_set_font(scribble_fallback_font);
draw_text(10, 10, "SCRIBBLE_FIX_ESCAPED_NEWLINES = " + string(SCRIBBLE_FIX_ESCAPED_NEWLINES));

scribble("[fa_middle][fa_center]Sphinx of black quartz\\nhear my vow").draw(room_width div 2, room_height div 2);