var _t = mouse_x / room_width;

scribble("[c_coquelicot]Test[/c] white").flash(c_red, _t).draw(x, y);
scribble("Test grey").color(c_grey).flash(c_red, _t).draw(x, y + 30);
scribble("Test red").color("c_coquelicot", 1.0).flash(c_red, _t).draw(x, y + 60);
scribble("Test red").color("c_coquelicot").flash(c_red, _t).draw(x, y + 90);
scribble("[#ff3800]Test[/c] white").flash(c_red, _t).draw(x, y + 120);
scribble("[d#" + string(0x0038FF) + "]Test[/c] white").flash(c_red, _t).draw(x, y + 150);