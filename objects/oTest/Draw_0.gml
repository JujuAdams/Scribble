var _string = "";
_string += Concat("Test Mode=", mode, "\n");
_string += Concat("Budget=", ScribbletGetBudget(), "us, used=", ScribbletGetBudgetUsed(), "us\n");
_string += Concat("Draw Count=", floor(stressCount), ", fps=", fps, ", fps_real (smoothed)=", floor(fpsRealSmoothed), "\n");
_string += Concat("Box=", width, " x ", height, ", font scale=", fontScale, "\n");

if (showHelp)
{
    _string += "\n";
    _string += "\n";
    _string += Concat("Scribblet ", __SCRIBBLET_VERSION, " Tester\n");
    _string += "\n";
    _string += "F1 = toggle this window\n";
    _string += "1-7 = change test mode\n";
    _string += "up/down = increase/decrease draw count\n";
    _string += "enter = change draw count to match 60FPS (roughly)\n";
    _string += "space = use native drawing\n";
    _string += "\n";
    _string += "left click = change bounding box (smooth)\n";
    _string += "ctrl+arrow keys = change bounding box (1px)\n";
    _string += "right click = move text\n";
    _string += "Q/A = increase/decrease font scale\n";
    _string += "shift+arrow keys = change alignment\n";
}

draw_rectangle(x, y, x + width, y + height, true);

var _limitWidth = max(10, width);
switch(mode)
{
    case 1:
        repeat(stressCount)
        {
            ScribbletDrawNative(x, y, testString, un, un, hAlign, vAlign, font, fontScale);
        }
    break;
    
    case 2:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidth(testString, hAlign, vAlign, font, fontScale),
                                 y + ScribbletHeight(testString, hAlign, vAlign, font, fontScale),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDraw(x, y, testString, un, un, hAlign, vAlign, font, fontScale);
        }
    break;
    
    case 3:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidthShrink(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 y + ScribbletHeightShrink(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDrawShrink(x, y, testString, un, un, hAlign, vAlign, font, fontScale, _limitWidth, height);
        }
    break;
    
    case 4:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidthFit(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 y + ScribbletHeightFit(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDrawFit(x, y, testString, un, un, hAlign, vAlign, font, fontScale, _limitWidth, height);
        }
    break;
    
    case 5:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidthExt(testString, hAlign, vAlign, font, fontScale),
                                 y + ScribbletHeightExt(testString, hAlign, vAlign, font, fontScale),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDrawExt(x, y, testStringColor, un, un, hAlign, vAlign, font, fontScale);
        }
    break;
    
    case 6:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidthExtShrink(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 y + ScribbletHeightExtShrink(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDrawExtShrink(x, y, testStringColor, un, un, hAlign, vAlign, font, fontScale, _limitWidth, height);
        }
    break;
    
    case 7:
        repeat(stressCount)
        {
            draw_rectangle_color(x, y,
                                 x + ScribbletWidthExtFit(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 y + ScribbletHeightExtFit(testString, hAlign, vAlign, font, fontScale, _limitWidth, height),
                                 c_lime, c_lime, c_lime, c_lime, true);
            ScribbletDrawExtFit(x, y, testStringColor, un, un, hAlign, vAlign, font, fontScale, _limitWidth, height);
        }
    break;
}

draw_set_colour(c_white);
draw_set_alpha(0.8);
draw_rectangle(10, 10, string_width(_string) + 30, string_height(_string) + 30, false);
draw_set_colour(c_black);
draw_set_alpha(1);
draw_text(20, 20, _string);
draw_set_colour(c_white);











