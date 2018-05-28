/// @description SCRIBBLE internal definitions

#macro SCRIBBLE_FONT_CHAR_SIZE 1+SCRIBBLE_FONT_CHAR_MAX-SCRIBBLE_FONT_CHAR_MIN

enum E_SCRIBBLE_FADE { OFF, ON, PER_CHAR, PER_LINE, PER_WORD }
enum E_SCRIBBLE_STATE { INTRO, VISIBLE, OUTRO, INVISIBLE }
enum E_SCRIBBLE { L, T, R, B, W, H, X, Y, KERN_W, KERN_H }

#macro LOREM_IPSUM "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
#macro LOREM_IPSUM_FANCY "[rainbow]Lorem ipsum [shake]dolor[/rainbow] sit amet[/shake], [wave]consectetur [rainbow]adipiscing[/rainbow] elit,[] sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
