var _demo_string = "When flowing[nbsp]water meets with obstacles on its path, a[nbsp]blockage[nbsp]in[nbsp]its[nbsp]journey, it[nbsp]pauses. It increases in volume and strength, filling up in front of the obstacle and eventually spilling past it.";

scribble(_demo_string).wrap(mouse_x - 10).draw(10, 10);

draw_line(mouse_x, 0, mouse_x, room_height);