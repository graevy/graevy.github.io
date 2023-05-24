---
title: "batteries"
date: 2023-03-07T18:00:21-08:00
draft: false
---

### Background

We went for a capacity upgrade (51 -> 62Wh) when swapping out my friend's old laptop battery. Dell bios does not like the non-dell battery; the idea is to graft the old battery's management system (BMS) onto the new battery.

#### First Hurdle

The casings are different; the old one has clips on the side for disassembly and the new one is pure adhesive. Solution: destroy the new case[^1] and use the old one to store the four-phone-batteries-in-a-trenchcoat rig.

![casings](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/casings.jpg)

(new casing "teardown" vs old casing+backing)

#### Second Hurdle

New BMS contains an embedded plastic power rail connecting each of the batteries; old BMS connects to an isolated power rail.

![rail](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/rail.jpg)

The old hydrogen-bloated batteries, the orange isolated power rail, and the minimal BMS chip. Note the inverted middle batteries. We were very concerned by the presence of a third battery terminal between the positive/negative terminals (it's even marked positive):

![terminals](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/terminals.jpg)

Searching the part number on the chip yielded a [Thermal Cutoff Device](/docs/hc.pdf) [(linkrot)](https://www.bourns.com/docs/Product-Datasheets/HC.pdf) that we can "safely" ignore for the graft. I'm starting to sympathize with dell, but I'm in too deep now.

Solution: Spot welding, not soldering[^2].

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/welding.jpg)

We had to wait awhile for the spot welder to be available, but we began by welding these li-ions to the BMS. Unfortunately the batteries were completely drained, meaning we weren't able to check the quality of the welds with a multimeter.

Solution: get a power supply and manually charge each terminal.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/charging.jpg)

(Charging the batteries we hadn't welded yet)

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/battery/charging2.jpg)

(Directly charging the other two in parallel via their new circuit)


[^1]: point of no (literal) return passed.

[^2]: disappointment.
