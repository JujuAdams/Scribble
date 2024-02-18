enum __SCRIBBLE_LAYOUT
{
    __FREE,
    __GUIDE,
    __SCALE,
    __WRAP,
    __WRAP_SPLIT,
    __FIT,
}

enum __SCRIBBLE_GLYPH
{
    __CHARACTER,            // 0
                   
    __UNICODE,              // 1 \
    __BIDI,                 // 2  |
                            //    |
    __X_OFFSET,             // 3  |
    __Y_OFFSET,             // 4  |
    __WIDTH,                // 5  |
    __HEIGHT,               // 6  |
    __FONT_HEIGHT,          // 7  |
    __SEPARATION,           // 8  |
    __LEFT_OFFSET,          // 9  | This group of enums must not change order or be split
                            //    |
    __MATERIAL,             //10  |
    __U0,                   //11  | Be careful of ordering!
    __U1,                   //12  | scribble_font_bake_effects() relies on this
    __V0,                   //13  |
    __V1,                   //14  |
                            //    |
    __LAST_USED,            //15 /
    
    __SIZE                  //16
}

enum SCRIBBLE_EASE
{
    NONE,     // 0
    LINEAR,   // 1
    QUAD,     // 2
    CUBIC,    // 3
    QUART,    // 4
    QUINT,    // 5
    SINE,     // 6
    EXPO,     // 7
    CIRC,     // 8
    BACK,     // 9
    ELASTIC,  //10
    BOUNCE,   //11
    CUSTOM_1, //12
    CUSTOM_2, //13
    CUSTOM_3, //14
    __SIZE    //15
}

enum __SCRIBBLE_GLYPH_LAYOUT
{
    __UNICODE, // 0
    __LEFT,    // 1
    __TOP,     // 2
    __RIGHT,   // 3
    __BOTTOM,  // 4
    __SIZE,    // 5
}

enum __SCRIBBLE_ANIM
{
    __WAVE_SIZE,        // 0
    __WAVE_FREQ,        // 1
    __WAVE_SPEED,       // 2
    __SHAKE_SIZE,       // 3
    __SHAKE_SPEED,      // 4
    __RAINBOW_WEIGHT,   // 5
    __RAINBOW_SPEED,    // 6
    __WOBBLE_ANGLE,     // 7
    __WOBBLE_FREQ,      // 8
    __PULSE_SCALE,      // 9
    __PULSE_SPEED,      //10
    __WHEEL_SIZE,       //11
    __WHEEL_FREQ,       //12
    __WHEEL_SPEED,      //13
    __CYCLE_SPEED,      //14
    __CYCLE_FREQUENCY,  //15
    __JITTER_SCALE,     //16
    __JITTER_SPEED,     //17
    __SLANT_GRADIENT,   //18
    __SIZE,             //19
}

enum __SCRIBBLE_COMMAND_TAG
{
    ENABLE, //0  Full operation
    HIDE,   //1  Command tags do nothing but are hidden
    IGNORE, //2  Command tags do nothing and are shown in plaintext
}