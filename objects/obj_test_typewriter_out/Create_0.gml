typist = scribble_typist();
typist.in(1, 10);

element = scribble("When text is fading out but still visible .get_state() will return a value less than 2.0[/page]Here's another page to test how typists behave when swapping to another page.")
          .wrap(450)
          .align(fa_center, fa_middle);