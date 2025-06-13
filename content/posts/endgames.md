---
title: "Endgames"
date: 2024-08-09T04:31:43-07:00
draft: false
---

If you know me in any capacity, you know I [play chess](https://lichess.org/@/avry). Someone told me a few weeks ago that they "knew the rules to chess, even the weird ones", and we embarked on a sort of collaborative chess trivia. Some chess rules pertain to etiquette during the game (no talking, same hand moves piece and hits clock, etc.). We will ignore these. Here are the rules of the board (and not the people around it) in ascending order of obscurity:

- the way the pieces move[^1]
- the conditions of check and checkmate
- king cannot move into check, is never actually captured
- stalemate
- the specifics of castling: king moves 2 squares and rook wraps around king, king/rook haven't moved[^2], king is not in check, king does not move through or into check
- promotion specifics (underpromotion, you can have 3+ queens, etc.)
- en passant capture
- triple repetition draw declarations
- the 50/75 move rules

and the last rule, which sent me down this rabbit hole:

- the outcome of a tournament game when one player runs out of time and checkmate is impossible.

Under United States Chess Federation rules, if you run out of time (this is called flagging), you lose the game. FIDE is more forgiving; flagging when your opponent can't possibly checkmate you is a draw[^4]. A lone knight+king can never actually deliver checkmate[^3]. This is a position where checkmate is *impossible*. 

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/kvn.png)

Two knights vs a king can't *forcibly* checkmate an opponent who doesn't intentionally walk their king into a corner. So for all practical purposes, this is a drawn endgame. However, since misplay could legally result in checkmate, flagging as black in this position would be considered a FIDE loss:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/kvnn.png)

You're an astute chess player, so you're aware of engine tablebases. We have examined every possible permutation of the game when there are 7 or fewer pieces on the board[^5]. We have determined which positions contain checkmates, and chess engines on your phone can query this database. For practical purposes this is adequate;

Dear reader, together we will explore the unholy set of dead board states with greater than 7 pieces. Firstly, we will start with the broad category of "sections of the board that can never interact":

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/8pawns.png)

Alright, so the kings can't ever confront, the pawns can never move. This one is pretty simple. We can spice things up:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/22pieces.png)

Stacking the pawns prevents both bishop colors from touching. I could construct the board with 18 bishops[^7], 9 on the same color per side.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/checkers.png)

Interestingly enough, lichess is aware of this edge-case enough to end the game pre-emptively. I assume this is because stockfish refuses to play checkers. These positions are legally drawn, because checkmate is impossible; flagging here doesn't impact the outcome. It's fairly trivial[^9] to conceive that these are drawn, because of a lack of ***interaction***, the #1 heuristic I've learned to use constructing these positions. With the pawns in this arrangement, the board splits such that the extant pieces can't traverse, ultimately to *interact*.

Let's add some piece variety[^6]:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/trapped.png)

We need not be limited to bishops, they just make composing these a lot easier (they can't move forward like pawns). All of these dead positions are pretty easy to prove are drawn, and therefore, are automatically drawn under FIDE article 6.9. Any sane arbiter would agree. However, "impossible to checkmate" also applies to the next echelon of complication.

Broadly, there are three categories of dead state, where:

- interaction becomes impossible
- interaction is about to become impossible
- stalemate is inevitable

I've only shown you category 1. Here's category 2[^8]:


![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/dynamicfork.png)

Here is a legal board state. Qg6+ draws the game. Here, black can take with either bishop or king; a single branching path leads to two separate dead states outside of tablebases. We can almost certainly construct increasingly complicated dead states.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/secondlevel.png)

In this impossible position, white has to take the queen, then black has to let white take the knight or encounter stalemate, and then it's familiar black bishops and checkmate is impossible. This means that, from the initial board state, checkmate is impossible to deliver, thus this game is legally drawn, before white takes queen[^7]. This position reduces by force to a dead state that is not in tablebases (>7 pieces) through a series of only-moves.

Let's introduce more formal definitions:

Let D be the set of all dead board states. The simplest dead board state is 2 pieces -- kings -- call this D<sub>2</sub>. How big is D<sub>2</sub>? A king occupies 9 squares that another king can't, unless it's toward the edge. On an edge, that number is only 6. On a corner, 4. So D<sub>2</sub> has 36\*55 + 24\*58 + 4\*60 = 3612 permutations. D<sub>3</sub> is D<sub>2</sub> but involving a bishop or knight; a major piece can checkmate, and a pawn can become a major piece. So D<sub>3</sub> is at least D<sub>2</sub> \* (64 - 2) \* 2 = 447888. However, major pieces and pawns can exist in D<sub>3</sub> under the condition that one side is *forced* to capture (white to move):

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d3pawn.png)

D<sub>3</sub> contains 8 entries with a pawn, involving this position, the position where black's king is on f2 instead of f1, the same situation but mirrored to the a1 corner, and those 4 positions but with the colors swapped and in the h8 and a8 corners. Outside of the corners, D<sub>3</sub> contains major pieces both in corners and on edges where the combination of king+major piece forces a checkmate unless the major piece is captured, with the unfortunate exception of queens far away from kings bloating the category-2 D<sub>3</sub> space:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d3farking.png)

D<sub>4</sub> only contains boards where black and white have 2 bishops of the same color, or reduce by force to a D<sub>3</sub> position with a minor piece. One minor piece on each side isn't a dead state; observe this D<sub>4</sub> edge case:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d4exception.png)

So far I've shown you as far as D<sub>22</sub> (2 kings, 4 bishops, all 16 pawns). Surely you, dear reader, want to know: how many pieces can you have on a board in a dead state? All of them:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d32ply1.png)

In this position, black is forced to capture the white queen, which immediately leads to a stalemate. It took me about 2 hours to compose this "trivial" 1-ply[^10] stalemate reduction, just to demonstrate to myself that D<sub>32</sub> != ∅. Maybe D<sub>32</sub> has entries that don't involve pins, though they're substantially easier to work with.

So, knowing that D<sub>32</sub> is nonzero, do you think dead states exist beyond current engine computation horizon? Such a state, should it arise in a tournament setting, could be correctly declared drawn in the event either player flagged. When I was searching for the smallest D containing a pawn, I inadvertently constructed this state:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d7pawns.png)

This is a dead board state, though it's not immediately obvious. Once you realize that black can triangulate to win the bishop by force, it looks like black can clean house. But in actuality to capture the bishop is stalemate; this is a dead board state (inside D<sub>7</sub>). Is it category 3? Stalemate isnt "inevitable", but is the lowest entropic state. It makes sense to describe this as a *stable* dead state.


[^1]: there is actually disagreement in certain areas, particularly Eastern Europe iirc, where some holdouts permit both sides to move 2 pawns 1 square forward on the first move, in addition to the normal 1-pawn-2-squares rule.

[^2]: and the rook has existed since the start of the game. thanks, Tim Krabbe

[^3]: A bishop can't either. 2 bishops can checkmate. 2 knights can checkmate, but can't forcibly checkmate, but can forcibly checkmate if your opponent has a pawn on the board of certain rank/file. A bishop+knight can forcibly checkmate, and is considered the most complicated of all "elementary" checkmates (pieces vs king) involving walking a king to 2 board corners, 2 competing theoretical frameworks for doing so (deletang's triangles vs the W-maneuvre), and a worst-case scenario of 33 moves to mate. This position occurs in roughly 1/6000 tournament games iirc

[^4]: This is a combination of [articles 5.2.2 and 6.9](https://handbook.fide.com/chapter/E012023). If both sides can't checkmate each other, the game is actually drawn even if neither player is aware of this fact. [This github issue](https://github.com/lichess-org/lila/issues/9249) explains that this actually affects the outcomes of some minute probability of online games. Note that online games are far more likely to encounter this scenario, where the time controls are faster, the players are less prepared, etc.

[^5]: You have of course memorized the optimal play required to deliver checkmate as white in 545 moves in [this position](https://lichess.org/editor/8/r6n/8/8/5k2/3K4/7N/3b3Q_b_-_-_0_1?color=white). The 7-base record is 549. We are currently working on 8, and there is already a confirmed 584 depth-to-mate.

[^6]: It's hard constructing chess positions where both players are your adversary. Regardless, this position is impossible to reach, if you're curious, because of the 4 required promotions.

[^7]: Conclave

[^8]: Black does have the option of stalemating or reducing to zero-interaction.

[^9]: If you aren't a chess player and this isn't trivial: in this position, if white is on a light square, *check* is impossible. If you've correctly deduced that white could be forced off a light square by feeding all their bishops to black's king and entering zugzwang, consider: contesting every light square around the white king is impossible (even on the corner, even while using the black king).

[^10]: A ply is a half-move; in chess, a move is when both sides move a piece. For the record, I hate this convention. A move should be when a piece is moved. Anyway, too late now
