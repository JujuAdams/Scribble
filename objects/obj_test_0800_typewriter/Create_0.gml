typist = scribble_typist_legacy();
typist.TypeIn(0.2, 10);
typist.TypeEase(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
typist.TypeCharacterDelayAdd(".", 500);

test_string = "here's so[pause]me ... cute[delay] text! [spr_large_coin]";

//scribble_font_set_default("spr_msdf_notoarabic"); //spr_msdf_notoarabic
//test_string = "[scale,2]هل يمكنك رؤية هذا الذي يعد تنازليًا؟";