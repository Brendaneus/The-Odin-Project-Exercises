var removeFromArray = function(input, removal) {
	let args = Array.from(arguments);
	let output = input;
	for (let c = 1; c < args.length; c++) {
		for (let i = 0; i < input.length; i++) {
			if (input[i] === args[c]) output.splice(i--, 1);
		}
	}
	return output;
}

module.exports = removeFromArray
