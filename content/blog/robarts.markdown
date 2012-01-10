---
created_at: 2010-04-27
foo: bar_
excerpt: A couple of months ago, I was idly googling myself, and I found a paper.
kind: article
tags: [ robarts, alzheimers, co-op, uwo ]
title: "High school co-op at the Robarts Research Institute"
---

A couple months ago, I was idly googling myself, and I found [this][paper]

[paper]: http://www.alzheimersanddementia.com/article/PIIS1552526009002611/fulltext

It's the result of the co-op job I had when I was in high school.  I was in grade eleven, and I had the fortune of being matched with the [Imaging Labs][imaging] at the [Robarts Research Institute][robarts], a lab that is now affiliated with the [University of Western Ontario][uwo].  My supervisor, Dr. Rob Bartha, was researching Alzheimer's, and had a program that could take MRI data and analyze it.

[imaging]: http://www.imaging.robarts.ca/
[robarts]: http://www.robarts.ca/
[uwo]: http://www.uwo.ca/

There's a lot of advanced math behind this, which I still don't understand.  (Hopefully MATH 213, Calc 3/Advanced Mathematics for Software Engineers, will shed some light.)  There was quite a lot of complex numbers and [Fourier series][fourier] involved.

[fourier]: http://mathworld.wolfram.com/FourierSeries.html

It's been two years and I don't have access to my lab book, and I'm beginning to forget some of the details (which is another good reason to post this), but Dr. Bartha explained that the original signal was intensity versus time, and the program would perform a [Fast Fourier Transform][fft] to change it to intensity versus *frequency*.

[fft]: http://mathworld.wolfram.com/FastFourierTransform.html

Furthermore, the program could plot these signals and add them.  However, the frequency signals had to be aligned first, and there was no function for that.

This is where I came in.

My task was to add a new function to the program.  This new function would take two signals, perform a cross-correlation to determine how much the second signal had to be phase shifted, phase shift the second signal, and add the two signals together.  Fortunately, I was working with [IDL][idl], a very mathematical language that had libraries that would do most of the work, so I didn't really need to understand all the math behind it.  I also had my first experience with version control, namely, [CVS][cvs].

[idl]: http://en.wikipedia.org/wiki/IDL_%28programming_language%29
[cvs]: http://en.wikipedia.org/wiki/Concurrent_Versions_System

At this point, the end of the school year -- and the co-op job -- was approaching.  However, I was able to obtain a summer job there, to continue what I did during co-op.  It turns out I was able to complete the function before the end of the school year, so when I returned in the summer, my new task was to actually *use* the new function I wrote and add a bunch of signals together.  This was pretty cool.

Dr. Bartha found the results to be "interesting," and eventually wrote and published that article I linked above.  I had no part in actually writing it (even reading it is a chore for me!), but the function I wrote and used was quite important for it.

At any rate, it's quite cool to see an actual *result* of something I wrote.
