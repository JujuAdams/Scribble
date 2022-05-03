scribble("[c_coquelicot]Test[/c] white").draw(x, y);
scribble("Test grey").blend(c_grey, 1.0).draw(x, y + 30);
scribble("Test coquelicot via blend").blend("c_coquelicot", 1.0).draw(x, y + 60);
scribble("Test coquelicot via starting format").starting_format(undefined, "c_coquelicot").draw(x, y + 90);
scribble("[#ff3800]Test[/c] white").draw(x, y + 120);
scribble("[d#" + string(0x0038FF) + "]Test[/c] white").draw(x, y + 150);