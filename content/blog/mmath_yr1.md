---
created_at: 2015-08-25
excerpt: ""
kind: article
tags: [ mmath masters grad school ]
title: "Graduate School: Year One"
---

It's been about a year since I started grad school, so this seemed like a good
opportunity to collect some of my thoughts. It'll be fun to look back at this
post years in the future, and as an added bonus, I can refer friends here when
they want to know what I've been doing in grad school. But before I start,
I think it's worth briefly explaining why I chose grad school, and also what
grad school actually is.


Why Graduate School?
--------------------

Broadly speaking, graduate school is a school where a further degree is earned
(such as a master's or a doctoral degree), where a requirement is that the
student has already earned a bachelor's degree from an undergraduate program. We
can also broadly distinguish between two types of graduate school: the
course-based degree, and the research-based degree.

In a course-based degree, students generally pay a tuition and take a number of
courses. The main goal is to _consume_ knowledge, and some examples include law
school, medical school, or course-based master's degree. On the other hand, in
a research-based degree, students are paid to do knowledge, in other words, to
_produce_ knowledge. The Ph.D. is the best example of a research-based degree,
though a master's degree can also involve research. In this post, whenever I say
"graduate school" or "master's degree," I'm referring to the research-based
degree.

In Canada, a master's degree can be either a course-based degree or
a research-based degree. The research master's degree is typically a requirement
for starting a Ph.D. program. In the United States, most master's degrees are
from course-based programs, and students wanting to do research apply directly
to a Ph.D. program, where a master's is earned "on the way" to getting a Ph.D.

I'm currently enrolled in a research-based master's program in computer science
at the University of Waterloo. I'm often asked why I chose to pursue graduate
studies instead of taking an industry job, and the answer is a combination of
multiple reasons of varying importance.

For me, I think the practical reason for grad school is that it expands my
opportunities, opening the possibility for a job in academia. If I want to do
research (whether in a corporate or academic environment) or university-level
teaching, I'll need a Ph.D. At the same time, I still have the experience from
my undergraduate internships to apply to, interview for, and succeed at industry
jobs. But if I entered industry directly after undergrad, I think it'd be more
difficult to go back to school and then pursue a job in academia.

A related reason is that I wanted to experience something different, and
ultimately determine if I preferred industry or academia more. I did my
undergraduate studies in software engineering, also at Waterloo, and that
included six different internships, for a total of two years of work experience.
That's given me a good idea of what industry jobs are like, especially since
I interned at startups and large companies, and worked on web applications and
compilers. On the other hand, my research experience was limited to a summer
internship, a course project, and some part-time work. By doing a master's,
I could get a more thorough experience of academia.

Last, but not least, I enjoyed my undergraduate research projects, and also the
academic environment. I was excited about the work I was doing and wanted to
continue (though in a different subfield). I also enjoyed working in industry,
but again, I wanted to spend more time getting a clearer sense of academia.

Now, there's also two "non-reasons" for graduate school I want to quickly
mention. In the software field, a graduate degree is unlikely to improve one's
starting salary in an industry job. In fact, the time commitment for a Ph.D.
usually means you would be worse off financially. The second non-reason is the
joke that graduate students simply want to continue being students because they
can't find "real" jobs. This is not the case for me: I am pursuing graduate
studies because I consciously made the choice and genuinely want to. I had the
qualifications and experience to secure a full-time job after graduation, like
many of my classmates. (In the end, I did a summer internship between graduation
and starting my master's.)

So far, I've only talked about my thoughts from _before_ graduate school, so
let's move on to what I actually did in my first year of my master's.


Student, Teaching Assistant, and Researcher
-------------------------------------------

Generally speaking, a graduate student's responsibilities fall into three main
categories: student, teaching assistant, and researcher.


### Life as a Student

My degree program requires me to take four courses, each lasting a four-month
term. I took two courses in my first term (September to December) and the
remaining two in my second term (January to April). I also informally audited
a course in my third term (May to August).

The first two courses I took were "Software Foundations" and "Advanced Data
Structures." Software Foundations is based on the textbook of the same name. To
quote the textbook, the course is about "the mathematical underpinnings of
reliable software." The idea is that writing software is hard, and so is
mathematically _proving_ that the software is correct. One way to do this is to
use Coq, a proof assistant. We write our proofs out in the Coq programming
language, and then Coq can check and verify if our proof is actually correct.
(The theory behind this is something called the Curry-Howard correspondence,
which states that there's a relationship between computer programs and
mathematical proofs.) The course also touches other topics such as logic,
functional programming, program verification, and type systems.

This was a very interesting course. (Unfortunately, it was at 8:30 in the
morning twice a week.) We just had lectures and assignments. There were no
assigned paper readings, projects, presentations, or exams. The assignments
could be time-consuming, especially since they were weekly. But each assignment
involved writing proofs in Coq, so it actually ended up being fun rather than
overbearing. It was like a combination of solving puzzles, writing math proofs,
and programming code, with the added bonus that Coq would tell you if your proof
was correct or not.

My second course that term was advanced data structures. We covered topics such
as van Emde Boas trees, cache-oblivious data structures, self-organizing linear
search, splay trees, and succinct data structures. We had lectures, assignments,
and a course project (which involved a report and a presentation). The
assignments were basically reading assigned papers and then reviewing them.
I ended up doing my project on range minimum query -- I read a few papers,
implemented their algorithms, and then evaluated them.

Overall, I found the course to be interesting, but difficult. Fortunately, the
workload wasn't too bad. Algorithms and data structures isn't the subfield I'm
specializing in, and I think I didn't have a strong enough background -- taking
a second undergraduate algorithms course would have helped.

In the winter term, my two courses were "Virtual Machines for Dynamic Languages"
and "Formal Languages and Parsing." In the first course, "dynamic languages"
meant we focused on languages like JavaScript and Lua, and not Java (which has
the Java Virtual Machine and a just-in-time compiler, but the language isn't
dynamic). This was a seminar course, so besides lectures, we also had student
presentations and paper discussions. We also had assignments and a final
project.

This was my first seminar course, which is something I never encountered as an
undergraduate course. In a seminar course, a paper is assigned in advance of
each class, so that students can read the paper before coming to class, and then
everyone can discuss it. Each student is also required to prepare a presentation
for one of the papers. It's an interesting experience, especially since we're
all reading and discussing research from the past few years. The discussions
were also interesting in this particular course, since there were only five
students. Overall, I enjoyed the course. The workload was fairly light, though
the final project was an open-ended implementation project, so I spent a lot of
time on it. My project was to add optional type annotations and optimizations to
a toy language that represented a subset of JavaScript.

In contrast, my other course that term was very theoretical. It was about
formal languages and automata theory, in other words, the mathematics of
_computation_. This was actually fourth-year undergraduate course, but graduate
students taking it had to do an additional project. This was on top of the
weekly assignments and final exam that everyone had.

The lectures were some of the most interesting ones I've ever had. The professor
was one of the best lecturers I've had, and almost every class, I would walk out
in amazement. Unfortunately, I can't really say the same about the weekly
assignments. They were also interesting, and some of them were fun to work on,
but I can't say I enjoyed the entire experience. These assignments were all
proofs, and I would frequently get stuck and be unable to see the crucial step
that allowed me to solve the problem. It was very frustrating and exhausting,
especially since I spent an average of fifteen (or more) hours per week, and the
new assignment would be released hours after handing in the old one.

The final exam was a take-home exam. We would pick up the exam and then be given
exactly one week (168 hours) to return it. We could use any notes, books,
or papers, as long as we cited our sources, but any form of collaboration or
discussion was forbidden. This was a new experience for me, and I found it an
improvement over the standard two-and-a-half hour exam, since it can take some
time to work out proofs. It also helped that I was able to clear out an entire
week to focus on the exam, but most of the undergraduate students would have had
other exams to study for and write.

By this point, I had completed all of my course requirements. However, there was
a course being offered in the spring term that I was interested in. I didn't
want to officially enroll, so I could focus on my research project, and since
I had fulfilled my course requirements, I didn't need to enroll. Instead, I just
sat in on the lectures, with approval from both the instructor and my
supervisor.

The course was called "Advanced Compiler Design," but it was really about static
analysis and compiler optimizations. I attended all the lectures (which were
awkwardly scheduled once a week, from 10:30 to 1:30 and overlapping lunch), read
the assigned papers, and worked on the assignments on my own. However, I didn't
submit anything, and I didn't do the project either. Out of all the courses
I took last year, this was the most relevant to my research project. The only
problem was that the earlier course topics were things I learned on my own while
working on my research project. It would have been nice if I took the course
much earlier, but the schedule just didn't work out.

Now, going into the second year of my master's, I've completed all my courses
and can focus on my research. Some of the courses being offered next year seem
a little interesting, but probably not enough for me to sit in on them.

I've also learned a little more about my own interests, while taking these
courses. As an undergraduate student, I enjoyed both working with
implementations as well as with theory. But it's now much clearer to me that I'm
much more comfortable with implementation than I am with theory. I also realized
that while I find algorithms to be interesting, they don't quite click with me
the same way my main research interest (compilers, programming languages, and
static analysis) does. Both of these facts are good to know, as I have a better
idea of what sort of research projects I'd want to work on.


### Life as a Teaching Assistant

I didn't have any TA units in my first two terms, because I was "bought out" by
my supervisor. This means that instead of being paid to do a TA unit, my
supervisor pays the equivalent amount so I can focus on courses and/or research
instead of TA work.

My first TA unit was in the spring term, and I requested (and was assigned)
a second-year intro to compilers course. I had taken this course as an
undergraduate student, and it's one of my favourite courses. The TA workload is
actually very low for this course -- tutorials and office hours were handled by
other TAs, so I only had to help with marking assignments and proctoring and
marking exams.

All the assignments are programming and can be computer-marked, but two of them
are hand-marked for coding style. It was slow and tedious at first, but
I eventually got the hang of it and was able to mark faster. On average, it took
me about ten to fifteen minutes for each student submission, which works out to
about five hours to mark my entire set. For reference, TAs are expected to spend
five hours per week on their duties.

There's not very much to say about the actual marking. Most of the submissions
were what you'd expect from a second-year student, with a lot of hastily-written
code thrown together. A short list of common coding style issues would cover
80-90% of the assignments. It was also interesting to see how some students
would model the problem in a completely different way, and thus write code that
was a little difficult to decipher.

Proctoring exams was an interesting experience. There's protocols and
procedures, such as setting out all the exams, letting students in at the
correct time, collecting signatures on the attendance sheet, escorting students
to the washroom, answering questions, and then collecting exams at the end. (For
this course, answering questions involved giving students a form to write their
question, delivering the form to the instructor to write a response, and then
delivering it back to the student.) But the main responsibility of the proctor
is to walk around to room and make sure people aren't cheating. Unfortunately,
this is a pretty boring task, and we can't bring books to read, since that
defeats the purpose of proctoring. I also found the entire process to be
surprisingly tiring -- I ended up pacing around the room for the entire
two-and-a-half hour period (plus the half hour of setup beforehand), and there
were very few opportunities to sit down and rest.

We marked the exams shortly afterwards. A "marking meeting" is scheduled where,
for the entire day (we started at 9:30 and finished by 5:30), the instructor(s)
and TAs sit down in a room and go through all the exams. Each marker is assigned
a question, which provides consistency to the marking. The instructor provides
an answer key, and can also answer questions if we're unsure of how many marks
to assign.

Some questions are easier to mark, others are more difficult. The more difficult
questions are the ones where there are different ways of answering the question,
most of which aren't included in the answer key. We also have to try to decipher
incorrect answers, so we can award partial marks.

Now, all of this is only what we did for a particular course. TA duties will be
different depending on the course. In this case, it was a large course (with
about 200 students) with multiple TAs. Upper-year courses are usually smaller,
with fewer students and TAs (and thus more work for those few TAs).

As a TA, I haven't done any actual teaching yet (in, for example, a tutorial).
I might get a chance later, which will be nice, since I can determine if
teaching is something I like doing.


### Life as a Researcher

It was difficult to manage my time and balance research with coursework in my
first two terms. It improved a little by the winter term, where I slowly but
steadily made progress, but I had to put research on hold near the end, to focus
on final course projects and exams. By the spring term, when I no longer had any
courses, I could then focus on research.

It didn't help that my supervisor was, and still is, on sabbatical. My
supervisor will be back this fall, and while we can meet over Skype or phone
calls or email, it's still a little awkward. My supervisor is in Europe, so the
timezones make scheduling a little tricky. And whenever I have a question,
I can't just go knock on my supervisor's door. I have to send an email and wait
for a reply, and if it's too late, I don't get a response until the next day.
But we've managed to make it work so far.

There's not too much to say about my research project, without getting too
technical. But it's a static analysis framework created by my supervisor and
another student (now a postdoctoral researcher). It took a while to get ramped
up, because I didn't know anything about static analysis before I started (this
is where a course would have helped), and the entire project was also
implemented in Scala, a language I had no experience with.

But it's a lot smoother now, and I'm enjoying both the work and writing code
Scala. Without going into too much detail, I'm currently implementing a code
generator for a domain-specific language. There's a lot of coding, which is
great because I like writing code.

If I were to compare this to my industry internships, I'd say there's a lot of
similarity (at least, right now). I'm writing code, so I also need to think
about how it's structured and designed, and also write tests. Like in industry,
there's also a lot of prototyping and exploring different libraries and
approaches. The biggest difference is that overall, research code is more of
a prototype than it is a final product. The trick is finding the right balance
between quickly-written and easily-maintainable code.

I haven't really discussed other aspects of research, because writing code is
mainly what I've been working on. But I should at least mention reading papers.
This is actually what I did on my first day of graduate school. I didn't have
any coursework yet, and I didn't have a research project, so I started reading
papers to both learn about what's current in the research community, and to get
ideas for my own research project. Reading a paper is a very difficult task, as
papers are incredibly dense and detailed. I found that to fully understand
a ten-page paper, I have to spend about five hours on it.


And Everything Else
-------------------

In this final section, I'd like to discuss everything else that doesn't neatly
fit anywhere else.

Starting with the facilities, I have a desk in one of the graduate student labs.
Sometimes I refer to it as an "office," even though I'm sharing the room with
three other students. There's a door that connects it to other rooms (or
offices) of the entire lab. Graduate students also have access to a mail and
photocopier room, and the graduate student lounge, which has tables, couches,
a TV, microwaves and coffee machines.

I was also provided a computer, and I was given the option of a desktop or
a laptop, and it could be a Mac, or a PC dual-booting Ubuntu and Windows.
I chose a desktop, and it's running Windows 7 and Ubuntu 12.04. (Apparently it
takes time for IT to get software tested and properly working on the network.)
In terms of performance, the computer's pretty powerful (16 GB of RAM,
eight-core AMD FX-8320 clocked at 3.5 GHz, and a 1 TB hard drive). I also have
access to more powerful servers, if I need them for experiments.

Besides working on a day-to-day basis, other things usually come up. These could
be meetings (either with my supervisor, or with the entire research group, or
a TA meeting) or presentations (faculty candidates, research presentations,
or guest speakers). My research group also meets every week, and we alternate
between going out for lunch, or having presentations and discussions.

Occasionally, there are also social events for all the graduate students,
faculty, and staff. For example, we get gelato every month, and it's also
a chance to chat with people from other research groups. There was also
a pumpkin carving contest last October, and one of those contests where you
build towers out of spaghetti and marshmallows.

One thing I've been asked is what it's like doing both my bachelor's and
master's degrees at the same university. A lot of things are convenient, such as
being familiar with the city and the university. Knowing where things are, how
administrative things work (such as enrolling in courses). Some of my friends
are still in the city (whether because they've graduated and are working here,
or because they're still undergraduates). It was also convenient when I was
considering offers -- it was easy to meet and chat with potential supervisors,
instead of having to take an entire day trip to a different city. Overall,
I think the familiarity meant it was easier to settle into my new role as
a graduate student.

Another side effect of returning is that I was able to continue some of my
undergraduate activities. I still write for mathNEWS, and I'm continuing my
membership in the quizbowl club. If anything, I'm more involved with quizbowl
now -- I've been attending more tournaments, and have been directing the
tournaments our club hosts.

On the more academic side of things, I was able to stay involved with stuff
related to the fourth-year design project. Before graduating, my group had
started working towards another paper submission, and my intent was to continue
after graduation. Returning to my university meant it was much easier to
collaborate and finish the project, and now the paper has been submitted and
we're waiting to hear back. If I attended a different university, collaboration
would still have been possible, though more difficult.

Also related to FYDP is my role as an alumnus. Every March, a symposium is held
and the projects are refereed. Local alumni are invited as referees, since we've
done our own projects and know what to look for. And, as usual, it's a great
chance to see the cool projects other students have worked on.


What's Next?
------------

Well, it's now been a year since I started, and I have roughly another year
left. My course requirements are done, so now I can focus on my research
project and also my actual thesis. I'm TAing a course in the fall, and will
probably TA another one in the winter. My supervisor will be back from
sabbatical.

And I'll also have to prepare for after my master's. Whether I go into industry
and get a job, or continue in academia as a Ph.D. student, I'll need to prepare
for applications and interviews.

Year one flew by pretty quickly. Let's see how year two fares.
