scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

element = scribble("Lorem ipsum dolor sit amet, [speed,2]consectetur adipiscing elit,[speed,0.5] sed do eiusmod[/speed] tempor incididunt [speed,2]ut labore et dolore[speed,0.5] magna aliqua.");
element.wrap(900);
element.typewriter_in(0.2, 10);