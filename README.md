# Ayu
## Group Description

<table>
	<thead>
		<tr>
			<th>Group</th>
			<th>Number</th>
			<th>Name</th>
			<th>Contribution</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan=2>Ayu_3</td>
			<td>202102359</td>
			<td>Felipe Jacob de Jesus Ferreira</td>
			<td>%</td>
		</tr>
		<tr>
			<td>202000149</td>
			<td>Pedro Henrique Ribeiro de Oliveira</td>
			<td>%</td>
		</tr>
	</tbody>
</table>

## Installation and execution
Besides having SICS installed, there are no further installations required. All that's needed is to load the program into SICS, and to run the command 'play.'

## Game description
### Rules
Black plays first, then turns alternate. On each turn, players must complete one of the following actions:

 - Move a friendly singleton to an adjacent empty point.
 - Take a piece from a friendly group and place it on a different empty point adjacent to the same group. All stones that were joined in a single group before the move must still be joined after the move.

Every move must reduce the distance between the moved unit and the closest friendly unit. The distance between two units is the shortest path of adjacent empty points between them, i.e. the number of consecutive moves one would need to join them.

### Objective
If a player can't make a move on his turn, he wins. This usually occurs when said player has joined all his pieces in a single group.

### Draws
If a board position is repeated with the same player to move, the game will be declared a draw. This is a theoretical possibility if both players cooperate to it. You can find an example of a possible core of such a cooperative cycle in About Ayu. In actual play cooperative cycles do not occur.

## Game Logic
### Game Configuration Representation

To configure the game, the user is prompted with the choice of board size (11, 9 or 7) and what type each player will be:
 - Human player
 - Random AI: chooses a move at random
 - Greedy AI: chooses a move based on our 'value' function

Those being represented by 0, 1, or 2 respectively. 'initial_state/2' then takes these



describe the information required to represent the game
configuration, how it is represented internally and how it is used by the initial_state/2 predicate.

### Internal Game State Representation

Our game's state can be broken down into:
|Value|Description|
|   :--:   |:--|
|Cur_Player|The player that will play in the next round|
|Players| A list of two integers used to indicate wheter each player is a human or what level of AI|
|Board|A list with each piece's colour and position on the board|
|Size|The selected dimensions of the board|

And each entry in 'Board' can be represented as such:

|Value|Description|
|   :--:   |:--|
|Colour|Represents to what player each piece belongs, 'w' or 'b'|
|Position|A list of 2 integers to determine the coordinate of the piece|

# ADD EXAMPLES HERE
### Move Representation

### User Interaction
Our game utilizes a very simple menu system, providing a main menu where one can access the rules of the game, quit the program, or start a game, the last opening a submenu to choose what type each player will be. The user can navigate them by using one of the prompted inputs, this choice makes the validation of inputs for the menu quite elementary, asking for a new input in case of on invalid one.

During the game itself the user inputs their move in the format 'Column_Origin'/'Row_Origin'-'Column_Target'/'Row_Target' (ex. b/1-b/2).
## Conclusions

## Bibliography
[Ayu](https://www.mindsports.nl/index.php/arena/ayu)