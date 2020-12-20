if (keyboard_check_pressed(vk_enter)) scribble_flush_everything();
if (keyboard_check_pressed(ord("F"))) element.flush();
if (keyboard_check_pressed(ord("R"))) element = scribble("Here's some test text");