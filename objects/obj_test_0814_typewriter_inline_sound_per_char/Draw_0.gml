if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER)
{
    draw_text(10, 10, "SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> for this test case");
    return;
}

scribble("[typistSoundPerChar,snd_switch,2,2.2, ]abc def ghi jkl mno pqr stu vwx yz.").draw(x, y, typist);

if (typist.get_state() == 1.0) draw_circle(10, 10, 10, false);