element = scribble("here's[delay,1000] some[delay,1000] cute[delay,1000] text! [spr_large_coin]");
element.typewriter_in(0.2, 10);
element.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);

show_debug_message(element.get_ltrb_array());