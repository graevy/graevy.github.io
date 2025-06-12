---
title: "Devhack 2"
date: 2025-05-10T13:51:26-07:00
draft: true
---

### "Who knows who knows what?"

[Devhack](https://devhack.net)'s in the black. Now begins the infrastructure calcification. Here are the movements:

- Two separate server rooms, one heavily access-controlled for core infra, one as a member service with power monitoring
- Netbox mapping the various groups and physical infra

### I was wrong about declarative infra

Kindof. Rapid prototyping creates untracked state; makes it somewhat undeclarative.

Declarative infra helps the most for critical things with shit UX (e.g. network switches). DO NOT LEAVE THE HAPPY PATH or there will be no terraform providers and your declaration will be WEIRD.
