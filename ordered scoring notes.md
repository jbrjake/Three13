Rethinking ThreeThirteen Hand Logic
=================================

The current logic doesn't seem to work very well. It's too focused on identifying the best hand one can assemble the cards into, without being able to identify all the ways they can assemble the cards. There's got to be a way to do this without using tons of memory.

Goals
-----

* Understand wild cards
* Determine which cards are adjacent to which other cards
* Score a hand the way it is currently assembled
* Determine the best ways to assemble the hand
	* "Best" == lowest score
	* Order options in ascending score
*

Thoughts
--------

* There are lots of ways to assemble a hand (especially in round 13), but limited numbers of ways the hand can get a good score.
	* Which, put another way, is to say there are only so many possible melds within a hand

* Current practice is to generate all possible combinations and filter down to valid ones. But that's costly, and not really necessary if you're not going to look for the "ideal" way to score the hand regardless of order. Which I do want -- it will make it a hell of a lot easier to say how well a player performs, plus the logic already exists. It's just not a good idea to frontload that process with permutations instead of combinations.

* Instead, let's start the other way around. Look for any valid melds *in the current hand*, then find the set of melds that don't contain the same cards, and then find the combination out of that set of melds which generates the lowest score. Put another way, the goal is to minimize the value of the cards not in any collection without including any card in more than one collection. With a collection being restricted to cards that run in a series within the hand, obeying the rules that they go in sequence for the same suit or repeat value for cards in different suits -- plus or minus jokers.

Run detection
-------------
One way to do this:

1. Reject sets with cards in different suits that aren't jokers
2. Find the locations of all jokers
3. Find the locations of all breaks (cards not running in sequence)
4. If the location count isn't the same, it's not a run (need a joker to plug each break)
5. If the location of each break isn't the same as the location of each joker, it's not a run.

or better still...

Finding breaks:

Go through card by card. If the value of the next card isn't +/- 1, and it's not a joker, it's a break. If it is a joker, then the card after it isn't +/- 2 of the current, it's not a run.


Need to think about this a bit more...let's try some examples

No jokers:

	N	N + 1	N + 2
	N	N -	1	N - 2

1 joker:

	J	N + 1	N + 2
	N	J		N + 2
	N	N + 1	J
	J	N - 1	N - 2
	N	J		N - 2
	N	N - 1	J

2 jokers:

	J	J		N + 2
	N	J		J
	J	N + 1	J
	J	J		N - 2
	N	J		J
	J	N - 1	J

3 jokers:

	J	J		J

-- but this will probably only work if you expand this out to every possibility for a whole 13-card hand with 8 possible jokers :(

... another approach might be to have a collection of melded cards, and only add when the next card goes in sequence or is a joker, then make sure all cards in hand are in the collection -- but this gets more difficult when jokers are in the mix...say the first three cards are jokers -- what numbers should they represent?

---

Need to figure out how to assign jokers...let's take a sadistic example:

	J	J	J	N+3

So let's say we strip jokers, then try to replace them. We know to pre-append jokers if the first non-joker card is not at the same index it's in for the hand!

---


Finding all valid melds
-----------------------

Okay, it looks like I have a working method to detect whether or not an ordered set makes a run. Now, how can this be used to find an optimal score?

