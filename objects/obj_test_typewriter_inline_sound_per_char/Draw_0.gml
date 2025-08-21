scribble("[typistSoundPerChar,snd_switch,2,2.2, ]abc def ghi jkl mno pqr stu vwx yz.")
.allow_glyph_data_getter()
.draw(x, y, typist);

if (typist.get_state() == 1.0) draw_circle(10, 10, 10, false);