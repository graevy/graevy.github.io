---
title: "aoc22"
date: 2023-01-25T16:52:32-08:00
draft: false
---

## Background

Back in November I told my friends I'd do advent of code with them this year. I was going to do it entirely in Rust, because I kept talking about how much I wanted to learn more Rust to actually use it for systems programming. I fell a bit behind, caught up some days, and promised I'd catch up when I had more free time over the holidays. String processing was a little weird, but manageable; I spent evenings sipping tea and staring at `std::vec::Vec` and `std::str` to replicate the kind of pythonic dozen-line algorithms I usually write for [leetcode problems](https://github.com/graevy/leetcode).

Single files for a rust repository are a little problematic to debug, so it'd be easier to just [show you](https://github.com/graevy/aoc22/blob/main/Cargo.toml) what I settled on for a structure.

And then I hit day 7, a [graphing problem](https://adventofcode.com/2022/day/7) and I learned I didn't understand a few key concepts. And it snowballed. And about 2 weeks of hour-a-day study produced 9 attempts before a success.

### Lessons from circular graph problems in Rust

- A mutable reference *excludes* _all_ other references to an object; the compiler can't point to a mutating object and also guarantee safe member access. This was a really basic thing to miss that just hadn't come up yet.

- Parent-child referencing is notoriously difficult because of [interior mutability](https://doc.rust-lang.org/reference/interior-mutability.html); if I want to edit Child, I need a mutable reference, preventing Child's children from referencing  Child.
If Parent instead owns (and doesn't reference) Child, multiple children of the same parent will still run into reference exclusion.
And also, Parent must outlive Child, preventing some constant removal operations. Yay.

There are 4 solutions to this that I'm aware of:

1. Arenas (append-only compound data structures) can neatly handle parent-children lifetime issues present in circular graph structures, _if the contents won't mutate_; they provide lifetime guarantees, but do not implement interior mutability.

2. A weak pointer in Rust is like a regular pointer in other languages. It's like an `Option<pointer>`, and by treating it this way, we can do interior mutability (mutating an object "referenced" immutably). This is widely taught as a solution, and involves `Rc<RefCell<Obj>>` typing (use a type alias with deref derivations). While memory *safe* with the appropriate checks, it can leak due to circular referencing if you aren't careful.

3. The parents and children are just dumped into a compound data structure like a vec and the actual graph just indexes that structure. This is the most common because it's the easiest. It's unsafe because the indices have no guarantees.

4. Just use `UnsafeCell` and deal with unsafe rust. Admit defeat. At least `unsafe` is a clear warning; the others aren't.

So there is no idiom; no universal best-practice. The flowchart goes:
- do I really need my graph to be circular? can I stop referencing `Parent`?
- are the contents going to delete or mutate while still being added? Can I just use an arena?
- if they're just going to mutate, 2/3/4 will all be okay.
- `Rc<RefCell<>>` is the nuclear option, and probably the cleanest.

It's also worth noting these are not necessarily exclusive. You can achieve interior mutability in an arena with `Rc<Refcell<>>`, and you might want to; simultaneous circular reference deletion avoids leaks.

Graph structures have a reputation in the rust community, and I'm definitely not the first person to run into this. I probably also got some things wrong. Three other things stuck with me:

1. Scope ends with a `}`. That's it; that's when the values are dropped.

2. Creatively explicitly dropping mutable references can get around reference exclusivity.

3. `Impl`s require lifetime parameters because methods are attached to objects like children are attached to parents in graph structures.


To get to this point, I had to read half of The Book. I burnt out on advent and went and built this website as another project to study Ops (and dove in over my head again).