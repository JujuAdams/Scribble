typist = scribble_typist();
typist.in(0.2, 10);
typist.ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
typist.character_delay_add(".", 500);

test_string = "here's so[pause]me ... cute[delay] text! [spr_large_coin]";

//scribble_font_set_default("spr_msdf_notoarabic"); //spr_msdf_notoarabic
//test_string = "[scale,2]هل يمكنك رؤية هذا الذي يعد تنازليًا؟";