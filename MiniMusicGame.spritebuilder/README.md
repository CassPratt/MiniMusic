cassandra-pratt-romero
======================

Cassandra Pratt Romero's Game
# MiniMusic 
## Game Design
### Objective
Learn how to read and write music.
In this game you discover music while playing various challenges (mini games).

### Gameplay Mechanics
The game consists of a total of 6 mini games. Five of them are focused on stimulating the musical senses: melody, rhythm, reading and writing, harmony and musical pitch. 
Each mini game has its own behavior.
In the sixth mini game you must play the notes of a given color to advance in the level.

### Level Design
- Mini Game 1: Pitch Memory 
Traditional memory game but using sounds (musical notes). 
You have to make as many pairs as you can in the given time.
   - levels in this mini game: if you pair a certain number of notes you'll be able to go to the next level, 
     with more musical notes and less time.

- Mini Game 2: Random Game
You must pick the musical notes of a certain color. If you pick from a different one, you lose one life and the notes are reset. More notes of another colors, faster. Try to find the given color.

## Technical
### Scenes
- MainScene: the first scene, containing the title of the game, an information button, another button configuration and the START button to display menu of mini games. 
- MenuScene: contains the buttons to go to different mini games.
- PitchGame Scene: 
     - label of counter
     - label of pairs you found
     - a grid with the musical notes
     - a BACK button
- RandomGame Scene:
     - label of notes found
     - number of lifes you have
     - a lot of different colorful notes
     - a BACK button

### Controls/Input
- Mini Game 1: Pitch Memory
  The user touches the notes (touchBegan).
  (touchEnded) The game checks the pair of notes.

- Mini Game 2: Random Game
  (touchBegan) The user touches a note and the game checks if the note has the same color as the color chosen at 
  the beginning.

### Classes/CCBs
* Scenes
  * MainScene
  * MenuScene
  * MiniGameScene
  * PitchGame 
  * RandomGame
* Nodes/Sprites
  * InstructionsPopUp
  * LifeMusic
  * MusicalGrid
  * MusicalNote
  * YesNoPopUp
  
#What is working, what is not working
* Pitch memory MiniGame is working correctly
    - Levels implemented correctly
* Random MiniGame is working correctly
    - Physics fixed
    - Levels not ready yet
* PopUps and pauses of the game are ready
    - Ready in both MiniGames
* Scores not fully implemented yet
    - PitchGame: have to work harder on the scores
    - Still no scores

##Roadmap
* Tuesday July 29th
    - Implement levels on RandomGame
    - Improve scores in the two MiniGames
    - Start a new MiniGame (rhythm)