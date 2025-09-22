scribble("[c_coquelicot]Test[/c] white").draw(x, y);
scribble("Test grey").color(c_grey).draw(x, y + 30);
scribble("Test \"coquelicot\" via .color()").color("c_coquelicot").draw(x, y + 60);
scribble("[#ff3800]Test[/c] white").draw(x, y + 90);
scribble("[d#" + string(0x0038FF) + "]Test[/c] white").draw(x, y + 120);
scribble("changing [c_red]colour[/c] in a string").color(make_color_hsv((current_time/10) mod 256, 255, 255)).draw(x, y + 150);
scribble("[c_banana]Press space to cycle this colour[/c] (colour=" + string(scribble_color_get("c_banana")) + ")").draw(x, y + 180);