draw_set_font(fntTest);

draw_text(0, 0, Concat("test mode=", mode));
draw_text(0, 60, Concat(floor(stressCount), "/", fps));
draw_text(0, 90, string(width) + " x " + string(height));
draw_line(x, y, x + width, y);
draw_line(x, y, x, y + height);
draw_line(width + x, 0, width + x, room_height);
draw_line(0, height + y, room_width, height + y);

var _limitWidth = max(10, width);

switch(mode)
{
    case 1:
        repeat(stressCount)
        {
            ScribbletDrawNative(x, y, testString, un, un, hAlign, vAlign, font, un);
        }
    break;
    
    case 2:
        repeat(stressCount)
        {
            ScribbletDraw(x, y, testString, un, un, hAlign, vAlign, font, un);
        }
    break;
    
    case 3:
        repeat(stressCount)
        {
            ScribbletDrawShrink(x, y, testString, un, un, hAlign, vAlign, font, un, _limitWidth, height);
        }
    break;
    
    case 4:
        repeat(stressCount)
        {
            ScribbletDrawFit(x, y, testString, un, un, hAlign, vAlign, font, un, _limitWidth, height);
        }
    break;
    
    case 5:
        repeat(stressCount)
        {
            ScribbletDrawExt(x, y, testString, un, un, hAlign, vAlign, font, un);
        }
    break;
    
    case 6:
        repeat(stressCount)
        {
            ScribbletDrawExtShrink(x, y, testStringColor, un, un, hAlign, vAlign, font, un, _limitWidth, height);
        }
    break;
    
    case 7:
        repeat(stressCount)
        {
            ScribbletDrawExtFit(x, y, testStringColor, un, un, hAlign, vAlign, font, un, _limitWidth, height);
        }
    break;
}

draw_text(0, 30, Concat(ScribbletGetBudget(), "us, used=", ScribbletGetBudgetUsed(), "us"));