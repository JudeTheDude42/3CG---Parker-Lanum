6/4/2025

I am astronomically more proud of this code than anything with Solitaire. I made a whole bunch of scripts, have a separate file as a card database, and I really felt I was able to utilize the tools I had accumulated in this class much better than before which is an incredible feeling.

Programming patterns that appear in my code include: 
Prototyping for my implementation of cards through CardClass and well as LocationClass,
States for storing a card's grab state as well as its position within the context of the 3CG gameplay loop,
Game Loop, as is implicit by the way Love2D handles its load, update, and draw functions; furthermore, my turnManager script uses a cycle of functions that call one another pseudo-recursively, only waiting for user input, to loop and progress turns,
Observers, with my use of reactive code within my turnManage, in terms of its response to changes in card state such as being shown or revealed in a location,
Components, especially with my compartamentalized location, deck, and player files that exclusively handled their own tasks and hardly relied on other scripts.

I got feedback from Phineas Asmelash from section and my friends Dashiell Reynaldo and Phillip Niakolov who basically forced me to take a more wholistic approach. Ever since I saw Phineas's multiple scripts in the Solitaire assignment against my measly four, something had to be done.

In my final project revision, I would really like to use the Dirty Flag pattern to highlight cards that had their stats changed by other cards. For instance, in Inscryption, stats that have been improved are green while those that have been lowered are red.
Compartamentalizing and planning my code before jumping in was a much better decision than my approach with Solitaire, but it did have some drawbacks I'll have to get used to.
Firstly, getting started with this project was definitely the hardest part. Between setting up a card prototype, working out the turn loop, and understanding how to set things up without card effects requiring hours of refactoring, I had a lot of trouble knowing where to start.
Also, I worked for several hours setting up turn logic and card properties when these elements could not be interacted with or even seen when run, so I had very little ability to debug; I had to move forward hoping I had not made any mistakes for a while.
Ultimately, taking a more foundational approach rather than jumping right in with something easy to work on was very helpful, and the finished product is evidence of this, but it can be a bit overwhelming.

All of the sprites and the game's background were made by myself using the online tool, Piskel.
