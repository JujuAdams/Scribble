draw_set_font(fntTest);

draw_text(0, 0, Concat("mode=", mode, ", compile=", global.compile));
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
        draw_circle(x, y, 20, true);
        repeat(stressCount)
        {
            ScribbleFastC(x, y, testString, un, un, fa_right, fa_bottom, fntTestSDF, un, _limitWidth, height);
        }
    break;
}

ScribbleFontDrawState();