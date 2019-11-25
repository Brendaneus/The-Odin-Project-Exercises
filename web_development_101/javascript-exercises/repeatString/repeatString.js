var repeatString = function(phrase, num) {
	if (num < 0) return 'ERROR';

	let output = '';
	for (let i = 0; i < num; i++) {
		output += phrase;
	}
	return output;
}

module.exports = repeatString
