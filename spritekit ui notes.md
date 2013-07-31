Have circle nodes representing meld locations, and add cards to them as subnodes. Cards rotate. If the cards form a meld, the meld circle rotates. If a card is moved on top of a meld, it's added to the meld. Melds evenly space cards around the circle.

---------

The above idea sounds nice, but, alas, doesn't leave enough room to comfortably hold as many cards as a player gets to in the final rounds. Instead, I'm thinking of using  sort of elongated diamond shape. The bottom row would hold one node centered at size.width/2. The next row up would have two nodes, one at size.width/2 - offset, one at size.width/2 + offset. So one node to the left and one to the right of the node on the row below. Then that form alternates, until finally row n-1 is nodes 11 and 10 and row n is node 12. Above this would be a bar holding the mystery and discard from the other player. See Omnigraffle diagram.

This design makes it easy to see melds, at least at the beginning, because 3 nodes make a downward pointing chevron. Instead of rotating, they should probably glow, levitate, or pulse when melded, or get linked by lines. Cards will have to be adjacent to one another to form a meld. Multiple potential melds can be handled by chaining animations.

Cards should probably fade/grow/fall/emerge/unblur or somesuch into existence, but in early stages they'll just be there.

Card movement should follow the same mechanics as app icon movements in the Springboard, but without the wiggle: https://github.com/kristopherjohnson/tilessample/blob/master/Classes/TilesViewController.m

----------

### Card locations with the elongated diamond

Minimum card radius has to be 22 points, for a 44x44 touch target.

Each card should have padding of 22 points to each side.

This means we're talking about a minimum cell size of 22 + 44 + 22 x 22 + 44 + 22, or 88x88.

The main limit is the cell height, because we need to fit way more vertical cells than horizontal cells.

Divide the frame height by 10. The result is the size of the cells, because we need 10 rows. So if the height is 1136, the cells should be 113x113 points. Remainder gets added to the division between the deck row and the hand.

So cell 0 is centered on size.width/2, size.height - cell.height/2 - index*size.height. Cell 1 is centered on size.width/2 - cell.height/2, size.height - cell.height/2 - index*size.height. Cell 2 is centered on size.width/2 + cell.height/2, size.height - cell.height/2 - index*size.height.

Tasks:
* Method to position a node at its cell frame
* Touch control to move one node to another cell
* Adjacency finding method, to see if a node touches the other nodes it needs to in order to form a meld, in the right order.
