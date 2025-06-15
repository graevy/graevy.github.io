---
title: "dead chess boards"
date: 2024-08-09T04:31:43-07:00
draft: true
---

I [play chess](https://lichess.org/@/avry). Someone told me a few weeks ago that they "knew the rules to chess, even the weird ones", and we embarked on a sort of collaborative chess trivia. Some chess rules pertain to etiquette during the game e.g. "no talking". Here are the rules of the board (and not the people around it) in ascending order of obscurity:

- the way the pieces move[^1]
- the conditions of check and checkmate
- king cannot move into check, is never actually captured
- stalemate
- the specifics (and edge cases) of castling
- promotion specifics (underpromotion, you can have 3+ queens, etc.)
- en passant capture
- triple repetition draw declarations
- the 50/75 move rules[^11]

and the last rule, which sent me down this rabbit hole:

- the outcome of a game when one player runs out of time and checkmate is impossible.

Under United States Chess Federation rules, if you run out of time (this is called flagging), you lose the game. FIDE is more forgiving; flagging when your opponent can't possibly checkmate you is a draw[^4]. A lone knight+king can never actually deliver checkmate[^3]. This is a position where checkmate is *impossible*; a dead position; an *unwinnable* position. 
\

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/kvn.png)

Two knights vs a king can't checkmate an opponent who doesn't intentionally walk their king into a corner. So for all practical purposes, this is a famously drawn endgame[^12]. However, since misplay could legally result in checkmate, flagging as black in this position would be considered a FIDE loss:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/kvnn.png)

I find this all fantastically interesting. FIDE doesn't assume the skill of the player in this scenario (understandable, given the arguments that would spawn), yet, the FIDE rules do require someone possess the chess acumen to accurately assess board winnability. I have to make two distinctions for you:

- There's a big difference between *winnable* and *won* in the context of chess endgames. Neither of these boards are won, in the sense that best-play leads to a draw, and humans are generally capable of performing that best-play. However, only the first position is unwinnable, as no state in the remaining game tree contains a checkmate, contrary to the position above.

- In two knights vs king, the two knights side can win, so the *board* is winnable, but the only-king can't checkmate, so its *side* is unwinnable. FIDE's rules say that flagging while your opponent's side is unwinnable is a draw, which is neat. But they also say that an unwinnable *board* is automatically drawn, even if the players decide otherwise.

We've gotten really good at recognizing winnability. On Lichess, it's even automated, where it works [>99.9974% of the time!](https://github.com/lichess-org/lila/issues/9249) Online games are far more likely to detectably encounter this discrepancy. For many reasons[^2], players prefer to play fast chess online and slow chess in person. People are both far more likely to run out of time in speed chess, and far less likely to misjudge a position as decisive in a slow game. Slow chess players also tend to just be better players! Lastly, tournament games, especially high-profile ones, have many players spectating the results, and arbiters reviewing the score sheets.

But we aren't perfect. It's been burning in the back of my mind for almost 2 years now: have the players ever gotten it wrong? Since the dawn of FIDE and articles 5.2.2 and 6.9, has there even been a high-profile tournament result declared decisive that was actually drawn?

...

We have to talk about unwinnable *boards*, and how to identify them. Most of the unwinnable boards humans encounter have few pieces left on the board. We've catalogued every possible permutation of the game when there are 7 or fewer pieces on the board (including kings)[^5] into the "endgame tablebase". Chess engines can query this database for winnability. However, the chess game tree is [very big](https://en.wikipedia.org/wiki/Shannon_number), and, despite our best efforts, unwinnable boards exist beyond our brute-force horizon.

Broadly, there are two categories of dead state, corresponding to the two drawing conditions in chess:

- Interaction is impossible. Pieces can't capture, and the 75 move rule will end the game if the players don't agree to a draw.
- Stalemate is inevitable. The current game tree always reduces to stalemate.

Let's delve into the first category, interactionless games:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/8pawns.png)

Alright, so the kings can't ever confront, the pawns can never move. This one is pretty simple. We can spice things up:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/22pieces.png)

Stacking the pawns prevents both bishop colors from touching. I could construct the board with 18 bishops[^7], 9 on the same color per side.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/checkers.png)

Interestingly enough, lichess is aware of this edge-case enough to end the game pre-emptively. I assume this is because stockfish refuses to play checkers. Again, despite any perceived complexity, these positions are legally drawn, because checkmate is impossible; flagging here doesn't impact the outcome, because by FIDE rules, the game ended before time expired. It's fairly trivial[^9] to conceive that these are drawn.

Let's add some piece variety[^6]:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/trapped.png)

We need not be limited to bishops, they just make composing these a lot easier (they're easily trapped). All of these dead positions are pretty easy to prove are drawn, and therefore, are automatically drawn under FIDE article 6.9. Any sane arbiter would agree. However, "impossible to checkmate" also applies to the next echelon of complication.

I've only shown you category 1. Here's category 2[^8]:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/secondlevel.png)

In this impossible position, white has to take the queen, then black has to let white take the knight or encounter stalemate, and then it's familiar black bishops and checkmate is impossible. This means that, from the initial board state, checkmate is impossible to deliver, thus this game is legally drawn, before white takes queen[^7]. This position reduces by force to a dead state that is not in tablebases (>7 pieces) through a series of only-moves, and interestingly, *requires calculation*. Here we start to see the edge case that the most popular rules of chess don't accommodate.

Let's introduce some formal definitions.

Let D be the set of all dead board states. The simplest dead board state is 2 pieces -- kings -- call this D<sub>2</sub>. How big is D<sub>2</sub>? A king occupies 9 squares that another king can't, unless it's toward the edge. On an edge, that number is only 6. On a corner, 4. So D<sub>2</sub> has 36\*55 + 24\*58 + 4\*60 = 3612 permutations. D<sub>3</sub> is D<sub>2</sub> but involving a bishop or knight; a major piece can checkmate, and a pawn can become a major piece. So D<sub>3</sub> is at least D<sub>2</sub> \* (64 - 2) \* 2 = 447888. This comprises the *category 1* subset of D<sub>3</sub>. Major pieces and pawns can exist in D<sub>3</sub> under the condition that one side is *forced* to capture (white to move):

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d3pawn.png)

D<sub>3</sub> contains 32 entries with a pawn:
- this position,
- the position where black's king is on f2 instead of f1,
- the same but mirrored to the other 3 corners, those 8 positions but with the colors swapped, and
- those 16 positions, but with the kings swapped such that the board is immediately (0-ply[^10]) stalemate[^2].

Outside of the corners, D<sub>3</sub> contains major pieces both in corners and on edges where the combination of king+major piece forces a checkmate unless the major piece is captured, with the unfortunate exception of queens far away from kings bloating the category-2 D<sub>3</sub> space:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d3farking.png)

D<sub>4</sub> only contains boards where black and white have 2 bishops of the same color, or reduce by force to a D<sub>3</sub> position with a minor piece. One minor piece on each side isn't a dead state; observe this D<sub>4</sub> edge case:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d4exception.png)

So far I've shown you as far as D<sub>22</sub> (2 kings, 4 bishops, all 16 pawns). Let's observe an element in D<sub>32</sub>: 

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d32ply1.png)

In this position, black is forced to capture the white queen, which immediately leads to a stalemate. It took me about 2 hours to compose this "trivial" 1-ply[^10] stalemate reduction, just to demonstrate to myself that D<sub>32</sub> != ∅. Maybe D<sub>32</sub> has entries that don't involve pins, though I learned they're substantially easier to work with.

So, knowing that D<sub>32</sub> is nonzero, do you think dead states exist beyond current engine computation horizon? Such a state, should it arise in a tournament setting, could be correctly declared drawn in the event either player flagged. When I was searching for the smallest *stable* D element containing a pawn, I constructed this state without initially recognizing its beauty:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d7pawns.png)

This is a dead board state, though it's not immediately obvious. Once you realize that black can triangulate to win the bishop by force, it looks like black can clean house. But in actuality, to capture the bishop is stalemate; this is a dead board state (inside D<sub>7</sub>). It breaks my D-element binary. The only interaction results in stalemate, meaning there's neither zero interaction, nor inevitable stalemate. Maybe describing the interaction as one-sided makes the most sense. Let me add more pieces to exit the purview of tablebases:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/chess/d7pawnsplus.png)




[^1]: In certain parts of the world, particularly Eastern Europe, some holdouts permit both sides to move two different pawns one square forward each on the first move, in addition to the normal 1-pawn-2-squares rule.

[^2]: First, physically moving a piece and pressing the clock in speed chess is really awkward. Sometimes you have to do this multiple times per second. I would judge the fastest "playable" chess format in person ("otb", over the board) is 3+0 or 1+1 (1 minute per side, +1 second gained as increment per move). A mouse+keyboard feels so much better. Second, cheating is much easier online, and also, it's harder to detect cheating in slow games (where players are more likely to make engine moves), so people really like playing their slow games in person where cheating is much harder. Third, most tournaments are for slower games only, so when players want to play speed chess, they go to clubs/bars/parks/online. Fourth, most chess players I talk to agree that the game is nicer to play over the board, in front of someone. It's a more social and enjoyable activity, this sort of mutual quiet contemplative bloodsport.

[^3]: A bishop can't either. 2 bishops can checkmate. 2 knights can checkmate, but can't forcibly checkmate, but can forcibly checkmate if your opponent has a pawn on the board of certain rank/file. A bishop+knight can forcibly checkmate, and is considered the most complicated of all "elementary" checkmates (pieces vs king) involving walking a king to 2 board corners, 2 competing theoretical frameworks for doing so (deletang's triangles vs the W-maneuvre), and a worst-case scenario of 33 moves to mate. This position occurs in roughly 1/6000 tournament games.

[^4]: This is a combination of [articles 5.2.2 and 6.9](https://handbook.fide.com/chapter/E012023). If both sides can't checkmate each other, the game is actually drawn even if neither player is aware of this fact.

[^5]: You have of course memorized the optimal play required to deliver checkmate as white in 545 moves in [this position](https://lichess.org/editor/8/r6n/8/8/5k2/3K4/7N/3b3Q_b_-_-_0_1?color=white). The 7-base record is 549. We are currently working on 8, and there is already a confirmed 584 depth-to-mate.

[^6]: It's hard constructing chess positions where both players are your adversary. Regardless, this position is impossible to reach, if you're curious, because of the 4 required promotions.

[^7]: Conclave

[^8]: Black does have the option of stalemating or reducing to zero-interaction.

[^9]: If you aren't a chess player and this isn't trivial: in this position, if white is on a light square, *check* is impossible. If you've correctly deduced that white could be forced off a light square by feeding all their bishops to black's king and entering zugzwang, consider: contesting every light square around the white king is impossible (even on the corner, even while using the black king).

[^10]: A ply is a half-move; in chess, a move is when both sides move a piece. For the record, I hate this convention. A move should be when a piece is moved. Anyway, too late now

[^11]: If 50 moves occur without a piece capturing or a pawn advancing, either player (or an arbiter) can declare a draw. At 75, the game is drawn (and can retroactively be declared a draw by an arbiter even if players believe it to be decisive). A pawn advance functions as the negentropic unit.

[^12]: The only (minimalist) drawn endgame with a greater point disparity I'm aware of is: king+queen vs king+a c/f pawn on the 7th rank.

[^13]: I've only included these last 16 for completeness' sake inside the formal definition; I'm not sure if I want to, really. It's like people combining 110+ protons for eight yoctaseconds and then declaring it a new element: Sure, man.
