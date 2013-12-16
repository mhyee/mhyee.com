---
created_at: 2013-10-10
excerpt: "Our fourth-year design project is to optimize the guided improvement
algorithm, which is used to solve exact, discrete, multi-objective optimization
problems."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 1: Introduction, Definition,
Applications"
---

_"Our fourth-year design project is to optimize the guided improvement
algorithm, which is used to solve exact, discrete, multi-objective optimization
problems."_

When friends ask about our group's fourth-year design project
(FYDP)<sup><a href="#n1" id="t1">1</a></sup>, that's the most specific and
succinct answer I can give. If I want to provide a more helpful answer, I can
either make it shorter but more vague ("We're optimizing an algorithm"), or more
detailed but much longer.

That second option is what I'd like to do here, in a series of blog posts.
I plan to write about the following topics:

* [Introduction, Definition, and Applications][fydp1]
* [A More Formal Definition][fydp2]
* [The Guided Improvement Algorithm][fydp3]
* [The Overlapping Guided Improvement Algorithm][fydp4]
* [Attempting the Partitioned Guided Improvement Algorithm][fydp5]
* [Fixing the Partitioned Guided Improvement Algorithm][fydp6]
* ...
* TBD: Results?
<br/>

I don't anticipate the list changing too much, even though I'm still in the
process of writing and editing the other parts. The only topic I am unsure about
is results; at the time of writing (October 2013), our group is still working on
the project. We have some preliminary results, but will likely not have anything
rigorous until our design symposium, which will be held around March 2014.

I do not expect readers of this series to have any background in optimization,
but I do expect some background in computer science. Readers from math,
engineering, or science backgrounds should be able to follow most of this
series. I will be referring to things such as discrete and continuous variables,
SAT solvers, and multi-threading, but only a basic understanding of these topics
is required. It is more important that a reader can follow the (informal) math
definitions and examples.

The rest of this post will be about multi-objective optimization, specifically,
a basic introduction plus a discussion of its applications. In future parts,
I'll give a more formal definition, walk through some examples, and describe
three related algorithms for solving exact, discrete, multi-objective
optimization problems.

[fydp1]: /blog/fydp1.html
[fydp2]: /blog/fydp2.html
[fydp3]: /blog/fydp3.html
[fydp4]: /blog/fydp4.html
[fydp5]: /blog/fydp5.html
[fydp6]: /blog/fydp6.html


What is multi-objective optimization?
-------------------------------------

Informally speaking, _optimization_ is choosing the "best" (or _optimal_) option
from some set of alternatives. What makes an option optimal is based on an
objective (or _metric_), which we can minimize or maximize.

For instance, suppose we want to assemble a
bicycle<sup><a href="#n2" id="t2">2</a></sup> while minimizing the total cost.
We have a selection of parts (such as the frame, brakes, tires, and so on) to
choose from. However, we can't haphazardly choose parts. Some parts might fit
only with certain parts, so we need to consider _constraints_. Thus, we want to
find a configuration (or _solution_) that satisfies the constraints and is also
_optimal_.

Since our only objective is the bicycle's cost, this is a single-objective
optimization problem. In the real world, we would need to consider other
criteria, such as maximizing performance. Now we have a _multi-objective_ (or
_many-objective_) optimization problem with two
criteria<sup><a href="#n3" id="t3">3</a></sup>.

With multiple objectives, defining the "best" solution becomes more complicated
when objectives conflict with each other. It will be often impossible to
assemble a bicycle that is both cheap and has excellent performance, so we'll
have to accept trade-offs and allow multiple solutions. We could choose one of
the extremes (a cheap bicycle with poor performance or an expensive bicycle with
high performance), or something in between. In the next part, I’ll provide
a more formal definition for how we can do this.

To briefly summarize, optimization is choosing some option that satisfies the
problem constraints and is optimal with respect to a single objective. With
multi-objective optimization, we usually have to make trade-offs between
different objectives when choosing an optimal solution.


What is exact, discrete, multi-objective optimization?
------------------------------------------------------

Our project is concerned with exact, discrete, multi-objective optimization,
which is a specific type of multi-objective optimization.

Discrete multi-objective optimization means we are working with _discrete_ (or
_combinatorial_) variables, as opposed to continuous variables. In discrete
optimization, we are restricted to certain values or configurations. For
example, suppose we have to choose between aluminum, steel, titanium, or carbon
fibre for our bicycle frame. We cannot mix the materials and choose arbitrary
percentages.

"Exact" refers to _exact_ solutions, as opposed to approximate ones. A popular
approach for solving multi-objective optimization problems is to use genetic
algorithms. However, genetic algorithms find approximate solutions and cannot
guarantee that they are exact<sup><a href="#n4" id="t4">4</a></sup>.

Much of the related work within this field seems to be concerned with continuous
variables, or finding approximate solutions to discrete multi-objective
optimization problems. In contrast, our group is interested algorithms that find
exact solutions to multi-objective optimization problems with discrete
variables.

From this point on, I will refer to "exact, discrete, multi-objective
optimization" simply as “multi-objective optimization.”


What are some applications of multi-objective optimization?
-----------------------------------------------------------

In this section, I'll discuss three applications of multi-objective
optimization, taken from real engineering problems. Our group is using these
problems as case studies for our performance evaluations. We also have toy
problems, but it’s more important to see how our improvements can help solve
real problems.

The first problem, from aerospace engineering, is based on the decisions made
while planning the Apollo program<sup><a href="#n5" id="t5">5</a></sup>. Some of
these decisions included the number of crew members, the type of Earth and lunar
orbits, and the fuel type. In this model, the objectives are to minimize weight
and risk.

The second problem, also from aerospace engineering, is a ten-year satellite
launch schedule formulated by NASA, called the
[decadal survey][decadal]<sup><a href="#n6" id="t6">6</a></sup>. The decisions
in this problem include choosing which satellites to launch and in which order,
while the constraints include deadlines for specific satellites and restrictions
on the launch order. The objectives are to maximize value for each of the six
participating scientific communities, as a delayed launch can reduce  value.

The final problem, from software engineering, is actually a collection of
(software) product line problems. The general idea is that when choosing
features for a particular product, there are also different objectives and
constraints to include in the decisions. For example, one of our problems
involves designing a search and rescue system
<sup><a href="#n7" id="t7">7</a></sup>. Decisions include the type of
connectivity and location finding, whether maps should be preloaded or
downloaded on demand, and the format for data exchange. Objectives include
minimizing cost, development time, battery usage and maximizing reliability.

Our group has a few other case studies, most of which are software product line
problems. We have also looked at a few civil engineering problems, but we
currently do not have models for our evaluations.

Hopefully, this section has provided some motivation for why multi-objective
optimization is significant and how it can be used in the real world.

[decadal]: http://web.archive.org/web/20130217173638/http://science.nasa.gov/earth-science/decadal-surveys/


Conclusion
----------

In this first part, I introduced and provided an overview of my planned blog
series, which is to explain our group's fourth year design project.
Specifically, I want to elaborate on the opening quote: "Our fourth year design
project is to optimize the guided improvement algorithm, which is used to solve
exact, discrete, multi-objective optimization problems."

I also introduced exact, discrete, multi-objective optimization, defining the
terms separately. To quickly summarize, our group is interested in algorithms
that can find exact solutions to discrete optimization problems with multiple
objectives.

Finally, I provided three real world applications of multi-objective
optimization: the Apollo program, the decadal survey, and software product
lines.

In the [next part][fydp2], I'll provide a more formal definition of
multi-objective optimization, which should clarify some of the concepts
introduced today. I’ll also step through a more concrete (though also more
contrived) example, and that should conclude my explanation of multi-objective
optimization.

_I would like to thank Chris Kleynhans and Zameer Manji for proofreading this
post._


Notes
-----

 1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> The fourth-year
    design project, part of the [software engineering][se] curriculum at the
    [University of Waterloo][waterloo], is a three-course sequence. (Other
    engineering programs at Waterloo have similar courses.) Students work in
    groups of four team members, over the course of 20 months, on a non-trivial
    engineering project involving software development.

 2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> I'm not an expert
    on bicycles, but this was the example given when I first learned about
    multi-objective optimization, so it's stuck in my mind.

 3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> Nothing restricts
    us to only two objectives, other than trying to keep the example simple.
    Sometimes, "multi-objective" is used to to differentiate between "one
    objective" and "two or three objectives," but our group uses it to mean "any
    number of objectives." _Many-objective_ is often used to mean the latter.

 4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> This will become
    clearer in the next post, with a more formal definition of "optimal."

 5. <a style="text-decoration: none;" id="n5" href="#t5">^</a> If you’re
    interested, [chapter 4 of this PhD thesis][apollo] discusses the Apollo
    problem in greater detail.

 6. <a style="text-decoration: none;" id="n6" href="#t6">^</a> The decadal
    survey runs once every ten years. The [first one][first_decadal] completed
    in 2007.

 7. <a style="text-decoration: none;" id="n7" href="#t7">^</a> The search and
    rescue problem is adapated from [this technical report][searchandrescue].

[se]: https://uwaterloo.ca/software-engineering/
[waterloo]: https://uwaterloo.ca/
[apollo]: http://dspace.mit.edu/handle/1721.1/42912
[first_decadal]: http://www.nap.edu/catalog.php?record_id=11820
[searchandrescue]: http://mason.gmu.edu/~nesfaha2/Publications/GMU-CS-TR-2011-3.pdf
