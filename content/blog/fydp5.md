---
created_at: 2013-12-02
excerpt: "The subject of our next few posts is the partitioned guided
improvement algorithm ... In this post specifically, we will cover a little
background, the inspiration behind this algorithm, and finally, a mistake we
made."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 5: Attempting the Partitioned Guided
Improvement Algorithm"
---

In the [previous post][fydp4], I covered the _overlapping guided improvement
algorithm_ (OGIA), which is the first of our group's two multi-threaded approaches. We
saw some dramatic improvements, but found that there is still a lot of duplicate
work.

The subject of our next few posts is the _partitioned guided improvement
algorithm_, our other multi-threaded approach. In contrast to OGIA, we trade
simplicity for the guarantee that no duplicate solutions are found. In this post
specifically, we will cover a little background, the inspiration behind this
algorithm, and finally, a mistake we made.

Again, before continuing, you may want to refresh your memory on [multi-objective
optimization][fydp2] and the [guided improvement algorithm][fydp3] (GIA).

[fydp2]: /blog/fydp2.html
[fydp3]: /blog/fydp3.html
[fydp4]: /blog/fydp4.html


Background
----------

There were other groups before ours that worked with Professor Rayside to
improve the guided improvement algorithm. In fact, all the other improvement
ideas I have covered so far ([incremental and checkpointed solving][fydp3], and
[OGIA][fydp4]) originated from these groups or other collaborators. In contrast,
the partitioned guided improvement algorithm (PGIA) was an idea we developed on
our own, though the concept of "dividing the search space" is not an original
idea.

Recall how we can plot solutions on a graph. This graph represents a _search
space_ of solutions, with a dimension (or axis on the graph) for each objective
in the problem<sup><a href="#n1" id="t1">1</a></sup>. The basic concept of PGIA,
then, is to divide the search space into regions that can be searched in
parallel<sup><a href="#n2" id="t2">2</a></sup>.

The interesting question is _how_ we can divide the search space. Ideally, we
want to divide the search space so that a _locally optimal_ solution in a region
is _globally optimal_ for the whole problem. If we have this property, we can
treat each region as a separate problem, search the regions in parallel, and
then combine the solutions. We would not have to worry about duplicate
solutions, or solutions from one region dominating solutions from another
region.

I've illustrated some of the previous attempts to divide the search space. In
these examples, we're dealing with two metrics (`m1` and `m2`), so the search space
is two-dimensional.

Unfortunately, none of the attempts to divide the search space work, as locally
optimal solutions may not be globally optimal. To demonstrate this, each diagram
contains two solutions. One, marked with a dot, is locally optimal, but not
globally optimal. The other, marked with an X, is both locally and globally
optimal. The region it dominates is shaded, so we can see how it dominates the
other solution.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig5-1.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig5-1.svg" width="600"
    height="390" style="border:none" />
  </a>
</div>

A locally optimal solution that is not globally optimal is a problematic for
a few reasons. First, we wasted some work, finding a solution that we must
discard. Also, the regions are no longer independent. Finally, we no longer have
the property that the algorithm yields solutions as they are found. We have
additional work to determine if a solution is actually globally optimal, which
can only be done after all regions have been searched.

Our group picked up the work around this point. We were wondering how expensive
the additional work would be, and if it even mattered in the long run. We were
also wondering if we could minimize wasted work by finding "safe" regions, where
locally optimal solutions were always globally optimal. We likely would have
continued in this direction, if not for a key observation we made.


The key observation
-------------------

The inspiration came when we drew the graph slightly differently. Normally, when
a Pareto point is found, we would shade the region dominated by that Pareto
point and exclude it from the search. However, we can shade and exclude another
region --- the "empty" area that dominates the Pareto point. There can be no
solutions in that region, since we failed to find one while climbing up to the
Pareto front.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig5-2.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig5-2.svg" width="400"
    height="260" style="border:none" />
  </a>
</div>

By drawing the graph this way, we can think of the first Pareto point as
splitting the search space into four regions, with two regions immediately
excluded. This leaves two regions we have to search in. Furthermore, in both
regions, a locally optimal solution is also globally optimal. In other words, we
now have two independent regions that we can search in parallel.

We could also recursively apply this algorithm to each of the regions, as shown
below.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig5-3.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig5-3.svg" width="400"
    height="260" style="border:none" />
  </a>
</div>

However, this raises a few issues. If we keep recursively splitting, the number
of regions increases exponentially. We may require a lot of overhead in our
implementation to manage these regions. We may produce many small regions and
spend a lot of effort, only to find no solutions<sup><a href="#n3"
id="t3">3</a></sup>. Even if we split the search space only once, the number of
regions grows exponentially as we increase the number of objectives; for
`N` objectives, we will get <tt>2<sup>N</sup> - 2</tt> regions.

We started thinking about how we could handle these issues, but abandoned them
when we discovered a serious problem<sup><a href="#n4" id="t4">4</a></sup>.


Discovering a flaw in the algorithm
-----------------------------------

Some of our test cases were failing. We examined the simplest failing test,
a problem with three objectives. The regions were being divided properly and
the solutions found were all locally optimal. However, compared to GIA, there
was an extra solution that was not globally optimal. Our claim that locally
optimal solutions are globally optimal was incorrect.

To see how this might be possible, let's look at the test case. With three
objectives, the number of regions to search in is <tt>2<sup>3</sup>
- 2 = 6</tt>. Our constraints will be given in terms of the first Pareto point
the algorithm found, which is <tt><strong>P</strong> = (10, 11, 9)</tt>. The
constraints will be of the form <tt>{(m<sub>1</sub>, m<sub>2</sub>,
m<sub>3</sub>) such that m<sub>1</sub> &#9632; 10, m<sub>2</sub> &#9632; 11,
m<sub>3</sub> &#9632; 9}</tt>, where &#9632; is &#8805; for "better than or
equal" or &lt; for "worse than". For shorthand, I'll simply write
<tt>(&#9632;10, &#9632;11, &#9632;9)</tt>.

In the table below, I've listed the constraints for each of the regions, as well
as the metric points of the locally optimal metric solutions in each region. In
this particular problem, we found one locally optimal solution in each region.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th>Region</th>
      <th>Constraint</th>
      <th>Metric points of locally optimal solutions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>A</td>
      <td><tt>(&lt;10, &lt;11, &lt;9)</tt></td>
      <td>Excluded; all solutions dominated by <tt><strong>P</strong></tt></td>
    </tr>
    <tr>
      <td>B</td>
      <td><tt>(&lt;10, &lt;11, &#8805;9)</tt></td>
      <td><tt>(9, 8, 12)</tt></td>
    </tr>
    <tr>
      <td>C</td>
      <td><tt>(&lt;10, &#8805;11, &lt;9)</tt></td>
      <td><tt>(7, 13, 8)</tt></td>
    </tr>
    <tr>
      <td>D</td>
      <td><tt>(&lt;10, &#8805;11, &#8805;9)</tt></td>
      <td><tt>(6, 12, 12)</tt></td>
    </tr>
    <tr>
      <td>E</td>
      <td><tt>(&#8805;10, &lt;11, &lt;9)</tt></td>
      <td><tt>(14, 10, 8)</tt></td>
    </tr>
    <tr>
      <td>F</td>
      <td><tt>(&#8805;10, &lt;11, &#8805;9)</tt></td>
      <td><tt>(11, 9, 10)</tt></td>
    </tr>
    <tr>
      <td>G</td>
      <td><tt>(&#8805;10, &#8805;11, &lt;9)</tt></td>
      <td><tt>(11, 14, 8)</tt></td>
    </tr>
    <tr>
      <td>H</td>
      <td><tt>(&#8805;10, &#8805;11, &#8805;9)</tt></td>
      <td>None; no solutions dominate <tt><strong>P</strong></tt></td>
    </tr>
  </tbody>
</table>
<br />

As expected, the metric points obey the constraints. They are also locally
optimal, though I have not shown the (locally) dominated metric points. However,
note that the metric point `(7, 13, 8)` is dominated by `(11, 14, 8)`, which is
from a different region. In fact, for any given point in region C, it is
possible a better one exists in Region G --- we simply take the same metric
values, but set the first one to be greater than or equal to `10`. Of course, that
point is only a valid solution if it meets the problem constraints, so it may
not actually exist. The _possibility_ of its existence is the problem, since we
cannot guarantee the point in region C is globally optimal.

Unfortunately, we cannot simply ignore region C, just because we might be able
to find a better solution in region G. For example, suppose the locally optimal
metric point in region G is `(11, 14, 8)`, and the locally optimal metric point
in region C is `(7, 15, 8)`. Neither solution dominates the other.

This is our dilemma: _some_ locally optimal solutions are globally optimal, but
not _all_ locally optimal solutions are globally optimal.

Before we conclude this post, it's interesting --- and constructive --- to
examine why the algorithm worked with two objectives. Consider the diagram
below, where we have a locally optimal solution in region B. I've marked the
area where we have to search to find a better solution, and it overlaps regions
B and D. Thus, the only way to find a better solution in a different region is
to find one in region D. However, this is impossible, because region D is empty.
Therefore, any locally optimal solution in region B is globally optimal. (A
similar argument applies to region C.)

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig5-4.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig5-4.svg" width="400"
    height="260" style="border:none" />
  </a>
</div>


Conclusion
----------

In this post, I introduced the _partitioned guided improvement algorithm_, an
attempt to divide the search space into regions that can be searched in
parallel. We discussed some of the previous attempts, as well as the inspiration
behind PGIA. Unfortunately, as presented, PGIA only works for bi-objective
problems.

In the next part, we'll continue our discussion of the partitioned guided
improvement algorithm. We'll see how the algorithm can be fixed so it works with
any number of objectives.

_I would like to thank Talha Khalid and Chris Kleynhans for proofreading this
post._


Notes
-----

  1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> Visualizing the
     search space for a bi-objective problem is straightforward, since the
     search space is a plane. A problem with three objectives is harder to
     visualize, but still feasible. Unsurprisingly, trying to visualize four or
     more dimensions is extremely difficult, if not impossible.

  2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> In one of the
     notes left behind was the warning "Beware: ideas that seem to intuitively
     work in two dimensions do not always generalize to three or more
     dimensions."

  3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> In early
     prototypes, we observed that recursively splitting the search space helped
     with performance, but after a while, performance degraded. We suspect that
     the exponential number of regions, along with empty regions requiring
     effort, is the cause.

  4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> While working on
     this post, I managed to find some very old code from previous groups. It
     appears they had the same idea we had of splitting the search space.
     However, at the top of the file was the comment "Has correctness problems,"
     so I suspect we both encountered the same problem.
