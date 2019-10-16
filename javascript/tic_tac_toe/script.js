// Browser uses Display API to interact indirectly with Gameboard object,
// which handles input and sends response back to Display API.

// Controls all gameplay logic, independent of DOM
// Stores references to player objects in gameboard slots
const Gameboard = (function() {
	const gameboard = [[null,null,null],[null,null,null],[null,null,null]];
	// space-to-coordinate index
	const spaceRowCol = {
		topLeft: [0,0],
		topCenter: [0,1],
		topRight: [0,2],
		midLeft: [1,0],
		midCenter: [1,1],
		midRight: [1,2],
		botLeft: [2,0],
		botCenter: [2,1],
		botRight: [2,2]
	};
	// All possible matches, their coordinates in the gameboard, matched states, and viability
	// Add "possible" for AI
	const matches = {
		"Top Row": {coords: [[0,0], [0,1], [0,2]], matched: false},
		"Middle Row": {coords: [[1,0], [1,1], [1,2]], matched: false},
		"Bottom Row": {coords: [[2,0], [2,1], [2,2]], matched: false},
		"Left Column": {coords: [[0,0], [1,0], [2,0]], matched: false},
		"Center Column": {coords: [[0,1], [1,1], [2,1]], matched: false},
		"Right Column": {coords: [[0,2], [1,2], [2,2]], matched: false},
		"Left Diagonal": {coords: [[0,0], [1,1], [2,2]], matched: false},
		"Right Diagonal": {coords: [[0,2], [1,1], [2,0]], matched: false}
	};
	// Player object references
	const player = {
		one: null,
		two: null
	};
	let matched = false; // win state
	let turnOne = true; // turn counter

	// Check all possible matches (there's only 8 and I'm feeling lazy)
	const checkMatch = function() {
		for (let match in matches) {
			let coords = matches[match].coords; // three gameboard coordinates in match sequence
			let matchingPlayer = gameboard[coords[0][0]][coords[0][1]] // first player in matching sequence

			if (matches[match].matched == true) continue; // already matched
			if (!matchingPlayer) continue; // falsy values
			if (!matchingPlayer.hasOwnProperty('getName')) continue; // invalid player object

			// Check first player in sequence against second and third for a complete match
			if ( (matchingPlayer == gameboard[coords[1][0]][coords[1][1]]) &&
				(matchingPlayer == gameboard[coords[2][0]][coords[2][1]]) ) {
				matchingPlayer.addScore( (matched) ? 1 : 3 ); // Add score to winning player

				// Display match and log to console
				console.log(`${matchingPlayer.getName()} made ${(matched) ? 'another' : 'a'} Match!`);
				console.log(match);
				DisplayController.updateMessage(`${matchingPlayer.getName()} made ${(matched) ? 'another' : 'a'} Match!`);
				DisplayController.updateScore((turnOne) ? 'one' : 'two', matchingPlayer);

				matches[match].matched = true; // set match combo state to matched
				matched = true; // ...and the board too
			}
		}
		return;
	};

	// Attempt a match at given gameboard coordinates
	const tryRowCol = function(row, col) {
		let currentPlayer = (turnOne) ? player.one : player.two; // Set current player according to turn
		
		// Check if player slot has been assigned
		if (currentPlayer == null) {
			console.log("Assign this player to make a move.");
			return;
		}

		// Assign space to player if not already taken, and check for a match
		if (gameboard[row][col] == null) {
			gameboard[row][col] = currentPlayer;
			let space = DisplayController.getSpaceAt(row, col);
			DisplayController.markSpace(currentPlayer.getMark(), space); 
			checkMatch(); // check for possible winning match
			turnOne = !turnOne; // toggle turn for next player
		} else {
			console.log(`That space is occupied.`);
		}
	};

	////////////////////////////////////////////////////////////////////////////////////////////// TODO: set gameover counter when all spaces are filled
	// Reset entire gameboard to starting null values and reset winning counter
	const clearBoard = function() {
		for (let row in gameboard) {
			for (let col in gameboard[row]) {
				gameboard[row][col] = null;
			}
		}
		for (let match in matches) {
			matches[match].matched = false;
		}
		matched = false;
		// gameover = false;
		DisplayController.renderBoard(gameboard);
		DisplayController.updateMessage("Board Reset");
		console.log("Board Cleared.");
	};

	return {
		getGameboard: () => { return gameboard },
		getRowColAt: (space) => { return spaceRowCol[space] },
		tryRowCol: tryRowCol,
		clearBoard: clearBoard,
		getPlayerOne: () => { return player.one },
		setPlayerOne: (playerOne) => { player.one = playerOne },
		getPlayerTwo: () => { return player.two },
		setPlayerTwo: (playerTwo) => { player.two = playerTwo }
	};
})();

// Controls all display logic, purely serves as an API for DOM & window
// Will need to: listen to window events and call Gameboard functions
const DisplayController = (function() {
	const gameboard = document.querySelector('.gameboard');
	// DOM references for each space
	const spaces = {
		topLeft: gameboard.querySelector('#top-left'),
		topCenter: gameboard.querySelector('#top-center'),
		topRight: gameboard.querySelector('#top-right'),
		midLeft: gameboard.querySelector('#mid-left'),
		midCenter: gameboard.querySelector('#mid-center'),
		midRight: gameboard.querySelector('#mid-right'),
		botLeft: gameboard.querySelector('#bot-left'),
		botCenter: gameboard.querySelector('#bot-center'),
		botRight: gameboard.querySelector('#bot-right')
	};
	// coordinate-to-space index
	const rowColSpace = [
		['topLeft', 'topCenter', 'topRight'],
		['midLeft', 'midCenter', 'midRight'],
		['botLeft', 'botCenter', 'botRight']
	];
	// DOM references for both players' score display
	const player = {
		one: {
			container: document.querySelector('#playerOne'),
			name: document.querySelector('#playerOne .name'),
			score: document.querySelector('#playerOne .score'),
			reset: document.querySelector('#playerOne .reset')
		},
		two: {
			container: document.querySelector('#playerTwo'),
			name: document.querySelector('#playerTwo .name'),
			score: document.querySelector('#playerTwo .score'),
			reset: document.querySelector('#playerTwo .reset')
		}
	};
	const messageDisplay = document.querySelector('#message'); // Feedback display
	const clearButton = document.querySelector('#clear'); // Gameboard clearing button

	// Set Gameboard's player one name to match DOM
	const updatePlayerOne = function() {
		let playerOneObj = Gameboard.getPlayerOne();
		// Reset DOM to current name if new name is unavailable
		if ( !playerOneObj.setName(player.one.name.value) )
			player.one.name.value = playerOneObj.getName();
	};
	// Set Gameboard's player two name to match DOM
	const updatePlayerTwo = function() {
		let playerTwoObj = Gameboard.getPlayerTwo();
		// Reset DOM to current name if new name is unavailable
		if ( !playerTwoObj.setName(player.two.name.value) )
			player.two.name.value = playerTwoObj.getName();
	};
	// Reset Gameboard's player one score to zero and update DOM to match
	const resetPlayerOne = function() {
		Gameboard.getPlayerOne().resetScore();
		player.one.score.innerText = 0;
	};
	// Reset Gameboard's player one score to zero and update DOM to match
	const resetPlayerTwo = function() {
		Gameboard.getPlayerTwo().resetScore();
		player.two.score.innerText = 0;
	};

	// Update player names with input change and reset scores on button clicks
	player.one.name.addEventListener('change', updatePlayerOne);
	player.one.reset.addEventListener('click', resetPlayerOne);
	player.two.name.addEventListener('change', updatePlayerTwo);
	player.two.reset.addEventListener('click', resetPlayerTwo);
	// Attempt a move whenever a space is clicked
	for (let space in spaces) {
		spaces[space].addEventListener('click', function() {
			Gameboard.tryRowCol(...(Gameboard.getRowColAt(space)));
		});
	}
	// Clear Gameboard and Display when button clicked
	clearButton.addEventListener('click', Gameboard.clearBoard);

	return {
		renderBoard: function(boardArray) {
			for(let i = 0; i < 9; i++) {
				spaces[rowColSpace[Math.floor(i / 3)][i % 3]].innerText = boardArray[Math.floor(i / 3)][i % 3];
			}
		},
		getSpaceAt: (row, col) => { return rowColSpace[row][col] },
		markSpace: function (mark, space) {
			if (spaces.hasOwnProperty(space)) {
				spaces[space].innerText = mark;
			} else {
				console.log(`No such space: '${space}'`);
			}
		},
		getPlayerOneName: () => { return player.one.name.value },
		getPlayerTwoName: () => { return player.two.name.value },
		updateMessage: (message) => { messageDisplay.innerText = message },
		updateScore: (num, object) => { player[num].score.innerText = object.getScore() }
	};
})();

var playerList = []; // List of players in use; for uniqueness checks

// Builds unique player object with name, mark, and score attributes
const PlayerFactory = function(newName, newMark) {
	let name, mark;
	let score = 0;

	// Checks if name is in use
	const setName = function(newName) {
		for (let index in playerList) {
			if (playerList[index].getName() == newName) {
				console.log("Name already taken.");
				return false;
			}
		}
		name = newName;
		return true;
	}
	// Checks if mark is in use
	const setMark = function(newMark) {
		for (let index in playerList) {
			if (playerList[index].getMark() == newMark) {
				console.log("Mark already taken.");
				return false;
			}
		}
		mark = newMark;
		return true;
	}

	// Checks uniqueness; Displays both error messages when possible
	validName = setName(newName);
	validMark = setMark(newMark);
	if (!validName || !validMark) return;

	let newPlayer = {
		getName: () => { return name },
		setName: setName,
		getMark: () => { return mark },
		setMark: setMark,
		getScore: () => { return score },
		addScore: (add=1) => { score += add },
		resetScore: () => { score = 0 }
	};
	playerList.push(newPlayer); // Add player object to collection

	return newPlayer;
}

// Get two players from DOM and assign to player one and two
Gameboard.setPlayerOne( PlayerFactory(DisplayController.getPlayerOneName(), 'X') );
Gameboard.setPlayerTwo( PlayerFactory(DisplayController.getPlayerTwoName(), 'O') );
DisplayController.renderBoard(Gameboard.getGameboard());

// TODO: Implement AI, add mark customization, clean up code
