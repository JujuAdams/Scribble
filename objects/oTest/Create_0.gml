__scribble_init();

test_string = "[rainbow]abcdef[] ABCDEF##[wave][c_orange]0123456789[] .,<>\"'&[sCoin|$0][sCoin|$1][sCoin|$0][sCoin|1][shake][rainbow]!?[]\n\n[link|0]the quick[/link] [link|1]brown fox[/link] [wave]jumps[] over the lazy dog\n\n[fa_right]THE [$FF4499][shake]QUICK [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER []THE LAZY DOG.";

test_json = scribble_create( test_string, 200, "sSpriteFont", fa_center, make_colour_hsv( 35, 140, 210 ) );
scribble_set_box_alignment( test_json, fa_center, fa_middle );
scribble_set_shake( test_json, 4 );
scribble_set_wave( test_json, 4 );
scribble_set_rainbow( test_json, 0.4 );
scribble_set_hyperlink( test_json, c_lime, 0.2, 0.2 );
scribble_set_sprite_slot_speed( test_json, 0, 0.1 );
scribble_set_sprite_slot_image( test_json, 1, 1   );
scribble_set_sprite_slot_speed( test_json, 1, 0.2 );