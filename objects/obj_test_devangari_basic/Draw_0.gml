draw_text(10, 10, index);
scribble(testVectorArray[index].unicode).draw(10, 50);

draw_set_font(fnt_krutidev);
draw_text(10, 100, UnicodeToKrutidev(testVectorArray[index].unicode));

draw_set_font(-1);
draw_text(10, 150, UnicodeToKrutidev(testVectorArray[index].unicode));
