var _string = "Lorem ipsum dolor sit amet, [speed,2][c_red]consectetur adipiscing elit,[c_blue][speed,0.5] sed do eiusmod[/c][/speed] tempor incididunt [c_red][speed,2]ut labore et dolore[/c][/speed] magna aliqua.";
//var _string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
_string = _string + " " + _string + " " + _string;

element = scribble_unique(_string)
.max_size(500)
.layout_wrap()
.typist_options({ speed: 0.5, smoothness: 10 })
.typist_start();