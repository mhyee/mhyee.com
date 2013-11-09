---
created_at: 2013-10-29
excerpt: "In my previous post, I introduced our group's fourth-year design
project. However, parts of my explanation required a more formal definition."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 2: A More Formal Definition"
---

In my [previous post][fydp1], I introduced our group's fourth-year
design project and outlined what I wanted to write about in a series of blog
posts. I provided a high-level explanation of exact, discrete, multi-objective
optimization, and also discussed some of its applications.

However, parts of my explanation required a more formal definition of
multi-objective optimization. For example, I simply noted that the "optimal"
solution would often involve making trade-offs, and I was fairly vague on what
"exact solutions" meant.

I hope to clarify those concepts in this post, by more formally defining
a number of terms<sup><a href="#n1" id="t1">1</a></sup>. I will also be walking
through some examples to illustrate these terms.

[fydp1]: /blog/fydp1.html


The multi-objective 3-rooks problem
-----------------------------------

Multi-objective 3-rooks is a contrived problem, but it's nice to use in examples
and test cases because it's simple. Essentially, it's a variation of the
[8-queens puzzle][queens].

In the 8-queens puzzle, the goal is to place eight queens on an 8x8 chessboard,
such that no two queens are "attacking" each other. In other words, no two
queens may share the same row, column, or diagonal.

With 3-rooks, we simplify the problem in two ways: we have a 3x3 chessboard, and
we place rooks instead of queens. No two rooks may be on the same row or column,
but they are allowed to share diagonals.

To turn this into an optimization problem, each square of the chessboard is
given a score. For a given solution, we take the squares with rooks on them and
sum the scores. The objective then is to find a solution that
maximizes<sup><a href="#n2" id="t2">2</a></sup> the total score. To turn this
into a multi-objective optimization problem, we simply assign multiple scores to
each square. Thus, each solution will have multiple total scores.

I will be using multi-objective 3-rooks as an example for each of the
definitions below. Some of these definitions will be review from last time,
though described more succinctly and formally. The rest will be new.

[queens]: http://en.wikipedia.org/wiki/Eight_queens_puzzle


Definitions
-----------

**Definition**: In an _optimization_ problem, we aim to select the _optimal_
solution from some set of alternatives.

For example, "in the 3-rooks problem, find a solution that maximizes the total
scores."

**Definition**: A _solution_ is some configuration that satisfies the problem
_constraints_.

In the 3-rooks problem, the constraint is that no two rooks may share the same
row or column. A solution is an arrangement of rooks on the chessboard. There
are six solutions<sup><a href="#n3" id="t3">3</a></sup> for the 3-rooks problem.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig2-1.svg">
    <img src="http://files.mhyee.com/fydp/images/fig2-1.svg" alt="All solutions to
the 3-rooks problem" width="600" height="390" />
  </a>
</div>

**Definition**: The _objectives_ (or _metrics_) are what we try to _maximize_ or
_minimize_ when selecting a solution. We use the _metric values_ to compare two
solutions.

In multi-objective 3-rooks, we compare and want to maximize the total scores.

For our examples, we'll use bi-objective 3-rooks. I've inserted two scores to
the bottom right of each square of the chessboard; `Score1` is the first number
and `Score2` is the second number.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig2-2.svg">
    <img src="http://files.mhyee.com/fydp/images/fig2-2.svg" alt="Scores inserted
into the 3x3 chessboard" width="230" height="230" />
  </a>
</div>
<br/>

**Definition**: A _metric point_ is a list of values, one for each objective.

If we superimpose solution 2 onto the scores, we see that `Score1` has a total
of `6 + 7 + 3 = 16` and `Score2` has a total of `5 + 8 + 4 = 17`. Thus, the
metric point is `(16, 17)`.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig2-3.svg">
    <img src="http://files.mhyee.com/fydp/images/fig2-3.svg" alt="Solution
2 superimposed onto the scores" width="230" height="230" />
  </a>
</div>
<br/>

I've also listed out all the metric points in a table.

<table style="border-collapse:separate;border-spacing:5px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th><!-- empty --></th>
      <th>Score1</th>
      <th>Score2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Solution 1</td>
      <td style="text-align:right">14</td>
      <td style="text-align:right">17</td>
    </tr>
    <tr>
      <td>Solution 2</td>
      <td style="text-align:right">16</td>
      <td style="text-align:right">17</td>
    </tr>
    <tr>
      <td>Solution 3</td>
      <td style="text-align:right">16</td>
      <td style="text-align:right">17</td>
    </tr>
    <tr>
      <td>Solution 4</td>
      <td style="text-align:right">21</td>
      <td style="text-align:right">11</td>
    </tr>
    <tr>
      <td>Solution 5</td>
      <td style="text-align:right">15</td>
      <td style="text-align:right">15</td>
    </tr>
    <tr>
      <td>Solution 6</td>
      <td style="text-align:right">8</td>
      <td style="text-align:right">21</td>
    </tr>
  </tbody>
</table>
<br/>

These points can be plotted<sup><a href="#n4" id="t4">4</a></sup> on a graph,
with an axis for each objective.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig2-4.svg">
    <img src="http://files.mhyee.com/fydp/images/fig2-4.svg" alt="Graph of the
metric points" width="400" height="333" />
  </a>
</div>

One important note is that multiple solutions may have the same metric point. In
the table, we see that there are two solutions with the same metric point of
`(16, 17)`. We also observe this in the graph, where there are only five metric
points for six solutions.

**Definition**: Solution A _dominates_ Solution B if both of the following
conditions are true: 1) at least one metric value of A is better than the
corresponding metric values of B; and 2) the remaining metric values of A are no
worse<sup><a href="#n5" id="t5">5</a></sup> than their corresponding metric
values of B.

In our example, solution 3 `(16, 17)` dominates solution 1 `(14, 17)` and
solution 5 `(15, 15)`. Although solution 3 and solution 1 have the same `Score2`,
solution 3 has a greater `Score1`.

**Definition**: A solution is _Pareto optimal_ if and only if it is not
dominated by some other solution. In other words, for a Pareto optimal solution,
there is no way to improve a metric value without making at least one other
metric value worse<sup><a href="#n6" id="t6">6</a></sup>.

From this point on, I will refer to "Pareto optimal" simply as "optimal."

In the graph, I've circled the optimal solutions and shaded the areas they
dominate. We can easily see that solutions 2, 3, 4, and 6 are optimal. None of
these solutions dominates another, which is why they are optimal. Since
solutions 1 and 5 are in, or on the edge of, the shaded region, they are
dominated and therefore not optimal.

**Definition**: A _Pareto point_ is a metric point that is optimal. Recall that
multiple solutions may have the same metric point; thus, a Pareto point may
yield multiple solutions.

**Definition**: The set of all optimal solutions is called the _Pareto front_.

**Definition**: _Solving a multi-objective optimization problem_ means finding
the Pareto front.

Note that these definitions are also valid for single-objective optimization
problems.

With these definitions, it is easier to see what choosing the "best" solution
is. Any of the solutions in the Pareto front are equally valid, since we cannot
improve an objective without making another worse.

The concept of "exact solutions" is also clearer: we want to guarantee that the
solutions we find are optimal, and not simply "close" to the Pareto front.


Conclusion
----------

This post concludes my explanation of multi-objective optimization, including
a discussion of its applications. At this point, a natural question would be how
we actually solve a multi-objective optimization problem. There are a number of
different algorithms, but our group is interested in the _guided improvement
algorithm_, which will be the subject of my [next post][fydp3].

_I would like to thank Chris Kleynhans, Zameer Manji, and Arjun Sondhi for
proofreading this post._

[fydp3]: /blog/fydp3.html


Notes
-----

 1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> For more details,
    you can refer to section 3 of this [technical report][gia], by Rayside,
    Estler, and Jackson. This technical report presented the guided improvement
    algorithm, which is what our group is working to improve.

 2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> Or minimizes, but
    we'll maximize objectives in these examples.

 3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> If we account for
    rotations and reflections, then there are only two unique solutions.
    However, as will become clear shortly, we will not be able to rotate or
    reflect solutions in our examples.

 4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> A graph is very
    helpful when visualizing a bi-objective problem, less helpful when we have
    three objectives, and essentially useless with four or more objectives.

 5. <a style="text-decoration: none;" id="n5" href="#t5">^</a> They may be equal
    or better.

 6. <a style="text-decoration: none;" id="n6" href="#t6">^</a> This is
    "trade-off" I've been referring to in the previous post.

[gia]: http://dspace.mit.edu/handle/1721.1/46322
