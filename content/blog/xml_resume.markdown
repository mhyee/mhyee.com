---
created_at: 2010-09-08
foo: bar_
excerpt: Since I've finished my work-term, and the application process for Winter 2011 will start soon, I've been updating my resume.
kind: article
tags: [ xml, resume, xslt, css ]
title: "XML resume transformed into XHTML with XSLT and styled with CSS"
---

Since I've finished my work-term, and the application process for Winter 2011 will start soon, I've been updating my resume. At the same time, I've also decided to convert it to [XML][xml], instead of the Word document I've been maintaining so far.

There's a few reasons for this.

At Waterloo, when we apply for co-op jobs, we have use a website called JobMine. There's a lot that can be said about JobMine, but this isn't the time or place. The relevant part, though, is that our resumes have to be uploaded as HTML. This means the resume has to be created from scratch in HTML, or converted from some existing format (for example, a Word document).

Since my original resume was a Word document, I had to convert it. However, I'm finding that to be too troublesome. There are inconsistencies, the generated HTML and CSS is quite ugly, and I'm never sure how it'll turn out. I believe it'd save time in the long run if I simply created my resume in HTML. I'd also be able to use my own CSS and have more control over the layout.

Now, what does XML have to do with this? XML allows me to store my resume in a nice format without worrying about layout. And then I can use [XSLT][xslt] to transform my XML resume into another XML document. Specifically, XHTML. This is also a great opportunity for me to practise XSLT, something I learned over my work-term. (An earlier idea -- that made using XML more convincing -- was to generate HTML5 and XHTML versions of my resume. HTML5 would be good practice, but probably wouldn't work with Jobmine. However, I wouldn't be using many HTML5 features, so it's not worth the effort.)

(Also, I should mention that the initial idea for using XML and XSLT came from reading a friend's blog.)

Once I get my resume transformed to XHTML, I can style it with CSS. This is another incentive for using HTML and not converting a Word document. The most important thing is *separating content from presentation (or layout)*. Unfortunately, a quick Google search failed to turn up any good articles, so I'll try to summarize the idea.

This idea is pretty much the reason why CSS was introduced. HTML should only describe content, ie *what* is shown. The *how* of being shown, the format/presentation/layout, should be handled by something else: CSS. Trying to control the format with HTML only leads to cluttered code. And there are other reasons for using CSS. For example, pages will load faster (compared to using only HTML for formatting), and it'll be easier to modify the layout. (For an example of the latter, check out the [css Zen Garden][csszen]. They completely change the layout by simply changing the stylesheet. The HTML is not modified at all.)

Going back to my resume, separating presentation and content makes it easier for me to modify my resume. If I want to, say, add a new job entry, I simply have to modify the content (XML in my case). And if I set everything up correctly in the first place, I wouldn't have to change the CSS at all. On the other hand, if I was still using Word, I'd have to add the new job, and then fiddle around with the format. (The worst part is probably how I had to use tables in my Word document. In HTML, tables should only be used to present data. Format should be left to CSS.)

A final bonus of using CSS is using [print styles][printcss]. I can have my resume render a specific way in the browser, and render in a different way when it's printed.

Anyway, now that I've gone and justified this, I should probably go and do it now. (Actually, as of writing, I've already converted my (updated) resume to XML. I just need to write the XSLT and CSS.) I hope to get it done and uploaded here (it's a bit of a glaring omission from my site) within a few days, since I also have other stuff to do. So if you want to see my resume... stay tuned.Since I've finished my work-term, and the application process for Winter 2011 will start soon, I've been updating my resume. At the same time, I've also decided to convert it to XML, instead of the Word document I've been maintaining so far.

[xml]: http://en.wikipedia.org/wiki/XML
[xslt]: http://en.wikipedia.org/wiki/XSLT
[csszen]: http://www.csszengarden.com
[printcss]: http://www.alistapart.com/articles/goingtoprint/
