//Start up Scribble and load fonts automatically from Included Files
scribble_init("Fonts", "fTestA", true);

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 3);

//Add some colour definitions that we'll use in the demo string
scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

scribble_autotype_add_event("testEvent", example_event);



//Define a demo string for use in the Draw event
var _demo_string  = "[rainbow]abcdef[] ABCDEF[testEvent]##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][shake][rainbow]!?[]\n";
    _demo_string += "[fa_centre][sCoin][sCoin][sCoin][sCoin]\n";
    _demo_string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.[testEvent][testEvent] [testEvent]";

element = scribble_draw(x - 150, y - 80, _demo_string);
scribble_autotype_set(element, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.5, 0, true);