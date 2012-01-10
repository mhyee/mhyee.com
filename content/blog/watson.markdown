---
created_at: 2011-02-10
foo: bar_
excerpt: Fifteen years ago on this day, IBM's Deep Blue defeated Garry Kasparov, quite possibly the greatest chess grandmaster in history.
kind: article
tags: [ watson, jeopardy, trivia ]
title: "Thoughts on IBM's Watson"
---

Fifteen years ago on this day, IBM's Deep Blue defeated Garry Kasparov, quite possibly the greatest chess grandmaster in history. (Kasparov went on to win the tournament, but lost against an upgraded version of Deep Blue a year later.) In four days, IBM's Watson will take on Ken Jennings, holder of the longest winning streak on *Jeopardy!*, and Brad Rutter, who holds the record for all-time highest winnings on *Jeopardy!*.

As a software engineering student and a trivia enthusiast, I'm quite interested in how this will turn out. I've been following news on Watson since reading [this][nytimes] article in June. And as we get closer to the Feb 14-16 tournament, there's been more and more hype about Watson in the news. Especially after a clip from the [practice round][practice] was released, where Watson was winning by the first break.

Instead of reiterating most of the information on Watson that's publicly available, I'll offer my own thoughts. I'm no expert on Watson or *Jeopardy!*, but I have appeared on [*Reach for the Top*][reach], a high school trivia game show. So I've got some knowledge on this subject, and I'd like to discuss (what I think are) some of Watson's advantages and disadvantages.

[nytimes]: http://www.nytimes.com/2010/06/20/magazine/20Computer-t.html
[practice]: http://www.engadget.com/2011/01/13/ibms-watson-supercomputer-destroys-all-humans-in-jeopardy-pract/
[reach]: /blog/reach2009.html


Why Watson can win
------------------
- **Watson is fast**<br/>
*Jeopardy!*, like *Reach*, is a game of fast recall. To be even considered a good player, you must have a good chance of answering correctly for any given question. To be a great player, you must answer correctly first. However, unlike *Reach*, *Jeopardy!* contestants are locked out from answering until the entire question is read. In a race like this, a computer's always going to be faster than human reflexes.

- **Watson knows a lot**<br/>
Watson has no Internet connection, but it doesn't need one. The researchers have loaded all sorts of material into Watson. For Watson, the trick is not to recall or retrieve information, but to figure out the correct piece of information to offer. We're pretty much the opposite. While it's effortless to decipher the question, many times the answer seems familiar, but we can never recall it. Or worse, there's an entire category of questions that you don't know.

- **If you don't get it, Watson will**<br />
This is actually more about Watson's speed. If someone buzzes in and answers incorrectly, the other person won't have a chance. Watson will snatch it. I noticed this in a different practice clip, where Watson played against less superbly-talented players. If Watson doesn't have an answer in the five seconds it takes to read the clue, it will have an answer in the five seconds it takes for someone to buzz in and make a mistake. Unless it stumps Watson, the third player will be shut out. Now, Jennings and Rutter are good enough that this shouldn't happen too much -- in the practice clip, neither of them (nor Watson, for that matter) made a mistake. But, mistakes will happen.

- **Jennings and Rutter are splitting the points**<br />
This follows from my previous point. People call this "man versus machine," but in *Jeopardy!*, there are three contestants. Not two. Because Watson is so aggressively fast, it's more of "Watson against everybody else." If Watson doesn't get it, Jennings and Rutter will be fighting each other for the points, and they'll score lower than if it was only one of them against Watson. If Rutter narrow beats Jennings to the buzz and gets it wrong, Watson won't hesitate to take the question.

- **Watson is a machine**<br />
Probably Watson's greatest strength (or Man's greatest weakness) is the one that can't be duplicated. Watson has no emotions or thoughts. Watson won't get distracted. It's possible to focus your thoughts to only the game and eliminate other distractions, but the game itself is a distraction. If you're losing, you get worried. If you're ahead, you're worried someone will catch up. You're hoping (or not hoping) for a Daily Double. You're kicking yourself for getting the last one wrong. You're kicking yourself for being too slow. And more. And you can't do anything about it. Whereas Watson just continues answering questions relentlessly.


Why Watson can lose
-------------------
- **Watson has to understand language**<br />
Deep Blue was only good because it bruteforced the game. Wolfram|Alpha's only good because of ten years of handcrafting connections in the database. Google? It doesn't answer questions. Watson actually has to decipher the question, come up with hundreds of possible answers, and then figure out which one's the best answer. Yes, an enormous amount of computing power is necessary, but that's not the problem or the reason Watson was developed. Watson needs to understand what is being asked. And sometimes Watson fails miserably, resulting in seemingly-random answers. Maybe we'll see some next week.

- **Watson has no gut instinct**<br />
It's probably not a good idea to rely too much on gut instinct, especially when stakes are so high. (Not much of an issue in *Reach*, where there is no penalty for incorrect answers and there's so many questions to make up for your mistakes.) But in some cases, it's very useful. It takes far too much time to decipher a question (even as it's being read), come up with an answer, and then buzz in. There's a short amount of time given after you buzz in, so a different strategy is to buzz in when you're pretty sure you have the answer, and then come up with that answer in the time you're given. Watson doesn't do that. Watson has to actually evaluate the possible answers and pick the best one before it even buzzes in. So some of its speed advantage is lost, though not too much, since contestants are locked out until the end of the question.

- **Wagering**<br />
Somewhat related to gut instinct. Wagering is a combination of game theory and gut instinct. There's probably books written on *Jeopardy!* wagering strategies. For a simple case, if you have more than double of your opponents, there is no possible way to lose, unless you wager too much and get it wrong. But it's more complicated when the scores are closer. Watson probably has these strategies hardwired. But then gut instinct comes in. How confident are you feeling about that category? Watson's team seems to recognize this as a weak point, but won't say much else. I've actually read about an incident where Watson wagered **$5** in a Daily Double.


So who will win?
----------------

Originally, I did not plan to make a prediction. Mostly because I was undecided, and partly because, well, who wants to be wrong on the Internet? I even intended to come up with an equal number of points for both sides, but it seems I'm having difficulty arguing for Watson's loss.

To be honest, though, my original thought was that Watson would lose -- possibly by a very small margin. I had believed that Watson's understanding wouldn't be powerful enough, and that Watson would struggle more with speed than getting the right answer. But this is probably based on earlier -- much earlier, probably around June -- reports of Watson's performance, when it was less accurate and far slower. But it's been eight months, and Watson's only getting better. It really shows in the practice video.

But based on more recent reports, and my (somewhat unorganized) thoughts above, here is my prediction, for better or for worse: **Watson will win. Maybe by a small margin, maybe by a landslide. But Watson will win.** I may end up looking like a fool next week, but that is my prediction.

Either way, it'll be an intense game. February 14-16, 2011. I know where I'll be.

And to conclude, here's a quote from Kasparov after he lost to Deep Blue. "Well, at least it didn't enjoy beating me."
