---
title: "Motherboards"
date: 2023-02-07T18:53:07-08:00
draft: false
---

### Background

Every week I host an open source meetup in Seattle. My friends are always bringing in project laptops to fix up, dual boot linux with, whatever. There's a light-hearted atmosphere, food, people coming and going. 

![](/images/motherboards.jpg)

### The Problem

You can do everything right when e.g. replacing a battery, and end up breaking the motherboard. ASD wristbands and bags, step-by-step manufacturer-supplied teardown instructions, magnetic isolation, the works; the board still undergoes a lot of physical stress in some replacements.

About half the time we replace a minor component, we put things back together, and there's no POST! And these boards aren't modular; typically we can only salvage ram and a wifi card. So a $30 battery replacement becomes a $100+, 3+ week affair waiting for shipping. Too much to expect from someone too poor to just buy a new laptop, and too mysterious for the wrong kind of nerd to ignore.

We are only concerned with cases where:
- The PC was fully functional before we replaced a part, and failed after
- Reassembling with the old part didn't fix the problem
- Nobody forgot to ground themselves, unplug all power sources, account for all screws, etc.

Common wisdom is that component failure is generally due to electrostatic discharge (ESD), electrostatic overstress (EOS), and cooling issues. 

### Hypotheses

#### 1. Replugging internals disturbs ports

Imagine a scenario where dust accumulates in an internal port. It's never been unplugged, so disassembly lets potentially conductive dust inside. Internal ports don't have the lifespan expectations that external ports do. 10%?

#### 2. Years of thermal cycling weaken connectors enough to fail silently after reseating

These laptops accumulate so much dust that thermal throttling slows them down. Giving this 20%.

#### 3. Moisture introduced/dust disturbed in the replacement process shorted a component

Idk about this. 5%.

#### 4. Bad replacement part

I once had a DVI cable that ate 2 monitors due to faulty wiring before I could establish a cause. Normally this would be negligible but there's a lot of specifically battery counterfeit out there that can damage a motherboard. Maybe 5%?

#### 5. Someone did something wrong without knowing it

This has to be a substantial portion; assuming a ground/screw/etc was taken care of that wasn't. I'll guess 25% because I'm only human.

All told, this leaves about 1/3 of causes unexplained even by my guessing. Eventually I'll fill up my wall of dead laptop motherboards and get in there with more than just a multitool.

Sidenote: I have to figure out git lfs if I'm going to host images on my site long-term.