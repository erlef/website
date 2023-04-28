{
  "title": "EEF 2023 Elections Events Review",
  "authors": ["Fred Hebert"],
  "slug": "election-2023-events-review",
  "category": "eef",
  "tags": ["eef", "board", "elections"],
  "datetime": "2023-04-28T14:00:00.152799Z"
}
---
EEF 2023 Elections Events Review
---

The Erlang Ecosystem Foundation (EEF) has, by rule of its own bylaws–which we adopted by borrowing very heavily from the Python Foundation–a system by which the board of directors is made up of volunteers, split up in 3 cohorts. Each cohort contains 3 or 4 representatives, who serve for 3 years. When bootstrapping the foundation, everyone served for a year, and at the end of that first year, [we divided all the founding members into the various cohorts at random](https://drive.google.com/drive/folders/1b3dnc6jIQ2ZdT3dC3Gjgjx1DQXR0GE9J).

I have served on the board since the start, won the first cohort’s election after having defined the process by which it would run, and this year, I decided not to get involved and to hand this off to other board members as I stepped down. As you now know, [we’ve run into various issues and technicalities, and we chose to re-run the final election vote](https://erlef.org/blog/eef/election-2023-revote). I have a bit of passion for incident reviews of all kinds, we thought no such amazing opportunity should be wasted. This text represents our overview of the election process, the challenges we highlighted, and the methods we think might help in future years.


### How Elections are Prepared

The EEF is a foundation run for software developers and engineers, mostly run by software developers and engineers. This means that pretty much every volunteer sitting on the board does this job on top of other involvements within the Erlang and Elixir communities (without forgetting all the other languages on the Erlang VM).

There are a few things we are beholden to regardless of desires: filling in all the tax information we are required to, paying for insurance, respecting the duties and responsibilities of a 501(c)(3) foundation, and respecting our own bylaws. These bylaws state the frequency at which elections have to take place, and since they line up with the foundation starting, we kickstart the process around February every year.

The process for elections is something that we arbitrarily came up with and kept tweaking in a way that felt convenient to all:

* We pick a set of dates (announce the election, let candidates state their intent and send their profiles in, starting an electronic vote, and stopping an electronic vote)
* We prepare a few blog posts and emails
* We wait for profiles to roll in
* We update the roster of the foundation (particularly for contributing members who “pay” their membership in sweat equity by participating in working groups)
* We set up the electronic vote
* We release the results, tell everyone
* We certify the election results and transfer powers

This list is as exhaustive as any instructions we’ve had internally. That is to say, nothing was really written down in one place. Information was spread around the minutes of many meetings and artifacts from previous runs, but also in the head of our election officers, Peer Stritzinger and Fred Hebert, until this year.


### This Year’s Events

This year’s February rolled in, and I realized “whoops, it’s time to run elections again.” I looked at older elections, picked the same series of Friday-to-Friday times:

* February 25: Elections announced, people can submit their candidacy
* March 10: Last day to submit your candidacy. Email acceptance ends at midnight PT on the 11th
* March 11: Votes are open
* March 18: Votes are closed


Since I was stepping down from the board, we decided to let the elections be run by new folks. Ben Marx and Bryan Paxton stood up and decided to take over the process. This was done _after_ I had already picked the dates for the events if you’re being careful about the order of events.

I gave them a quick list (shorter than the one described in the previous section), told them to copy/paste most of the content and tweak it, and said I’d be around to help and answer questions. That is, after all, what I did for the last 3 elections. This hand-off was done on February 18th, a single week before the election was supposed to be kicked off.

Even though the elections were kicked off at the right time, we were tight on the schedule.

As we waited for candidates to send in their profiles, the foundation’s inbox remained quite empty. It turns out we have no idea what happens to the foundation if we can’t fill the board and run a proper election, and we need candidates. This was starting to be concerning.

This forced our election officers to start doing an awareness campaign going further than our emails (which we suspect our members classify as spam from time to time and limit our reach): forward announcements to forums and to social media, going into chat communities, asking people directly whether they are interested in the elections.

Now here’s the thing about running a volunteer board: volunteers aren’t paid, they have day jobs, and they have families to attend to. This election was getting time consuming, and since our schedule was tight, even our board members who would run again took their time to send in their profiles. Without easily available examples, members of the public feel like there’s a bit of a blocker to throw their hat in, and everything sort of stalls out.

On Friday March 10th, people who had voiced their intent to participate still had not submitted their profiles, and when we reached out to them, they stated that they had mis-understood the dates and expected the candidacy period to be open for an extra day. Part of the problem here is that some of these answers came from board members who we thought would know the dates, but did not.

Dates and time are confusing, comms were rushed, sample profiles came in late, and election officers were busy, enough to miss the poll-opening deadline. We decided to extend the running period by an extra week to give everyone the opportunity to participate, announced the delay, and waited some more.

On March 18 at midnight PT, the poll was open. The polls are run using the Wild Apricot software, which we use to track and process member payments, to send our batched emails, and so on. This is economical because we don’t need to create any extra software, and just use theirs directly.

Their polling system is mostly manual (there are no scheduled sends nor closures that let you specify the time on top of the date), coupled with emails, and works with a WYSIWYG editor, based on some template language. Since the email format is a bit tricky, we tend to rely on copy/pasting to make it work. The whole process is run 2 days before the actual election, and everything appears to run smoothly.

On March 18, the poll is opened, election officers confirm they received the email and can vote, and everything is fine. On March 25, right on the midnight mark, the poll was stopped as planned. The results are in, and we announce the results as soon as possible since we were already late by a whole week.

But on that very same day, one of our members tries to vote, and finds the poll closed. They point out that the email that was sent (and copied from a template) indicates the votes should still be open:

<img src="/images/community/blogs/elections-2023-wrong-date.png" class="img-fluid" width="100%" height="auto" alt="Email poll preview showing the wrong ending date as March 25 at 23:59 Pacific time"/>

The email was intended to show March 24 at 23:59 Pacific Time, or March 25 at 00:00 Pacific time. Instead we got the hybrid version, and some members could not have voted when they thought they could.

Furthermore, the election results were already announced by then, and the 4th board position won by a single vote. We listed a bunch of options:

* Re-do the whole process from scratch (including candidacies)
* Re-running the votes only (no new candidacies, no membership changes)
* Re-opening the polls for more time
* Asking candidates if they were okay with the results as they were
* Do a run-off elections of positions 4 and 5 in the poll results
* Do nothing and keep things the way they are

Reopening the vote would have allowed a vote manipulation that could be worse for trust than any other option; re-doing the whole process would have been cumbersome and long – something we didn’t want to attempt when participation to 501(c)(3) board elections already garner limited excitement; asking candidates if they’re okay would still strip democratic rights from members, and run-off elections still demand everyone re-votes.

So we decided to just re-run the vote and learn as much as we could from the process.


### Analysis

In discussing the overall mechanism, we noticed a few overarching themes: issues around deadlines and time boundaries, the poor effectiveness of our messaging, the overall feeling of rush around these elections, and the limited redundancy (also known as “bus factor”) on our board.

In this section, I’ll quickly break them down and report what we think may or may not help in future elections.

#### Deadlines and Boundaries are fuzzy and hard to follow

As many readers are possibly aware, dealing with dates and time in an international manner is not straightforward.

To make things somewhat simple we try to keep election cycles on a Friday-to-Friday cadence, over a few weeks. But whose Friday exactly? We default to Pacific Time because that’s where the Foundation is incorporated, but our Election officers are not necessarily on the North American West coast; elections are always at a risk of running too long depending on sleep schedules.

Similarly, the dates and times communicated are also confusing. People read “Friday March 18” and they assume it’s going to be _their_ Friday March 18. Time zones are tricky, and really easy to mess up. It’s also sometimes really confusing if “midnight” means as the day starts or as the day ends. Anyone who waits close to the deadline to vote risks being in for a bad surprise.

As pointed out in _This Year’s Events_, even some of our board members found it challenging to know when exactly the candidacy periods were closing.

We’ve generally used our blog posts as the canonical place to note the various deadlines, but as we run more and more elections, the number of blog posts grows. As we increase our communications to various communities, forums, groups, and venues, this information gets duplicated and each one of these runs the risk of having a mistake.

What is becoming more obvious to us is the need for a central location for canonical times that we can keep linking to and where all mistakes can be corrected without needing to re-edit dozens of posts in various systems. We also see the value in providing the dates and times in more time zones to make sure members find a time close to theirs, but also so they realize that the one they see at the top is _not_ in their local time.


#### Messaging is tricky and does not work well

It does not please me to say this, but a bunch of our members put the Foundation’s emails into their spam folders. If they don’t, it looks like they do. The constructive way to see this is that we need to be very judicious about when we decide to contact members, because people will rightfully trash things they do not believe are relevant.

We would usually fall back onto Twitter to easily reach out to a wide part of the community, but with the recent Twitter events, fragmentation in the community has gone up slightly.

This, in general, means that if we have to bring in corrections or change schedules, the cost of doing so is large, and we risk losing more and more people every time.

We need to revisit our current communication strategy for internal mechanisms such as the elections or the annual general assembly, and find effective ways to reach out to people in non-invasive ways. Alternatively, we would benefit from having a more robust process that ensures we do not need to exercise these communication channels as often, and keeps the noisiness as low as possible.


#### Things were rushed and had no buffer

The way elections are started at the last minute whenever someone remembers “oh yeah, we need to do that” makes our overall process far more brittle than it needs to be.

The running period for candidates is short, there are no profile samples, and we need to improvise emergency campaigns to get more participants. Even board members who had run in the past and had profiles pre-written could be slow to send them in.

The poll being set up a few days right before the election gave a general sense of rush (“when do we have half an hour so people across continents can sync and transfer knowledge in an admin panel?”), and that urgency likely reduces our ability to review the dates, send sample polls, and so on.

Similarly, closing the poll and publishing the results right away removes any room for recovery for procedural issues and challenges on _how_ the elections were conducted (we could still receive challenges on the _results_ regardless of how they are run).

Our ongoing theory is that having more clearly-defined steps, with a straightforward schedule with repeatable elements, could reduce friction and increase our buffers. For example, we could decide that “the election starts the first Friday of March”, and imply earlier hidden steps, such as “the Board has to have kicked off and prepared the blog posts and comms by the third Friday of February”.

Having this added to a calendar with automated reminders lowers the probabilities that we are caught in a rush because nobody remembers we have to run our own elections with enough lead time.


#### Limited redundancy

Finally, the board elections in the past were run by two board members who covered the process for 3 years.

This year was our first year doing a transfer, but because one of the members was leaving the board, he tried to be as hands-off as possible. This, of course, removed support from the new members trying to take over the responsibility.

Getting our process better documented, more known, but also experienced by more people is a way for us to better transmit its mechanisms and importance down to future cohorts.


### Conclusion

We hope this adequately explains the difficulties we had in figuring out how to run a foundation, apply its rules, and reach a worldwide audience to ask them whether they’d like to give their free time to help run its administration in their free time.

The challenge is sizable, and like many non-profit organizations, we could always do it better with more help. If you feel interested, [reach out to us](https://erlef.org/contact/) or [join the foundation](https://members.erlef.org/join-us).

