if (keyboard_check_pressed(vk_space)) toggle = !toggle;
if (keyboard_check_pressed(ord("F"))) scribble_flush_everything();
if (keyboard_check_pressed(ord("G"))) gc_collect();