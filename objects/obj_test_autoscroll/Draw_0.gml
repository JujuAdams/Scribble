scribble(text).clip().max_size(200, 200).scroll_auto_y().draw(10, 10);
scribble(string_replace_all(text, "\n", " ")).clip().max_size(200, 200).scroll_auto_x(4, 0).draw(220, 10);