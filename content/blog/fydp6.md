---
created_at: 2013-12-16
excerpt: "In this post, we'll conclude our discussion on PGIA. We'll extend the
algorithm for any number of objectives, cover an example problem with three
objectives, and finally, discuss preliminary results and future work."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 6: Fixing the Partitioned Guided
Improvement Algorithm"
---

In the [previous post][fydp5], we started our discussion on the _partitioned
guided improvement algorithm_ (PGIA). We covered some background information, an
interesting idea our group developed, and how it fails for problems with more
than two objectives.

In this post, we'll conclude our discussion on PGIA. We'll extend the algorithm
for any number of objectives, cover an example problem with three objectives,
and finally, discuss preliminary results and future work.

At this point, I will assume familiarity with [multi-objective
optimization][fydp2], the [guided improvement algorithm][fydp3], and the
[previous post][fydp5] on PGIA. This post is likely the most difficult one in my
blog series, so please feel free to ask questions in the comments.

[fydp2]: /blog/fydp2.html
[fydp3]: /blog/fydp3.html
[fydp5]: /blog/fydp5.html


Fixing the algorithm
--------------------

When we concluded the previous post, we investigated the reasons why PGIA only
worked with two objectives: dominating a locally optimal solution requires
finding a solution in the "empty" region.

I've copied a diagram from my previous post, where we've found a Pareto point
and split the search space into four regions. The solution in Region B can only
be dominated by solutions in Region B or Region D; specifically, the patterned
area in the diagram. If the solution we found is locally optimal, then there is
no better solution in Region B. Additionally, there is no better solution in
Region D because nothing dominates the originally discovered Pareto point.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig5-4.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig5-4.svg" width="400"
    height="260" style="border:none" />
  </a>
</div>

The problem with three or more objectives is that we cannot _easily_ make this
guarantee.

Let's look at the general problem with `N` metrics that we want to maximize,
<tt>(m<sub>1</sub>, m<sub>2</sub>, ..., m<sub>N</sub>)</tt>. Suppose the first
Pareto point we find is <tt><strong>P</strong> = (p<sub>1</sub>, p<sub>2</sub>,
..., p<sub>N</sub>)</tt>. When we split the space, we get <tt>2<sup>N</sup></tt>
regions. Each region is described by constraints of the form
<tt>{(m<sub>1</sub>, m<sub>2</sub>, ..., m<sub>N</sub>) such that m<sub>1</sub>
&#9632; p<sub>1</sub>, m<sub>2</sub> &#9632; p<sub>2</sub>, ..., m<sub>N</sub>
&#9632; p<sub>N</sub>}</tt>, where &#9632; is &#8805; for "better than or equal" or
&lt; for "worse than". For shorthand, I'll simply write
<tt>(&#9632;p<sub>1</sub>, &#9632;p<sub>2</sub>, ...,
&#9632;p<sub>N</sub>)</tt>. Keep in mind that <tt>m<sub>i</sub></tt> represents
the <tt>i</tt>th _metric_ and will vary, while <tt>p<sub>i</sub></tt> represents
the <tt>i</tt>th _metric value_ and is fixed.

The (dominated) region described by the constraints <tt>(&lt;p<sub>1</sub>,
&lt;p<sub>2</sub>, ..., &lt;p<sub>N</sub>)</tt> is excluded since all solutions
within that region are dominated by <tt><strong>P</strong></tt>. The (empty)
region described by the constraints <tt>(&#8805;p<sub>1</sub>,
&#8805;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt> is excluded since there
are no solutions that dominate <tt><strong>P</strong></tt>, by definition of
a Pareto point.

Let's look at the regions directly "adjacent" to the empty region, that is,
regions with exactly one "worse than" constraint. The following argument will be
the same for all `N` of these regions, so we'll simply consider the region with
constraints <tt>(&lt;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>, where the remaining constraints are
<tt>&#8805;p<sub>i</sub></tt>.

For any given solution within this region, a dominating solution exists if we
improve at least one of the metrics (and satisfy the problem constraints)<sup><a
href="#n1" id="t1">1</a></sup>. If we increase only the objectives
<tt>m<sub>2</sub>, m<sub>3</sub>, ... m<sub>N</sub></tt>, we will remain in this
region. In contrast, if we increase <tt>m<sub>1</sub></tt>, we will eventually
reach a different region, the one described by constraints
<tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>.

In other words, any locally optimal solution in <tt>(&lt;p<sub>1</sub>,
&#8805;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt> might be dominated by
a solution in <tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>., but since that region is empty, all locally optimal
solutions in <tt>(&lt;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt> are globally optimal.

The same argument applies to the other regions with exactly one "worse than"
constraint. Since all these regions are independent<sup><a href="#n2"
id="t2">2</a></sup> and do not overlap each other, we can search them in
parallel.

Suppose we have gone and found all locally optimal solutions in the `N` regions
with exactly one "worse than" constraint. We know that these solutions are
globally optimal.

Now let's look at the regions with exactly two "worse than" constraints. Without
loss of generality, we'll consider <tt>(&lt;p<sub>1</sub>, &lt;p<sub>2</sub>,
..., &#8805;p<sub>N</sub>)</tt>, where the remaining constraints are
<tt>&#8805;p<sub>i</sub></tt>. Using a similar argument from before, if we want
to find a better solution in a different region, we have to increase
<tt>m<sub>1</sub></tt>, <tt>m<sub>2</sub></tt>, both. This pushes us into one of
the following regions <tt>(&lt;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>, <tt>(&#8805;p<sub>1</sub>, &lt;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>, or <tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>.

We already know the last one is empty. However, at this point, we've already
found the locally optimal solutions in <tt>(&lt;p<sub>1</sub>,
&#8805;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt> and
<tt>(&#8805;p<sub>1</sub>, &lt;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt>.
We can use those solutions to create exclusion constraints for our search in
<tt>(&lt;p<sub>1</sub>, &lt;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt>, thus
avoiding locally optimal solutions that are dominated by external solutions. In
other words, we can guarantee that locally optimal solutions in
<tt>(&lt;p<sub>1</sub>, &lt;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt>
are globally optimal.

We can apply the same argument to all regions with exactly two "worse than"
constraints and search them in parallel. Once these regions are done, we can
search all regions with exactly three "worse than" constraints, then four, and
so on until we finish with `N - 1` "worse than" constraints<sup><a href="#n3"
id="t3">3</a></sup>. At every step of this process, we can guarantee locally
optimal solutions are globally optimal by using exclusion constraints based on
all previously found optimal solutions.

Our algorithm now has multiple steps with dependencies, which will require
sequential processing. However, we have still broken the problem into smaller
pieces, and we can still perform some of the searching in parallel. We just
cannot search all <tt>2<sup>N</sup></tt> regions in parallel.


An optimization and some more notation
--------------------------------------

Consider the regions <tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&lt;p<sub>N</sub>)</tt> and <tt>(&lt;p<sub>1</sub>, &lt;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>, where the former has exactly one "worse than"
constraint and the latter has exactly two "worse than" constraints. From our
previous description, we have to finish searching in the first region before we
can start searching in the second region, because it has fewer "worse than"
constraints.

However, these two regions are independent. Region <tt>(&#8805;p<sub>1</sub>,
&#8805;p<sub>2</sub>, ..., &lt;p<sub>N</sub>)</tt> depends only on
<tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>, while region <tt>(&lt;p<sub>1</sub>,
&lt;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt> depends only on
<tt>(&#8805;p<sub>1</sub>, &lt;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt>,
<tt>(&lt;p<sub>1</sub>, &#8805;p<sub>2</sub>, ..., &#8805;p<sub>N</sub>)</tt>,
and <tt>(&#8805;p<sub>1</sub>, &#8805;p<sub>2</sub>, ...,
&#8805;p<sub>N</sub>)</tt>. In other words, we can search these two regions in
parallel. No solution in one can dominate a solution in the other.

We can create a dependency graph that illustrates which regions we can search in
parallel. However, our current notation is a little difficult to work with, so
we'll use binary strings, similar to how our implementation uses bit sets. The
binary string <tt>b<sub>1</sub>b<sub>2</sub>...b<sub>N</sub></tt>, represents
a region <tt>(&#9632;p<sub>1</sub>, &#9632;p<sub>2</sub>, ...,
&#9632;p<sub>N</sub>)</tt> where <tt>b<sub>i</sub></tt> is `1` for "better than
or equal" constraints and `0` for "worse than" constraints.

Our dependency graph will be a directed acyclic graph where each vertex
represents a region, and an edge directed from `R` to <tt>R&#8242;</tt> means
`R` is a dependency of <tt>R&#8242;</tt>. In other words, we need to search in
`R` before we can search in <tt>R&#8242;</tt>, because a solution in `R` might
dominate a locally optimal solution in <tt>R&#8242;</tt>.

For a problem with `N` objectives, our graph will have <tt>2<sup>N</sup></tt>
vertices, where each vertex is labelled with a binary string of length `N`.
A directed edge from `R` to <tt>R&#8242;</tt> exists if and only if
<tt>R&#8242;</tt> is the same string as `R`, but with _exactly a single `1` changed
to a `0`_.

Let's examine why this works. Suppose the `1` we changed to a `0` corresponds to
the digit <tt>b<sub>i</sub></tt>, which represents metric
<tt>m<sub>i</sub>,</tt>. The edge from `R` to <tt>R&#8242;</tt> means `R` is
a dependency of <tt>R&#8242;</tt>, or that a solution in `R` might dominate
a locally optimal solution in <tt>R&#8242;</tt>. Assuming we can satisfy the
problem constraints, we can find this better solution in `R` by taking the
solution in <tt>R&#8242;</tt> and setting <tt>m<sub>i</sub></tt> to be greater
than or equal to <tt>p<sub>i</sub></tt>.

It is also possible to find a better solution by increasing multiple metric
values. This would correspond to changing multiple `0`s to `1`s. However, the
dependencies and the "dominates" relationship are transitive; if solution A is
dominated by solution B and solution B is dominated by solution C, then solution
A is dominated by solution C.

Remember, the key idea for this algorithm is that we search the dependencies in
order, and then use the known Pareto points to construct exclusion constraints.
Therefore, when we search within a region, we exclude any locally optimal points
that we know are dominated. The remaining locally optimal points are globally
optimal, because we did not find anything that could dominate them.


An example problem with three objectives
----------------------------------------

To visualize how this algorithm works, we'll walk through an example problem
with three objectives. This example problem is based on the one from the
[previous post][fydp5], but slightly modified for demonstration purposes.

First, we'll consider all existing solutions, even non-optimal ones. We will
assume that the first Pareto point, <tt><strong>P</strong> = (10, 11, 9)</tt>,
has already been found, and that we have already split the space accordingly.
This time, the regions are labelled with binary strings instead of letters.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th>Region</th>
      <th>Constraint</th>
      <th>Metric points of solutions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><tt>000</tt><sup><a href="#n4" id="t4">4</a></sup></td>
      <td><tt>(&lt;10, &lt;11, &lt;9)</tt></td>
      <td><tt>(5, 6, 4)</tt>
    </tr>
    <tr>
      <td><tt>001</tt></td>
      <td><tt>(&lt;10, &lt;11, &#8805;9)</tt></td>
      <td><tt>(9, 8, 12)</tt></td>
    </tr>
    <tr>
      <td><tt>010</tt></td>
      <td><tt>(&lt;10, &#8805;11, &lt;9)</tt></td>
      <td><tt>(7, 13, 8)</tt></td>
    </tr>
    <tr>
      <td><tt>011</tt></td>
      <td><tt>(&lt;10, &#8805;11, &#8805;9)</tt></td>
      <td><tt>(5, 12, 10)</tt>, <tt>(6, 12, 12)</tt></td>
    </tr>
    <tr>
      <td><tt>100</tt></td>
      <td><tt>(&#8805;10, &lt;11, &lt;9)</tt></td>
      <td><tt>(11, 10, 8)</tt>, <tt>(14, 10, 8)</tt></td>
    </tr>
    <tr>
      <td><tt>101</tt></td>
      <td><tt>(&#8805;10, &lt;11, &#8805;9)</tt></td>
      <td><tt>(11, 9, 10)</tt></td>
    </tr>
    <tr>
      <td><tt>110</tt></td>
      <td><tt>(&#8805;10, &#8805;11, &lt;9)</tt></td>
      <td><tt>(11, 14, 8)</tt></td>
    </tr>
    <tr>
      <td><tt>111</tt></td>
      <td><tt>(&#8805;10, &#8805;11, &#8805;9)</tt></td>
      <td>None; no solutions dominate <tt><strong>P</strong></tt></td>
    </tr>
  </tbody>
</table>
<br />

The dependency graph for this problem is shown below. For completeness, I have
additionally included the vertices for `111` and `000`, even though we skip them
in the algorithm.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig6-1.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig6-1.svg" width="400"
    height="260" style="border:none" />
  </a>
</div>
<br />

Since `111` is empty, we start by searching `110`, `101`, and `011` in parallel.
In `110` and `101`, the only solutions are `(11, 14, 8)` and `(11, 9, 10)`,
respectively. Therefore, these solutions are locally optimal. In `011`, we first
find that `(6, 12, 12)` is the locally optimal solution, dominating `(5, 12,
10)`, since it has improved at least one metric value without worsening the
others. Specifically, the first and third metric values are better, while the
second value is no worse.

The locally optimal solutions we discovered are also globally optimal, because
any better solution from a different region must exist in `111`, which is empty.

If we finished `110` and `101` first, the dependency graph indicates we can
proceed to `100`, even though we could still be searching in `011`. This is
because no solution in `100` can dominate a solution in `011`, and vice versa.
We could not make a metric better without making some other metric worse.

Suppose we have finished searching `110`, `101`, and `011`, and we have the
corresponding exclusion constraints to search in `001`, `010`, and `100`.

In `001`, we find the solution `(9, 8, 12)`, which is locally optimal and not
dominated by the known solutions. Therefore, it is globally optimal.

In `010`, the exclusion constraints prevent us from returning `(7, 13, 8)` as
a solution, because it is dominated by `(11, 14, 8)`. Thus, there are no locally
optimal solutions in this region.

Finally, in `100`, the exclusion constraints prevent us from yielding `(11, 10, 8)`.
However, nothing excludes `(14, 10, 8)`, so it is both locally and globally
optimal.

In the diagram below, I have plotted the three-dimensional graph, without
solutions. Note the two regions shaded grey; the darker region is excluded
because all solutions are dominated by <tt><strong>P</strong></tt>, and the
lighter region is excluded because there are no solutions that dominate
<tt><strong>P</strong></tt>.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig6-2.png" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig6-2.png" width="400"
    height="260" style="border:none" />
  </a>
</div>
<br />

I plotted this graph with MATLAB (specifically, MuPAD). The code is provided
below, and I have also included the code for plotting the solutions.

    #!matlab
    plot(
        plot::Box(10..15, 11..16, 9..14, FillColor=RGB::Grey80.[0.8]),
        plot::Box(10..15, 11..16, 4..9, Filled = FALSE),
        plot::Box(10..15, 6..11, 9..14, Filled = FALSE),
        plot::Box(10..15, 6..11, 4..9, Filled = FALSE),
        plot::Box(5..10, 11..16, 9..14, Filled = FALSE),
        plot::Box(5..10, 11..16, 4..9, Filled = FALSE),
        plot::Box(5..10, 6..11, 9..14, Filled = FALSE),
        plot::Box(5..10, 6..11, 4..9, FillColor=RGB::Grey50.[0.8]),
        /* These are the (globally) optimal solutions */
        plot::PointList3d(
           [[9,8,12], [6,12,12], [14,10,8], [11,9,10], [11,14,8]],
           PointStyle=FilledSquares),
        /* These solutions are not globally optimal */
        plot::PointList3d(
           [[5,6,4], [7,13,8], [5,12,10], [11,10,8]],
           PointStyle=FilledCircles)
    )

[fydp5]: /blog/fydp5.html


Preliminary results
-------------------

Our group has implemented both the algorithm and the optimization described
above. I will not be discussing the implementation this time<sup><a href="#n5"
id="t5">5</a></sup>, but you can find the code on [GitHub][pgia].

With our implementation, we have been able to run our preliminary tests. Below,
we have a graph and a table comparing incremental solving (IGIA), checkpointed
solving (CGIA), the overlapping guided improvement algorithm (OGIA), and PGIA.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig6-3.png" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig6-3.png" width="647"
    height="415" style="border:none" />
  </a>
</div>
<br />

In the graph, lower numbers are better, indicating that less time was spent
solving the problem. Also, note that two of the queens problems are missing
a bar for IGIA; for one of them, we never attempted the test, and for the other,
the bar distorts the entire graph because it is so large. The original GIA
results are not included, since we are now comparing our algorithms against
IGIA. Finally, recall that these are informal test results, run on the
undergraduate computer science servers.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th><!-- empty --></th>
      <th>Incremental Guided Improvement Algorithm</th> <!-- 1da4839 -->
      <th>Checkpointed Guided Improvement Algorithm</th> <!-- 13ab50f -->
      <th>Overlapping Guided Improvement Algorithm</th> <!-- 8eaa3d6 -->
      <th>Partitioned Guided Improvement Algorithm</th> <!-- 8f8626f -->
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9 queens, 5 metrics</td>
      <td>2 hours, 0 min</td>
      <td>51 min</td>
      <td>50 min</td>
      <td>42 min</td>
    </tr>
    <tr>
      <td>9 queens, 6 metrics</td>
      <td>4 days, 16 hours, 43 min</td>
      <td>1 hour, 39 min</td>
      <td>1 hour, 53 min</td>
      <td>1 hour, 18 min</td>
    </tr>
    <tr>
      <td>9 queens, 7 metrics</td>
      <td>Never attempted<sup><a href="#n6" id="t6">6</a></sup></td>
      <td>3 hours, 37 min</td>
      <td>4 hours, 4 min</td>
      <td>3 hours, 4 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 5 metrics</td>
      <td>3 hours, 0 min</td>
      <td>1 hour, 26 min</td>
      <td>2 hours, 38 min</td>
      <td>1 hour, 44 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 6 metrics</td>
      <td>2 hours, 8 min</td>
      <td>59 min</td>
      <td>1 hour, 11 min</td>
      <td>2 hours, 5 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 7 metrics</td>
      <td>5 hours, 1 min</td>
      <td>2 hours, 16 min</td>
      <td>2 hours, 46 min</td>
      <td>3 hours, 10 min</td>
    </tr>
  </tbody>
</table>
<br />

The results are similar to OGIA, though in some cases PGIA can be better or
worse. Again, we also see that CGIA, a single-threaded approach, beats PGIA,
a multi-threaded approach, in some of the tests.

However, when we tried some of our extremely large tests, CGIA and OGIA fell
behind<sup><a href="#n7" id="t7">7</a></sup>.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th><!-- empty --></th>
      <th>Checkpointed Guided Improvement Algorithm</th> <!-- 13ab50f -->
      <th>Overlapping Guided Improvement Algorithm</th> <!-- 8eaa3d6 -->
      <th>Partitioned Guided Improvement Algorithm</th> <!-- 8f8626f -->
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9 rooks, 5 metrics</td>
      <td>21 days, 9 hours, 36 min</td>
      <td>5 days, 8 hours, 16 min</td>
      <td>4 days, 15 hours, 28 min</td>
    </tr>
    <tr>
      <td>9 rooks, 6 metrics</td>
      <td>Never attempted<sup><a href="#n8" id="t8">8</a></sup></td>
      <td>16 days, 11 hours, 56 min</td>
      <td>5 days, 17 hours, 19 min</td>
    </tr>
    <tr>
      <td>9 rooks, 7 metrics</td>
      <td>Never attempted</td>
      <td>19 days, 39 min</td>
      <td>5 days, 15 hours, 52 min</td>
    </tr>
  </tbody>
</table>
<br />

We suspect this extremely poor performance is because the rooks problems have
fewer constraints than the queens problems. Thus, there are far more solutions
to find, and PGIA can better handle this situation. However, it's important to
note that these problems are extremely large and contrived, which we likely
won't see with real world problems.

[pgia]: https://github.com/TeamAmalgam/kodkod/pull/40


Future work
-----------

At the time of writing, we are interested in three further improvements to PGIA.

The first, similar to OGIA, is to build PGIA on top of CGIA. Again, we would
need to look at reducing memory usage first.

Next, we could recursively split the regions. To keep things simple, our first
implementation only splits the space once, and uses regular GIA within each
region. We're interested in what happens if we continue splitting the regions
and making them smaller. However, we probably want to limit the number of
recursive calls, otherwise there will be too much overhead.

Finally, we're interested in whether we can find a "good" Pareto point to split
the space. Currently, we take whatever Pareto point we find first. However, this
may result in regions with different sizes. It may be more effective for us to
choose a Pareto point that gives us regions with roughly the same size, or
better, a Pareto point that evenly distributes the solutions in each of the
regions.


Conclusion
----------

In this post, we concluded our discussion of the _partitioned guided improvement
algorithm_. We had previously discussed the background and inspiration for PGIA,
and in this post, we completed the algorithm and walked through an example
execution. The algorithm is far more complicated than OGIA, but it guarantees no
duplicate solutions.

At this point, the blog series has covered all the work our group has
accomplished so far. I have no further blog posts planned for this series, as
they will depend on what our group works on, from now until March 2014. However,
potential topics include the results of our further investigations, or results
from rigorous performance evaluations.

Thank you for reading this blog series. I hope the posts have been informative
and interesting, and that it was worth your time. If you still want to learn
more, you can look at our [documents and repositories][docrepo], or
[contact][contact] me.

[docrepo]: /fydp.html
[contact]: /about.html

_I would like to thank Talha Khalid, Chris Kleynhans, Zameer Manji, and Arjun
Sondhi for proofreading this post._

Notes
-----

  1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> Remember, such
     a solution only exists if it satisfies the problem constraints. However,
     the _possibility of existence_ is good enough here, because we want to
     guarantee that _no solution exists_.

  2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> That is,
     a solution in one region cannot dominate a solution in another region. We
     demonstrated this by identifying the regions a dominating solution could
     exist in.

  3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> We do not
     concern ourselves with the region with `N` "worse than" constraints,
     because we already know all of its solutions are dominated by
     <tt><strong>P</strong></tt>.

  4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> This row can be
     read as "Region `000`, with constraint <tt>(&lt;10, &lt;11, &lt;9)</tt>,
     contains the solution at `(5, 6, 4)`."

  5. <a style="text-decoration: none;" id="n5" href="#t5">^</a> I tried
     discussing the implementation details in an early draft, but a high-level
     description was not very enlightening. I would have to start describing
     what sort of concurrency constructs we used in Java, but the discussion
     then becomes tedious.

  6. <a style="text-decoration: none;" id="n6" href="#t6">^</a> IGIA had very
     little improvement over GIA for the 9 queens problems, so we never
     attempted this case, which took over fifty days with GIA.

  7. <a style="text-decoration: none;" id="n7" href="#t7">^</a> Remember, this
     is the same CGIA that took just under four hours for 9 queens with
     7 metrics, which took over 50 days on the original GIA.

  8. <a style="text-decoration: none;" id="n8" href="#t8">^</a> We did not
     attempt these problems with CGIA, because we suspected the tests would take
     too long.
