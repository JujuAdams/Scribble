testVectorArray = [
/*  0 */    { unicode: "गया", expected: "x;k" },
/*  1 */    { unicode: "बोधगया", expected: "cks/kx;k" },
/*  2 */    { unicode: "बारा", expected: "ckjk" },
/*  3 */    { unicode: "अतिया", expected: "vfr;k" },
/*  4 */    { unicode: "मोचारीम", expected: "ekspkjhe" },
/*  5 */    { unicode: "बकरौर", expected: "cdjkSj" },
/*  6 */    { unicode: "बसाढ़ी", expected: "clk<+h" },
/*  7 */    { unicode: "मोराटाल", expected: "eksjkVky" },
/*  8 */    { unicode: "कन्हौल", expected: "dUgkSy" },
/*  9 */    { unicode: "गंफाखुर्द", expected: "xaQk[kqnZ" },
/* 10 */    { unicode: "नवां", expected: "uoka" },
/* 11 */    { unicode: "कुरमावां", expected: "dqjekoka" },
/* 12 */    { unicode: "इटरा", expected: "bVjk" },
/* 13 */    { unicode: "झिकटिया", expected: "f>dfV;k" },
/* 14 */    { unicode: "मोरामर्दाना", expected: "eksjkenkZuk" },
/* 15 */    { unicode: "ईलरा", expected: "bZyjk" },
/* 16 */    { unicode: "पड़रिया", expected: "iM+fj;k" },
/* 17 */    { unicode: " शेखवारा", expected: " 'ks[kokjk" },
/* 18 */    { unicode: "बारा", expected: "ckjk" },
/* 19 */    { unicode: "अतिया", expected: "vfr;k" },
/* 20 */    { unicode: "मोचारीम", expected: "ekspkjhe" },
/* 21 */    { unicode: "मोेचारिम", expected: "eksspkfje" },
/* 22 */    { unicode: "वकरौर", expected: "odjkSj" },
/* 23 */    { unicode: "बसाढ़ी", expected: "clk<+h" },
/* 24 */    { unicode: "कन्हौल", expected: "dUgkSy" },
/* 25 */    { unicode: "गफा खूर्द", expected: "xQk [kwnZ" },
/* 26 */    { unicode: "नवाँ", expected: "uok¡" },
/* 27 */    { unicode: "कुरमावां", expected: "dqjekoka" },
/* 28 */    { unicode: "ईटरा", expected: "bZVjk" },
/* 29 */    { unicode: "झिकटिया", expected: "f>dfV;k" },
/* 30 */    { unicode: "ईलरा", expected: "bZyjk" },
/* 31 */    { unicode: "धनावाँ", expected: "/kukok¡" },
/* 32 */    { unicode: "पड़रिया", expected: "iM+fj;k" },
/* 33 */    { unicode: " शेखवारा", expected: " 'ks[kokjk" },
/* 34 */    { unicode: "न0 पंचायत", expected: "u0 iapk;r" },
/* 35 */    { unicode: "रिक्त", expected: "fjDr" },
];

scribble_font_set_default("fnt_krutidev");
unicode = "चाह नहीं मैं सुरबाला के गहनों में गूँथा जाऊँ";
show_debug_message(unicode);
krutidev = UnicodeToKrutidev(unicode);
show_debug_message("UnicodeToKrutidev = \"" + krutidev + "\"");

index = 0;
