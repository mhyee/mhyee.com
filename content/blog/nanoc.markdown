---
created_at: 2012-03-04
foo: _bar
excerpt: "With (seemingly) all my friends switching to static site generators, I figured I might as well jump onto the bandwagon."
kind: article
tags: [ meta, blog, nanoc ]
title: "Blogging with nanoc"
---

With many of my friends switching to static site generators, I figured I might as well jump onto the bandwagon. (To be accurate, I made the migration in January, but didn't blog about it until now.) But first, a little bit of history.

How I used to run my site
-------------------------

Back in 2010, when I first launched my site, I used [WordPress][]. It worked well, but I soon began having aspirations of writing my own blogging system as a side project -- I think I had [Rails][] in mind.

However, a couple of unfortunate circumstances forced me to migrate my site. In the process, I switched to a static site as a "temporary" measure, until I had a replacement. Unfortunately, "temporary" dragged on for over a year, and writing everything by hand in HTML proved to be too troublesome to blog semi-regularly.

In early 2012, I finally switched to using [nanoc][], a static site generator.

[WordPress]: http://wordpress.org
[Rails]: http://rubyonrails.org
[nanoc]: http://nanoc.stoneship.org/

Why nanoc? Why not jekyll? Or Rails?
------------------------------------

Originally, the motivation for using Rails was to teach myself Rails. But then I ended up with a Rails co-op job and learned Rails anyway. Furthermore, Rails is a bit overkill for a simple little blog. I don't need a database or dynamic content. Simple HTML should work, except that it's a lot of trouble to maintain, as I learned.

Then I learned about [jekyll][] and static site generators. It seemed to be perfect: write all my posts in my text editor of choice (vim) in something like [Markdown][], version control it on GitHub, and then have everything generated and uploaded in one simple step. Don't need to hammer out a full HTML file every time I blog, and don't need to worry about a database dying on me.

Then why did I settle with nanoc? To be honest, I'm not entirely sure. Maybe it was because almost all of my friends were using jekyll, and I wanted to be different. (Actually, I learned about nanoc when I saw one of my friends setting it up.)

I did do some browsing, and liked what I read about nanoc. I decided to give it a try, and I'm pretty happy with it now. But since I never actually tried jekyll, it wouldn't be fair for me to make any comparisons. So I'll just say I chose nanoc on a whim and wasn't disappointed.

[jekyll]: http://jekyllrb.com
[Markdown]: http://daringfireball.net/projects/markdown

Setting up nanoc
----------------

Admittedly, jekyll might win out here, because there are options like [Octopress][] and [Jekyll-Bootstrap][] with all the setup done. On the other hand, "starter kits" for nanoc are almost nonexistent -- I manged to find a [nanoc starter kit][], but it hasn't been updated for over a year. I also ended up making my own customizations, since I have my own strong opinions and wanted to keep my old URLs. Essentially, my goal was to preserve the look and feel of my old site and change only my workflow.

My first step was to move all my pages over to friendlier formats. I ported the layout over to [Haml][] and the content to Markdown. For the very few content pages that require dynamically-generated content, I used [ERB][].

Next, I began playing around with the compilation and routing rules for nanoc. This was a bit of a learning curve, because there aren't too many examples out there. I think my biggest problem was mistaking identifiers for paths. Even though the notes state that the rules match on "identifiers" and not paths, `/blog/*/` really looks like a path of some sort. I'll walk through a few (simplified) examples from my configuration.

    #!ruby
    compile '/blog/*/' do
      filter :rdiscount, :extensions => %w( strict smart )
      filter :colorize_syntax, :default_colorizer => :pygmentize

      layout 'blog'
    end

This compilation rule applies to anything with an identifier that matches `/blog/*/`. The confusing thing is that identifiers are based on paths. For example, this blog post has identifier `/blog/nanoc/` because its full path in my repo is `/content/blog/nanoc.markdown`. (It's probably not too bad now, but wait a bit.)

So now that an item has been matched by this rule, what happens? nanoc processes the item with two filters, [RDiscount][] and `colorize_syntax` (which is powered by [Pygmentize][]). In goes a Markdown blog post (possibly with some code snippets), out comes HTML with any code snippets syntax highlighted. Finally, nanoc applies the blog layout, which is slightly different from the default layout.

I also have other compilation rules to handle things like processing ERB, compressing my CSS with [Rainpress][], or doing nothing at all to images.

After everything has been compiled, I need to tell nanoc where to route everything. Essentially, these are the rules nanoc uses to create URLs and directories. This is where I stumbled with differentiating between identifiers and paths.

    #!ruby
    route '/styles/*' do
      item.identifier.chop + '.' + item[:extension]
    end

This rule matches everything in the `/content/styles` directory. For example, it matches `/content/styles/bg.png`, and mounts it at `/styles/bg.png`. It seems obvious now, but I had originally mixed the rules up and found my stylesheets being mounted at weird locations like `/style.html` or `/bg.html`.

There's more I could probably show, but I think I'll just leave it at the nanoc basics for now. If you're interested for more, you can check out my [repo][].

[Octopress]: http://octopress.org/
[Jekyll-Bootstrap]: http://jekyllbootstrap.com/
[nanoc starter kit]: https://github.com/mgutz/nanoc3_blog
[Haml]: http://haml-lang.com/
[ERB]: http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html
[RDiscount]: https://github.com/rtomayko/rdiscount
[Pygmentize]: https://github.com/djanowski/pygmentize
[Rainpress]: http://code.google.com/p/rainpress/
[repo]: https://github.com/mhyee/mhyee.com

My new workflow
---------------

Because it's so simple, I'll show you how I actually go about writing a post.

    $ rake create:post slug=hello
            [ok] Edit content/blog/hello.markdown
    $ vi content/blog/hello.markdown
    $ nanoc compile
    Loading site data...
    Compiling site...
       identical  [0.14s]  output/about.html
       ...
          create  [0.02s]  output/hello.html
       ...

    Site compiled in 2.70s.
    $ rake deploy:rsync
    building file list ... done
    ...
    sent 23495 bytes  received 1778 bytes  16848.67 bytes/sec
    total size is 152616  speedup is 6.04

As for what the default `hello.markdown` looks like:

    $ cat content/blog/hello.markdown
    ---
    created_at: 2012-03-05
    excerpt: "An article about Hello"
    kind: article
    tags: [ misc ]
    title: "Title for Hello"
    publish: false
    ---

    TODO: Add content to `content/blog/hello.markdown.`

The first portion, within the `---`, is for the metadata. One thing to point out is that I can choose not to publish a drafts. Originally I thought this would be pointless, since I'm hosting everything publicly on GitHub, but then I remembered I'm running my own Git server. Solution: version control drafts in my private repo, and when it's ready, push to GitHub.

The rest of the file is for the actual contents, written in Markdown. I don't need to worry about any boilerplate HTML or anything; I can just start writing.

Next steps
----------

There's a few things I can continue to do. I've already added [DISQUS][] comments and Feedburner since the initial migration to nanoc. I could probably organize the blog list better, and actually make use of tags. I could also be clever with my CSS and use [Sass][], or start learning and adding [CoffeeScript][].

On another note, while writing this post, I've run into minor problems when trying to preview my site locally. For example, Disqus breaks when I try to view a blog post locally (unless I modify a configuration variable), and I can't preview draft posts locally. I'd like some sort of way to differentiate between "development" and "production" environments, so that Disqus config variable can be set automatically, and draft posts are hidden only on production.

Overall, though, I'm hoping that with the simplified workflow, there will be less disincentive to blog, so maybe I'll actually blog more frequently now.

At least, I can keep hoping.

_If you're interested in the code, you can find it on [GitHub][]._

[DISQUS]: http://disqus.com/
[Sass]: http://sass-lang.com/
[CoffeeScript]: http://coffeescript.org/
[GitHub]: https://github.com/mhyee/mhyee.com
