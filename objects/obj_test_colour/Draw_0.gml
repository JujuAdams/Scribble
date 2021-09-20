scribble("[c_coquelicot]Test[/c] white").draw(x, y);
scribble("Test red").blend("c_coquelicot", 1.0).draw(x, y + 30);
scribble("Test red").starting_format(undefined, "c_coquelicot").draw(x, y + 60);
scribble("[#ff3800]Test[/c] white").draw(x, y + 90);
scribble("[d#" + string(0x0038FF) + "]Test[/c] white").draw(x, y + 120);