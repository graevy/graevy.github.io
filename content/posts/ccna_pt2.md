---
title: "ccna 2"
date: 2025-06-11T18:29:48-07:00
draft: false
---

### My CCNA experience

I wrote about being "halfway done" with the course material like over a year ago, which was true. However. The start of the CCNA is fun. You learn how computer networks work! All the terms you've absorbed throughout the years start making sense. It's addicting.

You have to cram the end of the CCNA. Now that you've learned routing protocols, you need to memorize their administrative distances. The Cisco iOS syntax quirks. Outdated protocol trivia. Cisco protocols that have been obsoleted by industry adoption of open alternatives: PAgP, HSRP, GLBP, ISL, DTP/VTP, EIGRP, PVST, Rapid PVST+. Oh, the Cisco exams barely cover BGP, the for-all-intents only path-vector minimal-trust routing protocol used to *route the internet*. Instead, you get the DSCP codepoint values, FHRP MAC OUIs, WiFi bandwidths, the bandwidth of an E3 vs T3 line! Don't forget Cisco-specific GUI operation.

None of these things are interesting to me, with the exception of maybe some of the WiFi trivia and some of EIGRP. I completely burnt out shortly after that blog post, I think I gave up on the CCNA entirely for about 6 months, maybe keeping up on some of the flashcard spaced repetition.

I kept watching the tech industry, particularly software, collapse around me as interest rates renormalized. So the utility of the CCNA rose, and I begrudgingly pushed forward again.


### Tools I used

JeremysITLab on youtube. This course was amazing. The extra time spent explaining protocols in the videos gets saved when attempting to memorize their functions, I can't recommend this enough. It flagged a bit toward the end, the quality dropped a fair amount when I got to the wireless sections; supplement those videos.

Jeremy provides flash cards for use with Anki, and they are very comprehensive. Delete the worst of the memorization cards, honestly, they're not necessary.

Lastly, Boson ExSim. I bought this subscription and the exam simulation was scarily accurate. Liked this a lot, especially for the labs, which I hadn't really been exposed to before. Sidenote: on the actual CCNA, remember `write mem`.


### The actual exam

Was kindof rushed. Toward the beginning of May I learned of a free-exam-retake promotion if I took the CCNA before June 12th. So I scheduled for the 10th. I got sick mid-May, dropped the studying a lot, picked it back up. I thought I recovered, got worse about 4 days before the exam. So I showed up to the exam:

- Deeply sleep deprived
- Nauseous
- Hungry, because I still wasn't tolerating solid food
- On ritalin
- Sweating profusely

I hadn't taken a proper final exam since college and was honestly shocked at my nerves. I really just wanted the CCNA to be done with, and toward the end of the test, as my ritalin was wearing off and my body was crashing, I had to kick myself to use all my time.

Boson ExSim did a phenomenal job prepping me for the exam environment. It was almost identical to the real thing, minus the legal disclaimers at the start and the note-taking sheet. Can we talk about the note-taking sheet?

They gave me this 10-page dry-erasable notepad to write on at the start of the exam. Then, before the exam starts, you're left alone with it, while you're given like 15 minutes to go through the disclaimer. You could absolutely use this legal disclaimer time to dump a bunch of content onto the notepad if you pre-studied it before entering the exam room. I didn't know about this ahead of time, but I probably would've written down:

- routing administrative distances
- which protocols are higher or lower (e.g. priority in OSPF is determined by highest values, whereas in spanning-tree it's lowest values)
- some of the protocol codes, e.g. 802.11s for multiple spanning-tree
- whatever rote-memorization I complained about above

I was comfortable in all of the labs; the Boson labs were much more convoluted, and also all-or-nothing! Exam labs have clearly stated objectives, with clear opportunity for partial credit. My second exam lab I just was missing something in the routing structure and skipped it for time and felt fine about it.

I read on the CCNA subreddit that you don't know whether or not you pass immediately. I was greeted with an immediate "Congratulations, you passed the Exam." screen. I suspect that if you score above a certain threshold on the multiple-choice you get that screen, otherwise your labs need to be evaluated?

I'm not allowed to discuss the actual questions and topics, so we're not doing that, sorry. Big fan of having this cert, don't want to lose it!
