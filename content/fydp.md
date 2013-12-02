---
title: Fourth-Year Design Project
---

Fourth-Year Design Project
==========================

_The views expressed on this page and on my blog are my own; I do not speak on
behalf of my group._

The fourth-year design project (FYDP) is a mandatory three-course sequence in
the [software engineering][softeng] program at the [University of Waterloo][uw].
It spans twenty months, and is to be completed in groups of four undergraduate
students.

My group is working under the supervision of Professor [Derek Rayside][rayside]
to optimize the [guided improvement algorithm][gia], which is used to solve exact,
discrete, multi-objective optimization problems.

I have a series of blog posts explaining the background for our project, as well
as describing the work we have been doing.

* [Introduction, Definition, and Applications][fydp1]
* [A More Formal Definition][fydp2]
* [The Guided Improvement Algorithm][fydp3]
* [The Overlapping Guided Improvement Algorithm][fydp4]
* [Attempting the Partitioned Guided Improvement Algorithm][fydp5]
* Fixing the Partitioned Guided Improvement Algorithm
* ...
* TBD: Results?

[softeng]: http://www.softeng.uwaterloo.ca
[uw]: http://www.uwaterloo.ca
[rayside]: https://ece.uwaterloo.ca/~drayside/
[gia]: http://dspace.mit.edu/handle/1721.1/46322

[fydp1]: /blog/fydp1.html
[fydp2]: /blog/fydp2.html
[fydp3]: /blog/fydp3.html
[fydp4]: /blog/fydp4.html
[fydp5]: /blog/fydp5.html


Test Infrastructure
-------------------

We have unit tests running on [Travis CI][travis].

However, many of our tests take a long time to run, and besides correctness, we
are interested in seeing how long it takes for our tests to run. We also want to
track our progress in making the algorithms run faster.

This is why we designed and built custom infrastructure: the [dashboard][]. It
is built with [Sinatra][] and runs on [Heroku][].

From the dashboard, we can upload test models to [Amazon S3][s3], request test
runs via [Amazon SQS][sqs], view our test results, and view the status of our
workers. (Actually, we find it easier to request tests from the console instead
of the web interface.)

Our workers, written in Ruby, run on the undergraduate computer science servers.
When a job is received from SQS, they download the test model from S3 and the
code from GitHub, build the project, and then run the tests. The workers will
make POST requests to the dashboard, with events such as registrations and
unregistrations, start and completion of tests, and heartbeats.

Finally, the dashboard is integrated with GitHub and [HipChat][hipchat]. When we
commit to the master branch of the moolloy repository, the dashboard is notified
and initiates a number of short-running tests, as part of our continuous
integration. The dashboard also sends messages to HipChat, so we get
notifications of events.


[travis]: https://travis-ci.org/TeamAmalgam/kodkod
[dashboard]: http://amalgam.herokuapp.com/

[sinatra]: http://www.sinatrarb.com/
[heroku]: https://www.heroku.com/
[s3]: http://aws.amazon.com/s3/
[sqs]: http://aws.amazon.com/sqs/
[hipchat]: https://www.hipchat.com/


Documents
---------

As the fourth-year design project is a three-course sequence, we have had to
prepare documents and presentations. I have consolidated the download links for
all of our documents and slides.

### SE 390

* [Research plan][se390research]
* [Requirements specification][se390spec]
* [Test plan][se390test]
* [Presentation][se390demo] ([Google Docs][se390demogdoc])

### SE 490

* [Initial presentation][se490demo1] ([Google Docs][se490demo1gdoc])
* [In-class presentation][se490demo2] ([Google Docs][se490demo2gdoc])
* [Final presentation][se490demo3] ([Google Docs][se490demo3gdoc])

### SE 491

* TBD

[se390research]: https://github.com/TeamAmalgam/documents/raw/master/SE390/researchplan/main.pdf
[se390spec]: https://github.com/TeamAmalgam/documents/raw/master/SE390/specification/main.pdf
[se390test]: https://github.com/TeamAmalgam/documents/raw/master/SE390/testplan/main.pdf
[se390demo]: https://github.com/TeamAmalgam/documents/raw/master/SE390/presentation.pdf
[se390demogdoc]: https://docs.google.com/presentation/d/1zGx1J5eHd4aAshjmRSfFBRAD9i_n32bpyGt5Xqr1JOk/edit?usp=sharing

[se490demo1]: https://github.com/TeamAmalgam/documents/raw/master/SE490/demo1.pdf
[se490demo1gdoc]: https://docs.google.com/presentation/d/16wXxuOZ4Jini0sNlmOmRGqngEkKTX4QYpKaMHFR3CoQ/edit?usp=sharing
[se490demo2]: https://github.com/TeamAmalgam/documents/raw/master/SE490/demo2.pdf
[se490demo2gdoc]: https://drive.google.com/file/d/0Bw3yzRqsO67VNXYwVzA4ZUxQVjA/edit?usp=sharing
[se490demo3]: https://github.com/TeamAmalgam/documents/raw/master/SE490/demo3.pdf
[se490demo3gdoc]: https://docs.google.com/presentation/d/19AytM9VRAyXCwEt-K3wo2y_gZA9h0dX5RGBPBC7cg_s/edit?usp=sharing


Code Repositories
-----------------

Most of our code can be found on [GitHub][github].

[Moolloy][moolloy] is our implementation. The repository is simply a "parent
project" which uses Git submodules to keep the "child projects" in sync. The
child projects are modified versions of [Alloy][alloymit] and
[Kodkod][kodkodmit]. We do not own the Alloy code base and it is not publicly
available, which is why we do not have it on GitHub.

Essentially, Alloy is the "front-end" and [Kodkod][kodkod] is the "back-end"
where the algorithms are actually implemented. Our version of Alloy takes in
multi-objective optimization problems expressed in modified Alloy syntax,
compiles it down to Kodkod, which then solves it by calling into a SAT solver.
We're currently using [MiniSat][minisat].

The [dashboard][], [worker][], and [test-models][] repositories collectively
form our test infrastructure.

The [documents][] repository is self-explanatory.

[github]: https://github.com/TeamAmalgam
[moolloy]: https://github.com/TeamAmalgam/moolloy
[kodkod]: https://github.com/TeamAmalgam/kodkod
[dashboard]: https://github.com/TeamAmalgam/dashboard
[worker]: https://github.com/TeamAmalgam/worker
[test-models]: https://github.com/TeamAmalgam/test-models
[documents]: https://github.com/TeamAmalgam/documents

[alloymit]: http://alloy.mit.edu/alloy/
[kodkodmit]: http://alloy.mit.edu/kodkod/
[minisat]: http://minisat.se/
