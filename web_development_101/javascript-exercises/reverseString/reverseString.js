var reverseString = function(phrase) {
	let output = '';
	for (let i = 1; i <= phrase.length; i++) {
		output += phrase.charAt(phrase.length - i);
	}
	return output;
}

module.exports = reverseString