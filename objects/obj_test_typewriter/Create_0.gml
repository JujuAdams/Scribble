typist = scribble_typist();
typist.in(0.2, 10);
typist.ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);

test_string = "here's some cute text! [spr_large_coin]";

scribble_font_set_default("fnt_noto_arabic");
test_string = "هل يمكنك رؤية هذا الذي يعد تنازليًا؟";