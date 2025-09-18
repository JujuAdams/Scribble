// Feather disable all

maxWidth  = 150;
maxHeight = 100;

text = "";

var _i = ord("a");
repeat(26)
{
    repeat(15)
    {
        text += chr(_i);
    }
    
    text += "\n";
    ++_i;
}

text = string_copy(text, 1, string_length(text)-1);

element = scribble_unique(text)
          .clip()
          .max_size(maxWidth, maxHeight)
          .pause_on_overflow()
          .in(0.5);