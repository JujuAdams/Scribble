scribble("[c_coquelicot]Test[/c] 1").draw(x, y);
scribble("Test 2").blend("c_coquelicot", 1.0).draw(x, y + 30);
scribble("Test 3").starting_format(undefined, "c_coquelicot").draw(x, y + 60);
scribble("[#ff3800]Test[/c] 4").draw(x, y + 90);
scribble("[d#" + string(0x0038FF) + "]Test[/c] 5").draw(x, y + 120);