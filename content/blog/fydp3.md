---
created_at: 2013-11-09
excerpt: "I concluded my previous post by posing a question: how do we actually
solve multi-objective optimization problems? This post will answer that question
by discussing the guided improvement algorithm."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 3: The Guided Improvement Algorithm"
---

In the [first][fydp1] [two][fydp2] posts of this blog series, we discussed
multi-objective optimization: what it is and why it's important. I concluded the
previous post by posing a question: how do we actually solve multi-objective
optimization problems?

My next few posts will be answering that question. More specifically, this post
will be about the _guided improvement algorithm_, while the other posts will be
about _improvements_.

There will be a lot of terminology in this post, so if you need a reminder,
please take some time to review my [previous post][fydp2]. Also, the material in
this post will be more difficult than my previous ones --- if anything is
unclear, I am more than happy to clarify in the comments.

[fydp1]: /blog/fydp1.html
[fydp2]: /blog/fydp2.html


The guided improvement algorithm
--------------------------------

The guided improvement algorithm (GIA) was first [introduced][giatr] by
Rayside<sup><a href="#n1" id="t1">1</a></sup>, Estler, and Jackson. The main
idea is to formulate the optimization problem as a set of constraints, and then
use a SAT solver<sup><a href="#n2" id="t2">2</a></sup> to find solutions that
satisfy those constraints. Furthermore, GIA also augments the constraints so we
can find _better_ solutions.

We start by passing the problem constraints to the SAT solver and asking for
some solution. Informally, we call this step "throwing a dart," since we do not
care how good the first solution is.

Next, GIA asks the SAT solver for a solution that dominates the previous one.
Specifically, GIA augments the constraints to specify that _all_ the metrics of
the new solution are _at least as good_ as the current solution's metric values,
and that _at least one_ of the metrics is _strictly better_.

The algorithm repeats this process, "climbing" up to the Pareto front, until it
cannot find a better solution. Thus, the last solution found is a Pareto point,
by definition. Note that, due to continually finding a better solution, the
Pareto point found will dominate the starting solution.

Recall that a Pareto point may contain multiple solutions. To handle this case,
the algorithm performs a task we call the "magnifier." It searches for other
solutions, asking the SAT solver for solutions that have the same metric values
as the Pareto point just found.

The algorithm is not finished yet, as there may be more Pareto points. We may be
able to find a solution with a better metric value, at the cost of worsening
a different metric value. Therefore, we need to start a new climb up to the
Pareto front. However, we also want to guarantee that we find a new Pareto
point. To do this, GIA adds extra constraints to ensure that the starting point
is not dominated by any of the known Pareto points. Since the climb finishes at
a Pareto point that dominates the starting solution, and our starting point is
not dominated by a known Pareto point, we will end up at a new Pareto point.

The algorithm repeats this process: throwing a dart, climbing up to the Pareto
front, and running the magnifier on the Pareto point. If GIA throws a dart but
finds no solution, then this means there is no new solution that is not
dominated by an existing Pareto point. In other words, all solutions are either
Pareto points, or dominated by existing Pareto points. Thus, there is no new
Pareto point to be discovered.

We have an implementation of the algorithm on [GitHub][gia]. However, there are
a lot of implementation details, so the following pseudocode may be easier to
understand:

    #!ruby
    exclusionConstraints = empty
    # Throw the dart. Get the first solution.
    solution = Solve(problemConstraints)
    while solution exists
        # Climb up to the Pareto front.
        while solution exists
            prevSolution = solution
            # Find a better solution.
            solution = Solve(problemConstraints AND dominates prevSolution)
        end
        # Nothing dominates prevSolution, so it's a Pareto point.
        # Magnifier; find all solutions at the Pareto point.
        while s = Solve(problemConstraints AND equals prevSolution)
            yield s
        end
        # Augment the constraints. Exclude solutions dominated by known Pareto points.
        exclusionConstraints = exclusionConstraints AND not dominated by prevSolution
        # Throw the dart. Find a new solution.
        solution = Solve(problemConstraints AND exclusionConstraints)
    end

[giatr]: http://dspace.mit.edu/handle/1721.1/46322
[gia]: https://github.com/TeamAmalgam/kodkod/blob/master/src/kodkod/multiobjective/algorithms/GuidedImprovementAlgorithm.java


An example execution of the guided improvement algorithm
--------------------------------------------------------

To better illustrate how GIA works, let's walk through an execution. We'll solve
a problem with two metrics, `m1` and `m2`. We'll plot the metric points on
a graph like last time. I'll use a dot to represent a solution that exists but
is unknown to the algorithm, and an X to represent a solution that was found by
the algorithm.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-1.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-1.svg" width="400"
    height="260" />
  </a>
</div>

The algorithm throws a dart and finds its first solution<sup><a href="#n3"
id="t3">3</a></sup>, which I've marked with an X. Next, it begins the climb up
to the Pareto front, searching for a better solution. The algorithm wants
a solution that dominates the previous one, so it ignores the shaded area<sup><a
href="#n4" id="t4">4</a></sup>.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-2.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-2.svg" width="400"
    height="260" />
  </a>
</div>

The algorithm continues its climb up to the Pareto front, searching for a better
solution each time.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-3.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-3.svg" width="400"
    height="260" />
  </a>
</div>

We continue this process until no better solution can be found. Thus, the
previous solution is a Pareto point. The algorithm must now run the magnifier on
the Pareto point. To keep the example and diagrams simple, we'll say there are
no other solutions at the Pareto point.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-4.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-4.svg" width="400"
    height="260" />
  </a>
</div>

Now GIA needs to start its climb again. To ensure that the climb reaches a new
Pareto point, we need a starting solution that is not dominated by any of the
known Pareto points<sup><a href="#n5" id="t5">5</a></sup>. In the diagram below,
the new solution must exist outside this shaded area.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-5.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-5.svg" width="400"
    height="260" />
  </a>
</div>

The algorithm continues this process of throwing a dart, climbing up to the
Pareto front, and running magnifier on the Pareto point. The second dart throw
is shown below.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-6.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-6.svg" width="400"
    height="260" />
  </a>
</div>

The algorithm has found a better solution. It tries to find an even better one,
but cannot, so the algorithm has found another Pareto point.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-7.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-7.svg" width="400"
    height="260" />
  </a>
</div>

The algorithm must throw a dart and start the climb again. The new solution must
not be dominated by the known Pareto points.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-8.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-8.svg" width="400"
    height="260" />
  </a>
</div>

Here, the dart throw just happened to land on another Pareto point.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-9.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-9.svg" width="400"
    height="260" />
  </a>
</div>

GIA throws a dart but cannot find a new solution. All solutions are either
optimal or dominated by the optimal solutions. Therefore, the algorithm can now
terminate.

<div style="text-align:center">
  <a href="http://files.mhyee.com/fydp/images/fig3-10.svg" style="border:none">
    <img src="http://files.mhyee.com/fydp/images/fig3-10.svg" width="400"
    height="260" />
  </a>
</div>


The problem with the guided improvement algorithm
-------------------------------------------------

The algorithm is very slow. Every call to the SAT solver is an extremely
expensive operation<sup><a href="#n6" id="t6">6</a></sup>. Furthermore, as a SAT
solver only understands Boolean algebra, we need to translate everything,
including arithmetic (which is used when adding up metric values)<sup><a
href="#n7" id="t7">7</a></sup>.

The solving time for small problems is typically manageable. However, for larger
problems, GIA will not complete in any reasonable time. Worse, the difference
between "small" and "large" can be sudden and surprising. For example, one of
the our largest benchmarks is multi-objective 9-queens. It takes about three
hours to solve with five metrics. Add another metric and it takes almost five
days. With seven metrics, it takes over fifty days.

The algorithm's performance is not limited to contrived problems such as
multi-objective 9-queens. We also see it with our search and rescue benchmark,
a real-world problem I mentioned in my [first post][fydp1]. It takes over ten
hours to solve the seven metric version.

This is the reason for our group's fourth-year design project. The guided
improvement algorithm is slow and scales poorly for large problems. Our project
is to design, implement, and test improvements to the algorithm.


Incremental and checkpointed solving
------------------------------------

Before I conclude this post, I'd like to describe two improvements our group is
exploring: incremental and checkpointed solving.

We're also working on other approaches, but incremental and checkpointed solving
apply to the way GIA interacts with the SAT solver, rather than the algorithm
itself<sup><a href="#n8" id="t8">8</a></sup>. The advantage here is that our
other approaches can build on top of incremental and checkpointed solving.

The issue we're trying to address is that every time the algorithm asks the SAT
solver for a new solution, we waste a lot of work. As the SAT solver is
searching for a solution, it builds up state and slowly "learns." However, that
is all discarded when we ask the SAT solver for a new solution, and it has to
start from scratch.

Some SAT solvers are capable of _incremental solving_. After solving a formula,
we add new constraints, and the SAT solver can reuse everything it "learned"
while solving the previous formula. This scenario perfectly fits how GIA
continually finds better solutions. We can keep the state up until we find
a Pareto point.

We [modified our implementation][igia] to take advantage of incremental solvers.
When we ran our informal benchmarks, we saw tests run about twice as fast.

However, there is still room for improvement. Incremental solving allows us to
add new constraints without losing state, but the state is cleared when we
remove constraints. Unfortunately, this happens once the algorithm has found
a Pareto point --- it needs to step down from the Pareto front and find a new
starting solution.

_Checkpointed solving_ allows us to "roll back" to a previous state. Now, we can
work our way up to the Pareto front without losing state, and also roll back and
find a new starting solution without losing state. Thus, we no longer have to
discard any state.

It turns out very few SAT solvers support this functionality, so we had to
modify an existing SAT solver. It was a lot of work, but we [eventually
succeeded][cgia]. With checkpointed solving, we are about twice as fast as
incremental solving.

I've listed how long it takes to solve the 9-queens and search and rescue
problems with our algorithms: (base) GIA, incremental GIA (IGIA), and
checkpointed GIA (CGIA). We ran these informal tests on the shared undergraduate
computer science servers<sup><a href="#n9" id="t9">9</a></sup>.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th><!-- empty --></th>
      <th>GIA</th> <!-- e2ae93c -->
      <th>IGIA</th> <!-- 1da4839 -->
      <th>CGIA</th> <!-- 13ab50f -->
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9 queens, 5 metrics</td>
      <td>2 hours, 53 min</td>
      <td>2 hours, 0 min</td>
      <td>51 min</td>
    </tr>
    <tr>
      <td>9 queens, 6 metrics</td>
      <td>4 days, 19 hours, 55 min</td>
      <td>4 days, 16 hours, 43 min</td>
      <td>1 hour, 39 min</td>
    </tr>
    <tr>
      <td>9 queens, 7 metrics</td>
      <td>Over 50 days<sup><a href="#n10" id="t10">10</a></sup></td>
      <td>Never attempted<sup><a href="#n11" id="t11">11</a></sup></td>
      <td>3 hours, 37 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 5 metrics</td>
      <td>6 hours, 55 min</td>
      <td>3 hours, 0 min</td>
      <td>1 hour, 26 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 6 metrics</td>
      <td>4 hours, 55 min</td>
      <td>2 hours, 8 min</td>
      <td>59 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 7 metrics</td>
      <td>10 hours, 38 min</td>
      <td>5 hours, 1 min</td>
      <td>2 hours, 16 min</td>
    </tr>
  </tbody>
</table>
<br />

As you can see, CGIA is very impressive. However, we still have some ideas to
refine it --- in particular, our implementation is not very memory efficient.

[igia]: https://github.com/TeamAmalgam/kodkod/pull/16
[cgia]: https://github.com/TeamAmalgam/kodkod/pull/39


Conclusion
----------

In this post, I described and showed how the guided improvement algorithm can
solve a multi-objective optimization problem. However, GIA can be incredibly
slow, which makes it less useful for large problems. I also briefly described
two promising approaches to improving the GIA: incremental solving and
checkpointed solving.

So far, these two approaches have been single-threaded, and cannot take
advantage of multi-core processors. We are also interested in parallelizing GIA.
In the [next part][fydp4], I'll describe the _overlapping guided improvement
algorithm_, which is one of our approaches for a parallel GIA.

_I would like to thank Chris Kleynhans, Zameer Manji, and Arjun Sondhi for
proofreading this post._

[fydp4]: /blog/fydp4.html


Notes
-----

  1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> Professor
     Rayside is the advisor for our fourth-year design project.

  2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> In the Boolean
     satisfiability problem (SAT), formulas are expressed in Boolean algebra,
     where each variable is either 1 (true) or 0 (false). The operators are AND,
     OR, and NOT. The problem is to determine whether there exists an assignment
     of values such that the formula evaluates to "true." For our purposes, we
     will treat the SAT solver as a "black box": we give it constraints, and it
     either gives us a solution that satisfies the constraints or it declares
     that the constraints cannot be satisfied.

  3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> Any solution
     could be the first solution. It could be a bad one, a solution that already
     dominates another solution (as in this example), or even an optimal
     solution.

  4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> Solutions in the
     shaded area fall in two categories: 1) they are dominated by the previous
     solution; or 2) they do not dominate and are not dominated by the previous
     solution. In other words, solutions here do not dominate the previous
     solution. Solutions in the unshaded area, however, will dominate the
     previous solution.

  5. <a style="text-decoration: none;" id="n5" href="#t5">^</a> If we start in
     the shaded area, our search for a better solution could lead us to a new
     Pareto point or an existing one. (Note that the discovered Pareto point is
     right at the corner of the shaded area.) However, if we start outside the
     shaded area, searching for a better solution will never take us to an
     existing Pareto point.

  6. <a style="text-decoration: none;" id="n6" href="#t6">^</a> Readers with
     a computer science background may recognize SAT as an NP-complete problem.
     A gross simplification is to say that there is currently no known efficient
     algorithm for SAT. Whether any efficient algorithm exists (for SAT or
     similar problems) is the subject of the [P vs NP problem][pnp], arguably
     the most important unsolved problem in computer science.

  7. <a style="text-decoration: none;" id="n7" href="#t7">^</a> This is
     a technique called "bit-blasting," where adder and multiplier circuits are
     created and then converted to SAT. As a consequence, the input formulas to
     the SAT solver are extremely large.

  8. <a style="text-decoration: none;" id="n8" href="#t8">^</a> Of course,
     another approach is to replace our current SAT solver with a better one.

  9. <a style="text-decoration: none;" id="n9" href="#t9">^</a> There are three
     servers, each with 48 cores and 128 GB of memory. Each processor is
     a twelve-core AMD Opteron 6100.

 10. <a style="text-decoration: none;" id="n10" href="#t10">^</a> After running
     the test for 50 days, the server was rebooted and our test was lost. We
     decided not to try again, until after we had made significant improvements
     to the algorithm.

 11. <a style="text-decoration: none;" id="n11" href="#t11">^</a> Seeing as IGIA
     had very little improvement for the other 9-queens problems, we decided it
     was not worth testing it with 9-queens, seven metrics.

[pnp]: http://www.claymath.org/millennium/P_vs_NP/
