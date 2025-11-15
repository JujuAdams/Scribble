scribble("[c_coquelicot]coquelicot[/c] [grad,c_banana]white").draw(x, y);
scribble("grey").color(c_grey).draw(x, y + 30);
scribble("coquelicot via .color()").color("c_coquelicot").draw(x, y + 60);
scribble("[#ff3800]#ff3800[/c] white").draw(x, y + 90);
scribble("[d#" + string(0x0038FF) + "]d#ff3800[/c] white").draw(x, y + 120);
scribble("change [c_red]red[/c] change").color(make_color_hsv((current_time/10) mod 256, 255, 255)).draw(x, y + 150);
scribble("Press space to cycle this [c_banana]colour[/c] (colour=" + string(scribble_color_get("c_banana")) + ")").draw(x, y + 180);