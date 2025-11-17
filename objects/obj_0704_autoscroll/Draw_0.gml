scribble(text).clip().max_size(200, 200).scroll_auto().draw(10, 10);
scribble(string_replace_all(text, "\n", " ")).clip().max_size(200, 200).pan_auto(4, 0).draw(220, 10);