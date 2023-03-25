test_string = 5*"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

frozen_element = scribble(string_upper(test_string)).wrap(450).starting_format("fnt_test_0", c_white);
frozen_element.build(true);
frozen_smoothed = 0;

unfrozen_element = scribble(string_lower(test_string)).wrap(450).starting_format("fnt_test_0", c_white);
unfrozen_element.build(false);
unfrozen_smoothed = 0;