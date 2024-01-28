---
title: Capstone Design Project
---

Capstone Design Project
=======================

The Capstone Design Project, also known as the fourth-year design project
(FYDP), is a mandatory three-course sequence in the [software
engineering][softeng] program at the [University of Waterloo][uw]. It spans
twenty months, and is to be completed in groups of four undergraduate students.

My group, "Team Amalgam" (Joseph Hong, Chris Kleynhans, Atulan Zaman, and
myself) worked under the supervision of Professor [Derek Rayside][rayside], from
approximately September 2012 to April 2014. Our project was to optimize the
[guided improvement algorithm][gia], which is used to solve exact, discrete,
multi-objective optimization problems.

On March 21 2014, a public symposium was held for all the projects done by the
software engineering class of 2014. Each group had a booth with a poster and
a demo, and gave a twenty-minute presentation about their project.

The sponsor selected our group, Team Amalgam, for first place.

I have a series of blog posts explaining the background for our project, as well
as describing the work we have been doing.

* [Introduction, Definition, and Applications][fydp1]
* [A More Formal Definition][fydp2]
* [The Guided Improvement Algorithm][fydp3]
* [The Overlapping Guided Improvement Algorithm][fydp4]
* [Attempting the Partitioned Guided Improvement Algorithm][fydp5]
* [Fixing the Partitioned Guided Improvement Algorithm][fydp6]

[softeng]: https://uwaterloo.ca/software-engineering/
[uw]: https://uwaterloo.ca
[rayside]: https://ece.uwaterloo.ca/~drayside/
[gia]: https://dspace.mit.edu/handle/1721.1/46322

[fydp1]: fydp1.html
[fydp2]: fydp2.html
[fydp3]: fydp3.html
[fydp4]: fydp4.html
[fydp5]: fydp5.html
[fydp6]: fydp6.html


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

* [Symposium poster][se491poster]
* [Symposium slides][se491slides]

## Publications

* E. Zulkoski, C. Kleynhans, M.-H. Yee, D. Rayside, K. Czarnecki, [Optimizing
  Alloy for Multi-objective Software Product Line Configuration][abz14], ABZ
  2014, June 2014. (Link at [Springer][abz14springer])
* M. Safa, M.-H. Yee, D. Rayside, C. T. Haas, [Optimizing Contractor Selection
  for Construction Packages in Capital Projects][jcce16], ASCE Journal of
  Computing in Civil Engineering, January 2016.

[se390research]: https://github.com/TeamAmalgam/documents/blob/master/SE390/researchplan/main.pdf
[se390spec]: https://github.com/TeamAmalgam/documents/blob/master/SE390/specification/main.pdf
[se390test]: https://github.com/TeamAmalgam/documents/blob/master/SE390/testplan/main.pdf
[se390demo]: https://github.com/TeamAmalgam/documents/blob/master/SE390/presentation.pdf
[se390demogdoc]: https://docs.google.com/presentation/d/1zGx1J5eHd4aAshjmRSfFBRAD9i_n32bpyGt5Xqr1JOk/edit?usp=sharing

[se490demo1]: https://github.com/TeamAmalgam/documents/blob/master/SE490/demo1.pdf
[se490demo1gdoc]: https://docs.google.com/presentation/d/16wXxuOZ4Jini0sNlmOmRGqngEkKTX4QYpKaMHFR3CoQ/edit?usp=sharing
[se490demo2]: https://github.com/TeamAmalgam/documents/blob/master/SE490/demo2.pdf
[se490demo2gdoc]: https://drive.google.com/file/d/0Bw3yzRqsO67VNXYwVzA4ZUxQVjA/view?usp=sharing&resourcekey=0-qtsGIuTAMjvr8kRgFxBSLQ
[se490demo3]: https://github.com/TeamAmalgam/documents/blob/master/SE490/demo3.pdf
[se490demo3gdoc]: https://docs.google.com/presentation/d/19AytM9VRAyXCwEt-K3wo2y_gZA9h0dX5RGBPBC7cg_s/edit?usp=sharing

[se491poster]: https://github.com/TeamAmalgam/documents/blob/master/SE491/poster.pdf
[se491slides]: https://github.com/TeamAmalgam/documents/blob/master/SE491/slides.pdf

[abz14]: https://gsd.uwaterloo.ca/publications/view/569.html
[abz14springer]: https://doi.org/10.1007/978-3-662-43652-3_34
[jcce16]: https://doi.org/10.1061/(ASCE)CP.1943-5487.0000555


Test Infrastructure
-------------------

We have unit tests running on Travis CI.

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

[sinatra]: http://sinatrarb.com/
[heroku]: https://www.heroku.com/
[s3]: http://aws.amazon.com/s3/
[sqs]: http://aws.amazon.com/sqs/
[hipchat]: https://en.wikipedia.org/wiki/HipChat


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

The [results][] repository contains the raw experimental data we collected for
the ABZ publication.

The [demo][] repository holds the software for running our symposium day demo.
Essentially, different versions of the algorithm race against each other, and
results are plotted in real-time.

[github]: https://github.com/TeamAmalgam
[moolloy]: https://github.com/TeamAmalgam/moolloy
[kodkod]: https://github.com/TeamAmalgam/kodkod
[dashboard]: https://github.com/TeamAmalgam/dashboard
[worker]: https://github.com/TeamAmalgam/worker
[test-models]: https://github.com/TeamAmalgam/test-models
[documents]: https://github.com/TeamAmalgam/documents
[results]: https://github.com/TeamAmalgam/results
[demo]: https://github.com/TeamAmalgam/demo

[alloymit]: https://www.csail.mit.edu/research/alloy
[kodkodmit]: https://emina.github.io/kodkod/
[minisat]: https://github.com/niklasso/minisat
