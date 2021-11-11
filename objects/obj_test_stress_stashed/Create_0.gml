test_text = "[fa_middle][fa_center]";
repeat(1000) test_text += chr(choose(irandom_range(32, 90), irandom_range(94, 126)));
element = scribble(test_text).wrap(700);
element.build(true);

smoothed_time_scribble = 100;
smoothed_time_gm = 100;