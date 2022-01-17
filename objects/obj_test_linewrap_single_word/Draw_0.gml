scribble("[scale,2]Antidisestablishmentarianism")
.wrap(limit - x)
.draw(x, y);

draw_line(limit, 0, limit, room_height);

draw_set_font(scribble_fallback_font);
draw_text(0, 0, limit);