---
title: Resume
---

Resume
======

At Waterloo, we apply for co-op jobs through a website called JobMine.  Without going into details, JobMine required resumes to be submitted as HTML files. (Currently, PDFs are the only allowed format.) Thus, I have found it easier to maintain my resume as HTML, instead of converting from a Word document.

My resume was once stored in XML, and I use some XSLT to transform it to XHTML, and style it with CSS.  I blogged about it a while back, and you can read it [here][xml].

Currently, I store my resume in a YAML file, and I have a Ruby script and a few ERB templates to generate HTML, PDF (via LaTeX), and plain text versions.  The code for it is on [GitHub][github], with corresponding blog post [here][yaml].

- [Resume (PDF)](/resume/YeeMing-Ho_resume_online.pdf)
- [Resume (HTML)](/resume/YeeMing-Ho_resume_online.html)
- [Resume (plain text)](/resume/YeeMing-Ho_resume_online.txt)
- [Resume (TeX)](/resume/YeeMing-Ho_resume_online.tex)

[xml]: /blog/xml_resume.html
[github]: https://github.com/mhyee/resume
[yaml]: /blog/yaml_resume.html
