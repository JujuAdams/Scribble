## New

- [ ] Throw error when passing a text element into `.draw()`
- [ ] Ligatures
- [ ] Glyph pair kerning
- [ ] Lobanov wrapping
- [ ] Ignore certain characters for typewriter character sounds
- [ ] Command tag macros
- [ ] Method to set event function execution scope
- [ ] Function evaluation command tag
- [ ] Variable insertion command tag
- [ ] Scale-to-box
- [ ] Improve fit-to-box
- [ ] Faster stripped-back parser
- [ ] Justified text alignment
- [ ] Word index tracking
- [ ] Typewriter bounding box getter
- [ ] Text-for-current-page getter
- [x] Drop shadow baking shader
- [ ] Add `fa_justify` to documentation
- [ ] Default `.template()` to execute only on change
- [ ] Dual character delay
- [ ] Bezier curve debug draw

&nbsp;

## Text Formating

- [x] Reset formatting
- [x] Manual page break
- [x] Font setting/resetting
- [x] Non-breaking space tag
- [x] Named colours
- [x] Hexcode colours
- [x] Decimal colours
- [x] Sprite insertion (inc. image + speed control)
- [x] Surface insertion
- [x] Sound playback
- [x] Horizontal font alignment (inc. newlines when swapping alignment in the middle of a string)
- [x] Vertical font alignment
- [x] "Pin" horizontal alignment
- [x] Horizontal justification
- [ ] Typewriter events
- [ ] Typewriter delay, pause, delay, speed
- [x] Glyph scale and scale stacking
- [x] Glyph slant
- [x] Animated effects:
    - [x] Wave
    - [x] Shake
    - [x] Wobble
    - [x] Pulse
    - [x] Wheel
    - [x] Jitter
    - [x] Blink
    - [x] Rainbow
    - [x] Colour cycle

&nbsp;

## `scribble()` Methods

- [ ] Basics
    - [x] Starting format
    - [x] Starting alignment
    - [x] Blend
    - [x] Sprite insertion
    - [x] Sprite animation
    - [ ] Text reveal
- [ ] Shape, Wrapping, and Positioning
    - [x] Origin-setting
    - [x] Transform (pre + post?)
    - [ ] Wrapping inc. pagination and character wrap
    - [ ] Fit to box
    - [ ] Scale to box
    - [x] Line height setter
    - [ ] Bezier curve
- [ ] Pages
    - [ ] Setting/getting
- [ ] Getters
    - [x] Bounding box getter
    - [x] Width/height getter
    - [ ] Is-wrapped getter
    - [ ] Line counter inc. per page
- [x] Animation
    - [x] All setters
- [x] Cache manager
    - [x] Build inc. freeze
    - [x] Flush
- [x] Miscellaneous
    - [x] Events getter
    - [x] Template execution
    - [x] String overwrite
    - [x] Fog
    - [x] Ignore command tags

&nbsp;

## `scribble_typist()`

- [x] In
- [x] Out inc. backwards
- [x] Skip
- [x] Position getter
- [x] Easing
- [x] State getter
- [x] Pause/Unpause/Getter
- [x] Sound playback inc. per character
- [x] Function execution per character

&nbsp;

## Fonts

- [x] Standard fonts
- [x] Sprite fonts inc. custom mappings
- [ ] MSDF fonts
    - [x] Basic rendering
    - [x] Border thickness and colour
    - [x] Drop shadow
    - [x] Feather size
- [x] Font modification
    - [x] Style families
    - [x] Font combination
    - [x] Font scale
    - [x] Glyph property setting/getting
    - [x] Outline baking

&nbsp;

## Miscellaneous

- [x] Garbage collector inc. "flush everything"
- [ ] Character delay
- [x] Default template definition

&nbsp;

## Configuration

- [x] Hash to newline conversion
- [x] Escaped newline conversion
- [x] Sprite colorization toggle
- [x] Sprite origin inclusion/exclusion
- [ ] Spritefont left alignment
- [x] Missing character stand-in
- [x] BGR/RGB toggle
- [x] Default sprite animation speed
- [x] Default delay duration
- [x] Included Files subdirectory
- [ ] Box alignment per page/per element
- [x] Fix for time wrapping on low accuracy GPUs
- [x] Tick size control
- [x] Slant amount
- [x] Default unique ID
- [x] Verbose option
- [x] Bezier curve accuracy
- [x] Newline left space trim
- [ ] Fit-to-box iterations
- [x] Command tag open/close/argument symbols