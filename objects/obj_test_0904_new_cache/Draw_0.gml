draw_set_font(scribble_fallback_font);
draw_text(10, 10, "__SCRIBBLE_VERBOSE_GC = " + string(__SCRIBBLE_VERBOSE_GC) + "\nPress left/right to change value");

scribble(value).draw(10, 60);