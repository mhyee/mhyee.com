---
created_at: 2016-11-01
excerpt: "Last week, Jamie Wong wrote about the tradeoffs between dynamically 
and statically typed languages. As a topic I'm very interested in, there was
a lot I wanted to say."
kind: article
tags: [ programming_languages static dynamic gradual types response ]
title: "My Thoughts on \"Bending the Dynamic vs Static Language Tradeoff\""
---

Last week, Jamie Wong wrote about the [tradeoffs between dynamically  and
statically typed languages][pl-curve]. As a topic I'm very interested in, there
was a lot I wanted to say.

If you have comments or if you find errors, please let me know!

---

I really enjoyed reading Jamie's post, and felt that he did a great job
comparing the two camps, and then exploring some recent developments. The post
reminded me of a [Twitter conversation][twitter] I had with Jamie a while back.
I mentioned [gradual typing][gradual], which attempts to bridge this
static/dynamic tradeoff. Type annotations are optional, so you can write code
that mixes typed and untyped expressions/functions/modules. Gradual typing is
still an active area of research, but it's promising to see languages like Hack
and TypeScript.

Sometimes, it's useful to have a different categorization of languages. We could
also think of a static/dynamic spectrum, rather than a strict divide. Sometimes
people use strong/weak typing. (See Eric Lippert's discussion on [whether C# is
strongly typed or weakly typed][csharp-type].) And in one course I took,
a professor suggested a static/dynamic/"operation" triangle, where assembly (and
to an extent, C) has "operation types" rather than static types or dynamic
types. Assembly sort of has types, but they're not really static or dynamic
types.

We could also take a step back and consider dynamic _languages_ rather than
dynamically _typed_ languages. There's a lot of overlap between the two, and
I don't have a good example of a dynamic language that is not dynamically typed.
But a dynamic language allows you to modify objects at run time. Of course, this
gives you more expressive power, faster iteration speed, better debugging
support, etc., but then it can be harder to reason about your program (both for
the programmer and other tools, as Jamie has [written about][grep-test]). And
dynamic languages are also inherently slow. Every time you look up an object
member, you basically have to look it up in a map.

Moving onto more specific comments...

> [Iteration Speed](http://jamie-wong.com/bending-the-pl-curve/#iteration-speed)
>
> Dynamically typed languages do great here.

I would also add "prototyping." Using the `render` method as an example, let's
say I want to refactor its signature, but I want to do a quick prototype first.
In a dynamically typed language, I can change only the parts I care about and
not worry about type errors in other parts of the program. In a statically typed
language, I have to change everything before I can even compile my code and see
if my prototype is on the right track.

> [Iteration Speed](http://jamie-wong.com/bending-the-pl-curve/#iteration-speed-1)
>
> This is arguably the biggest downside of statically typed languages. Type
> checking, as it turns out, is frequently slow.

I'd say that this is more of a "AOT compilation" vs "interpreted or JITted"
issue. (By the way, [Cling][cling] is an interesting project, as
a C++ interpreter.) Yes, type checking can be slow, but there are other reasons
why compilation might be slow.

When I was an intern at Microsoft, someone did an informal experiment and found
that a third of the C++ compiler's time was spent on I/O, because `#include` is
a dumb copy-and-paste. I've also found that heavy use of templates (because they
need to be expanded) is slow, and when I was building Chromium, linking was the
bottleneck, not code generation.

The Scala compiler is also known to be very slow. There's something like twenty
phases, and each phase basically traverses over the entire syntax tree. The
new/next/prototype Scala compiler, Dotty, tries to fuse phases together into
a single traversal, which significantly improves performance. (I'm actually not
that familiar with the details.)

Going back to slow type checking, [OCaml's type inference has worst-case
exponential complexity][ocaml-slow], and if your type system is Turing-complete
(e.g. [C++][cpp-turing], [Java][java-turing], [Scala][scala-turing],
[Haskell][haskell-turing]), then your type checker might not terminate (unless
your stack overflows first). But these are all incredibly unusual circumstances.

> [Correctness Checking](http://jamie-wong.com/bending-the-pl-curve/#correctness-checking-1)
>
> In C++, the compiler will quite happily let you do this:
>
> `User* a = nullptr;
> a->setName("Gretrude");`
>
> Haskell and Scala do their best to dodge this problem by not letting you have
> `null`, instead representing optional fields explicitly with an
> `Maybe User`/`Option[User]`.
>
> [...]
>
> [Debugging Support](http://jamie-wong.com/bending-the-pl-curve/#debugging-support-1)
>
> A particularly nasty class of this where you don’t get any interactive console
> at all to debug is complex compile errors [e.g. template errors].

C++17 now has [std::optional][std-optional]. There is also a Technical
Specification (that just missed getting into C++17) called Concepts Lite, which
allows constraints on templates. The goal is to make template error messages
easier to understand. [Here's a short example (though it links to an old draft of
the concepts proposal)][concepts].

> [Stuck](http://jamie-wong.com/bending-the-pl-curve/#stuck)
>
> You see a similar middle ground emerging in the Object Oriented vs. Functional
> holy war with languages like Scala and Swift taking an OO syntax, functional
> thinking approach, and JavaScript being kind of accidentally multi-paradigm.

Just a nitpick, but Scala was always designed to be object-oriented and
functional, rather than functional with OO syntax. Other languages have also
been designed as multi-paradigm (e.g. Ruby, Python), and some languages are
borrowing features/ideas from other paradigms (e.g. C++ and Java adding
lambdas).

> [Type Inference](http://jamie-wong.com/bending-the-pl-curve/#type-inference)
>
> It’s also now made its way into C++ via the C++11 `auto` keyword, and is
> a feature of most modern statically typed languages like Scala, Swift, Rust,
> and Go.

Type inference is very much from the "static types" camp, but was more
associated with functional programming languages. Some people will also make the
distinction between type inference à la Hindley-Milner type inference, as
opposed to `auto` which is "take the right-hand side expression's type and make
it the type of the left-hand side variable." Type inference in Haskell is the
former, while type inference in Go is the latter.

Actually, that's a little unfair to `auto`, since it's [similar to (but not
exactly the same as) function template argument deduction][cpp-auto]. In C++14,
you can even write:

    #!c++
    auto plus1 = [](auto x) { return x + 1; };

This declares a generic lambda function and binds it to `plus1`. However, this
is just shorthand for using templates. If you never call `plus1`, the template
will never be instantiated, so you could argue that `auto` isn't doing any type
inference at that point.

Compared to Haskell, if you write:

    #!haskell
    let plus1 = \x -> x + 1

The type inference engine will look at the function body and infer that `x` is
an instance of the `Num` type class.

Anyway, going back to writing out types, when I write Scala or Haskell,
I usually write out all my types for function declarations, because I consider
it a form of documentation. But I'll generally leave them out for local
variables, unless it's something really complicated or the compiler infers the
wrong type for me.

> [Decoupling Type Checking from Code Generation](http://jamie-wong.com/bending-the-pl-curve/#decoupling-type-checking-from-code-generation)
>
> If you define your language very carefully, you can make the compiler output
> not dependent on the types (i.e. ignore the type information completely), and
> then run type checking completely separately.

This is where I disagree, but I'm probably coming at it from a different angle.
If you're compiling TypeScript to JavaScript, then I guess it makes sense, but
I'm thinking about implementing a JavaScript JIT. For example, let's say you're
evaluating `x + x.` You don't know what `x` is, so you have to check its type
and then dispatch to the correct `+` method. An optimizing JIT might eventually
figure out that `x + x` is always integer arithmetic, so it'll generate machine
code for that. However, the generated code needs to include a guard, because
there's a possibility that in some future call, `x` is not an integer, and so
the JIT will need to de-optimize. But if the language had types and `x` was an
integer, then the JIT can eliminate the guard. I believe
[StrongScript][strongscript] does this (and more).

JITs for static languages (like Java) will do something similar for method
dispatches. If `x.foo()` is a polymorphic call, but always dispatches to
a single implementation, the JIT will compile it as a static dispatch. Of
course, it still needs to insert a guard, in case `x.foo()` isn't actually
monomorphic.

> [Better Compiler Error Messages](http://jamie-wong.com/bending-the-pl-curve/#better-compiler-error-messages)
>
> There have been numerous attempts to make debugging compilation errors
> a non-issue by having sensible human-readable error messages, notably in Elm.

Dotty is working on significantly better error messages for Scala. They
published a [blog post][dotty-errors] just a few weeks ago. And part of having
good error messages is designing your compiler and infrastructure to track and
provide that information.

And that's everything I wanted to say. There was just one small point
I disagreed with, but overall, I enjoyed the article. I've also felt the
frustration when switching between dynamically typed and statically typed
languages. But I'm also optimistic about the future. (It also means job
opportunities for when I graduate!)

_I would like to thank Jamie Wong for his feedback and discussion, which has
improved this post._

[pl-curve]: http://jamie-wong.com/bending-the-pl-curve/
[twitter]: https://twitter.com/jlfwong/status/580390984271421440
[gradual]: http://homes.soic.indiana.edu/jsiek/what-is-gradual-typing/
[csharp-type]: https://ericlippert.com/2012/10/15/is-c-a-strongly-typed-or-a-weakly-typed-language/
[grep-test]: http://jamie-wong.com/2013/07/12/grep-test/
[cling]: https://root.cern.ch/cling
[ocaml-slow]: https://gist.github.com/mhyee/11129840
[cpp-turing]: http://matt.might.net/articles/c++-template-meta-programming-with-lambda-calculus/
[java-turing]: https://arxiv.org/abs/1605.05274
[scala-turing]: https://gist.github.com/mhyee/38a895277f246f6c79332d6c7ca32f82
[haskell-turing]: http://www.lochan.org/keith/publications/undec.html
[std-optional]: http://en.cppreference.com/w/cpp/utility/optional
[concepts]: https://isocpp.org/blog/2013/02/concepts-lite-constraining-templates-with-predicates-andrew-sutton-bjarne-s
[cpp-auto]: http://thbecker.net/articles/auto_and_decltype/section_01.html
[strongscript]: http://plg.uwaterloo.ca/~dynjs/strongscript/
[dotty-errors]: http://scala-lang.org/blog/2016/10/14/dotty-errors.html
