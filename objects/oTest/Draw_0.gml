draw_set_font(fntTest);

draw_text(0, 0, Concat("mode=", mode));
draw_text(0, 30, Concat(floor(stressCount), "/", fps));
draw_text(0, 90, string(width) + " x " + string(height));
draw_line(width + x, 0, width + x, room_height);
draw_line(0, height + y, room_width, height + y);

var _limitWidth = max(10, width);

switch(mode)
{
    case 1:
        repeat(stressCount)
        {
            ScribbleFastRaw(x, y, testString, _limitWidth, height);
        }
    break;
    
    case 2:
        repeat(stressCount)
        {
            ScribbleFastTest(x, y, testString, un, un, un, un, fntTest, un, _limitWidth, height);
        }
    break;
    
    case 3:
        repeat(stressCount)
        {
            ScribbleFastB(x, y, testString, un, un, un, un, fntTest, un, _limitWidth, height);
        }
    break;
    
    case 4:
        repeat(stressCount)
        {
            ScribbleFastC(x, y, "a[sTestShape][c_red]c[/c][sTestShape]e", un, un, un, un, un, un);
        }
    break;
}