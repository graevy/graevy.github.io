---
title: "Endgames"
date: 2024-08-09T04:31:43-07:00
draft: true
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

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/10bishops.png)

With an implausible number of underpromoted bishops of the same color, the two board-halves can also never interact. We can make a more plausible position and include now 22 pieces:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/22pieces.png)

Stacking the pawns prevents both bishop colors from touching. I could construct the board with 18 bishops, 9 on the same color per side. This is also a forced draw.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/checkers.png)

Interestingly enough, lichess is aware of this edge-case enough to end the game pre-emptively. I assume this is because stockfish refuses to play checkers. Let's add some piece variety[^6]:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/trapped.png)

We need not be limited to underpromoted bishops, they just make composing these a lot easier (they can't move forward like pawns). All of these dead positions are pretty easy to prove are drawn, and therefore, are automatically drawn under FIDE article 6.9. Any sane arbiter would agree. However, "impossible to checkmate" also applies to the next echelon of complication: dynamic positions which reduce by force into dead positions.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/secondlevel.png)

Here, white has to take the queen, then black has to let white take the knight or encounter stalemate, and then it's familiar black bishops and checkmate is impossible. This means that, from the initial board state, checkmate is impossible to deliver, thus the game is drawn, before white takes queen[^7]. This position reduces by force to a dead state that is not in tablebases (>7 pieces) through a series of only-moves. We can go further:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/dynamicfork.png)

Again, Qg6+ legally draws the game. Here, black can take with either bishop or king; a single branching path leads to two separate dead states outside of tablebases. We can almost certainly construct increasingly complicated dead states. Let's start with a formal definition:

Let D be the set of all dead board states. The simplest dead board state is 2 pieces -- kings -- call this D2. How big is D2? A king occupies 9 squares that another king can't, unless it's toward the edge. On an edge, that number is only 6. On a corner, 4. So D2's count is 36\*55 + 24\*58 + 4\*60 = 3612. D3 is D2 but involving a bishop or knight; a major piece can checkmate, and a pawn can become a major piece. So D3's count is D2's count \* (64 - 2) \* 2 = 447888. D4 only contains boards where black and white both have 1 minor piece or 1 side has 2 bishops of the same color. There are literal edge cases that now have to be considered:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d4exception.png)



A set of dead states likely exists beyond current engine computation horizon. Such a state, should it arise in a tournament setting, could be correctly declared drawn


[^1]: there is actually disagreement in certain areas, particularly Eastern Europe iirc, where some holdouts permit both sides to move 2 pawns 1 square forward on the first move, in addition to the normal 1-pawn-2-squares rule.

[^2]: and the rook has existed since the start of the game. thanks, Tim Krabbe

[^3]: A bishop can't either. 2 bishops can checkmate. 2 knights can checkmate, but can't forcibly checkmate, but can forcibly checkmate if your opponent has a pawn on the board of certain rank/file. A bishop+knight can forcibly checkmate, and is considered the most complicated of all "elementary" checkmates (pieces vs king) involving walking a king to 2 board corners, 2 competing theoretical frameworks for doing so (deletang's triangles vs the W-maneuvre), and a worst-case scenario of 33 moves to mate. This position occurs in roughly 1/6000 tournament games iirc

[^4]: This is a combination of [articles 5.2.2 and 6.9](https://handbook.fide.com/chapter/E012023). If both sides can't checkmate each other, the game is actually drawn even if neither player is aware of this fact. [This github issue](https://github.com/lichess-org/lila/issues/9249) explains that this actually affects the outcomes of some minute probability of online games. Note that online games are far more likely to encounter this scenario, where the time controls are faster, the players are less prepared, etc.

[^5]: You have of course memorized the optimal play required to deliver checkmate as white in 545 moves in [this position](https://lichess.org/editor/8/r6n/8/8/5k2/3K4/7N/3b3Q_b_-_-_0_1?color=white). The 7-base record is 549. We are currently working on 8, and there is already a confirmed 584 depth-to-mate.

[^6]: It is interesting attempting to construct chess positions where both players are attempting to checkmate one side.
