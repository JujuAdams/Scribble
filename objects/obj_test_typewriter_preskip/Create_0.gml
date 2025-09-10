element = scribble_unique("this is the first test string");
element.in(0.2, 10);
element.ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);
element.skip();