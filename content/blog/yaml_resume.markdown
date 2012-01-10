---
created_at: 2011-09-07
foo: bar_
excerpt: Almost exactly a year ago, I blogged about using XML and XSLT to generate my resume.
kind: article
tags: [ yaml, ruby, erb, latex, html ]
title: "Resume stored in YAML, with HTML and LaTeX templates"
---

Almost exactly a year ago, I [blogged][blog] about using XML and XSLT to generate my resume. It was an alright solution, but a bit unwieldy, and there wasn't an elegant way of generating PDFs. Plus, XML and XSLT pretty much locked me down to... XML. But now, after a workterm of Ruby on Rails development and an academic term of using as much [LaTeX][latex] as possible, I felt confident enough to throw out the XSLT and write a more powerful resume system.

[blog]: /blog/xml_resume.html
[latex]: http://en.wikipedia.org/wiki/LaTeX

I was also largely inspired by [David Hu's resume system][david]. In fact, my system has a lot similarities to David's -- probably more than I intended. But it's the basic idea that's the same. Store resume contents in a file (eg [YAML][yaml]). Use a script and some templates to generate an actual resume. When updating the resume, only edit the YAML file. Separate content (YAML) from presentation (HTML, PDF, etc). In a sense, this can also be considered an extension to my original system, where XML was the storage format and XSLT handled the templates.

[david]: https://github.com/divad12/resume
[yaml]: http://yaml.org

There is one extra feature I wanted, that was missing from my old system. I don't want certain information (permanent address, phone number, etc) to appear on an online resume or show up on a public code repository. My (rather crude) way of handling this before was to simply edit out the information. But now I have a chance to address this. I store my private information in a second YAML file which is not included in the repository, and have the script generate two versions of my resume: one with the private information loaded, and one without. The "normal" version I can send out for interviews, while the second "web" version is for uploading to my website.

Once I took care of this, I could begin writing templates. I started with an HTML template, which was fairly straightforward: I took my old XSLT template and basically replaced the XSLT code with Ruby code. The embedded Ruby code simply extracts the required information, but occassionaly there's a few loops to generate lists.

This worked out fairly well. My Ruby script would load in the necessary YAML files, load the template, and then run it through the ERB templating system. Then it would create a final resume which had all my information filled out. Voila: no need to edit HTML to update my resume.

The next template was quite a bit trickier. Despite some experience with using LaTeX, I'm still quite new to it. (If you're interested in creating a LaTeX resume, there are plenty of pages online, though [this one][latex-cv] seems quite nice. I happened to use the same LaTeX class (by Michael DeCorte) that the tutorial covers.) 

[latex-cv]: http://linux.dsplabs.com.au/resume-writing-example-latex-template-linux-curriculum-vitae-professional-cv-layout-format-text-p54/

Probably the biggest problem was that this template required a two-stage "compilation" process. First, I have to run the template through my script, which generates a LaTeX source file. Then I use `pdflatex` to create a PDF file. Of course, this assumes I made no syntax errors in my template, and it also assumes the generated LaTeX source has no syntax errors itself either! (I suspect it would have been easier to convert a LaTeX resume into a template file, rather than trying to write both at the same time. Certainly, having to write LaTeX and Ruby code at the same time was a bit of a mental exercise!)

But I managed to get it working, and after some tweaking, I'm happy with the PDF output. While there are still a few things on my "wishlist" to look at, for now I've accomplished the main goal. Plus, there are other things I'd like to work on.

If you would like to see the code, or adapt it for your own uses, the repository (including templates) is on [GitHub][github]. And, of course, you can find the the generated resumes [on this site][resume].

[github]: https://github.com/mhyee/resume
[resume]: /resume/
