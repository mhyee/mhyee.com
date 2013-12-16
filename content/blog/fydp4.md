---
created_at: 2013-11-14
excerpt: "In the previous post, I finished discussing all the relevant
background material for our group's design project. In this post, I will be
discussing the overlapping guided improvement algorithm, which is the first of
our two [multi-threaded] ideas."
kind: article
tags: [ fydp research waterloo university multi-objective optimization ]
title: "Fourth-Year Design Project, Part 4: The Overlapping Guided Improvement
Algorithm"
---

In the [previous post][fydp3], I finished discussing all the relevant background
material for our group's design project. I also described two approaches we were
exploring: incremental and checkpointed solving.

However, these approaches are single-threaded and do not take advantage of
multi-core processors. Therefore, our group is also interested in
multi-threaded<sup><a href="#n1" id="t1">1</a></sup> approaches. In this post,
I will be discussing the _overlapping guided improvement algorithm_, which is
the first of our two ideas. I also want to describe what problems we ran into
and fixed, and what new ideas we have.

If you need to refresh your memory on [terminology][fydp2] and the [guided
improvement algorithm][fydp3], please take some time to review the two previous
posts. Again, I am also happy to answer any questions in the comments.

[fydp2]: /blog/fydp2.html
[fydp3]: /blog/fydp3.html


The overlapping guided improvement algorithm
--------------------------------------------

The idea behind the overlapping guided improvement algorithm (OGIA) is actually
quite straightforward: we run multiple instances of GIA in parallel. The main
program will start up multiple threads, and each thread will follow the old
algorithm of finding a starting point, climbing up to the Pareto front, and then
repeating.

In the best case, all the threads do useful work, finding unique solutions, and
we speed up the algorithm immensely. In the worst case, only one thread does
useful work and the other threads find only duplicate solutions. This wasted
work is acceptable for our purposes, since we want to reduce the total time
between the start and finish of the program. Since the wasted work is done in
parallel, OGIA is no worse<sup><a href="#n2" id="t2">2</a></sup> than GIA.


Implementation details
----------------------

As described above, the idea behind OGIA is rather straightforward. However,
there are many implementation details to consider.

For example, we need a way to identify duplicate solutions so that we never
yield the same solution twice. We also want to be smart about our _magnifier
task_<sup><a href="#n3" id="t3">3</a></sup> --- if we can easily identify
duplicate solutions, then there is no point having multiple threads run the
magnifier task on the same Pareto point. To do this, we have a _solution
deduplicator_<sup><a href="#n4" id="t4">4</a></sup> that keeps track of all the
Pareto points found, and also maintains the _global exclusion
constraints_<sup><a href="#n5" id="t5">5</a></sup>.

When a thread finds a Pareto point, it reports it to the solution deduplicator.
If the Pareto point is a new solution, the thread adds a magnifier task for that
Pareto point to the task queue<sup><a href="#n6" id="t6">6</a></sup>. Next,
whether we have a duplicate or not, the thread asks the solution deduplicator
for the updated global exclusion constraints to find a new starting solution.

Thus, the solution deduplicator is responsible for keeping the set of unique
Pareto points found, and informing threads if the solution they found was
a duplicate or not. Since a magnifier task is queued only once per Pareto point,
we can be sure that the magnifier tasks will not waste any work.

Below, I've listed some pseudocode for the solution deduplicator. Our
implementation is thread-safe, but I have omitted those details from the
pseudocode.

    #!ruby
    SolutionDeduplicator:
        globalExclusionConstraints = empty
        solutionHashTable = empty

        # Called when a thread has found a new solution.
        PushNewSolution(solution)
            if solutionHashTable.contains(solution)
                # We have a duplicate solution
                return false
            else
                # Not a duplicate, so add the solution.
                solutionHashTable.add(solution)
                # Update global exclusion constraints.
                globalExclusionConstraints = globalExclusionConstraints AND
                                             not dominated by solution
                return true
            end
        end

Here is how we have modified the double-nested loop from GIA, and packaged it as
a solution finder task for the OGIA threads.

    #!ruby
    SolutionFinder(solution):
        while solution exists
            # Climb up to the Pareto front.
            while solution exists
                prevSolution = solution
                # Find a better solution.
                solution = Solve(problemConstraints AND dominates prevSolution)
            end
            # Nothing dominates prevSolution; it's a Pareto point.
            # Report to the solution deduplicator.
            isUniqueSolution = PushNewSolution(prevSolution)
            # Queue magnifier task if solution was unique.
            if isUniqueSolution
                tasks.queue(Magnifier(solution))
            end
            # Throw the dart. Find a new solution.
            solution = Solve(problemConstraints AND globalExclusionConstraints)
        end

This was the idea for our first implementation. However, we discovered a serious
problem: all the threads would start at the same starting solution, and then
find the same better solutions. Apart from the magnifier tasks, only one thread
was doing useful work. There was almost no improvement over the single-threaded
GIA.

While the idea to fix this problem was straightforward --- have each thread find
a different starting solution --- the actual implementation was less so.
Originally, we had hoped that the non-determinism in our SAT solver would find
different starting solutions, but this was not the case. We were also
unsuccessful in forcing this behaviour with different random seeds. In the end,
our only option was to find starting solutions in sequence, allowing us to use
exclusion constraints from the previous solutions. Unfortunately, this means we
have some unavoidable sequential work at the beginning of the algorithm.

Here is the initialization code from the main thread, which is responsible for
finding the starting solutions and starting the other worker threads.

    #!ruby
    Main:
        tasks = empty
        intialPointConstraint = problemConstraints

        for 1..numberOfThreadsToUse
            # Get a unique starting point.
            solution = Solve(initialPointConstraint)
            if solution exists
                initialPointConstraint = initialPointConstraint AND
                                         not dominated by solution
                # Queue a solution finder task.
                tasks.queue(SolutionFinder(solution))
            end
        end

        # Wait until all threads have finished.
        tasks.wait

For the full implementation details, you can find our code on [GitHub][ogia].

[ogia]: https://github.com/TeamAmalgam/kodkod/pull/36


Preliminary results
-------------------

Here is the table from last time, with OGIA results added, and GIA results
removed, since our new work is built on top of IGIA. Recall that IGIA uses
incremental solving, while CGIA uses checkpointed solving. Again, these are
informal test results, run on the undergraduate computer science servers.

<table style="border-collapse:separate;border-spacing:10px;margin:0px auto;border:1px">
  <thead>
    <tr>
      <th><!-- empty --></th>
      <th>IGIA</th> <!-- 1da4839 -->
      <th>CGIA</th> <!-- 13ab50f -->
      <th>OGIA</th> <!-- 8eaa3d6 -->
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9 queens, 5 metrics</td>
      <td>2 hours, 0 min</td>
      <td>51 min</td>
      <td>50 min</td>
    </tr>
    <tr>
      <td>9 queens, 6 metrics</td>
      <td>4 days, 16 hours, 43 min</td>
      <td>1 hour, 39 min</td>
      <td>1 hour, 53 min</td>
    </tr>
    <tr>
      <td>9 queens, 7 metrics</td>
      <td>Never attempted<sup><a href="#n7" id="t7">7</a></sup></td>
      <td>3 hours, 37 min</td>
      <td>4 hours, 4 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 5 metrics</td>
      <td>3 hours, 0 min</td>
      <td>1 hour, 26 min</td>
      <td>2 hours, 38 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 6 metrics</td>
      <td>2 hours, 8 min</td>
      <td>59 min</td>
      <td>1 hour, 11 min</td>
    </tr>
    <tr>
      <td>Search and rescue, 7 metrics</td>
      <td>5 hours, 1 min</td>
      <td>2 hours, 16 min</td>
      <td>2 hours, 46 min</td>
    </tr>
  </tbody>
</table>
<br />

Once again, we see a dramatic improvement over IGIA. Interestingly, CGIA,
a single-threaded approach, performs better than OGIA, a multi-threaded
approach. However, in the same way we built OGIA on top of IGIA, we can build
OGIA on top of CGIA.


Future work
-----------

At the time of writing, we have four open issues to explore.

As noted above, we can build OGIA on top of CGIA. This would seem to be a very
easy way of getting significant improvements, but the situation is actually more
complicated. Both CGIA and OGIA greatly increase the algorithm's memory usage.
We would probably have to reduce memory usage, before we could combine and use
both of them effectively.

The next issue is how we queue up magnifier tasks. Due to our implementation,
the magnifier tasks do not run until all the (unique) Pareto points have been
found<sup><a href="#n8" id="t8">8</a></sup>. This is not a serious problem, but
a nice property of GIA is that it yields solutions as they are found. With the
magnifier tasks deferred, we lose this property, and do not yield solutions
until the first magnifier task runs. We should be able to fix this easily, by
prioritizing magnifier tasks over the solution finder tasks.

Another minor issue is that the algorithm waits until every thread has finished,
meaning we are as fast as the slowest thread. However, we can do better than
this. If a solution finder task fails to find a new starting solution, then this
means all Pareto points have been found. The other solution finder tasks are
either trying to find a new starting solution (in which case, they will fail
like the first task), or they are climbing up to a Pareto point (which will be
a duplicate, since no new Pareto points exist). Therefore, we can cancel the
other solution finder tasks.

The final issue is much more open-ended. Our group has noticed that, even with
our dramatic improvements, there is still a lot of wasted work. Reducing this
wasted work could improve OGIA even more.

One idea we want to explore is how we handle the global exclusion constraints.
Currently, these constraints are based on the set of (known) Pareto points. We
suspect that since it can take a long time before Pareto points are found, the
global exclusion constraints are not updated frequently enough. This leads to
other tasks using "stale" information and performing duplicate work. If the
global exclusion constraints were based on non-optimal solutions, they would be
updated more frequently, and other threads would have "fresher" information.


Conclusion
----------

In this post, I described the _overlapping guided improvement algorithm_,
highlighted some of its implementation details, and discussed some of the open
issues our group will be addressing in the future.

In the [next part][fydp5], I will be discussing our other multi-threaded
approach, the _partitioned guided improvement algorithm_. It lets us eliminate
all the duplicate work we had with OGIA, but the price is a far more complicated
algorithm.

_I would like to thank Chris Kleynhans, Zameer Manji, and Arjun Sondhi for
proofreading this post._

[fydp5]: /blog/fydp5.html

Notes
-----

  1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> Loosely put,
     a thread is a portion of a program that can be executed concurrently with
     other portions of the program. On a multi-core processor, each core can
     execute a separate thread simultaneously. In contrast, a single-core
     processor must switch between the different threads. With a multi-threaded
     approach, we can run portions of the program in parallel.

  2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> There will be
     some overhead when we check for duplicates. However, this is a very cheap
     operation.

  3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> Recall that
     multiple solutions may exist at the same Pareto point. The magnifier task
     examines a Pareto point and yields all the solutions at that point.

  4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> The solution
     deduplicator is backed by a hash table, which means adding solutions and
     checking for duplicates is extremely cheap.

  5. <a style="text-decoration: none;" id="n5" href="#t5">^</a> Recall that in
     GIA, when a Pareto point is found, the exclusion constraints are updated so
     that new starting solutions are not dominated by the existing Pareto
     points. We do the same thing here, except that the exclusion constraints
     are based on all Pareto points found, not just the ones found by the
     current thread.

  6. <a style="text-decoration: none;" id="n6" href="#t6">^</a> When a thread is
     finished its task, it will check the queue for a new task. As a result,
     magnifier tasks are deferred until all Pareto points have been found.

  7. <a style="text-decoration: none;" id="n7" href="#t7">^</a> IGIA had very
     little improvement over GIA for the 9-queens problems, so we never attempted
     this case.

  8. <a style="text-decoration: none;" id="n8" href="#t8">^</a> Recall the
     argument for GIA: the starting solution must not be dominated by any
     existing Pareto point. If we cannot find such a solution, then all
     solutions are either Pareto points or dominated by existing Pareto points.
