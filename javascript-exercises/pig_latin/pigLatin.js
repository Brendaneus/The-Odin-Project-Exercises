function translate(phrase) {

	function isConsonant(char) {
		let code = char.charCodeAt(0);
		return ((((code >= 65) && (code <= 90)) || ((code >= 97) && (code <= 122))) && ((char != 'a') && (char != 'e') && (char != 'i') && (char != 'o') && (char != 'u')))
	}

	function firstConsonants(word) {
		let letters = Array.from(word);
		let first = 0;
		letters.some(function (letter, index) {
			if (isConsonant(letter))
				first++;
			else if((letter === 'u') && (index > 0) && ((letters[index - 1] === 'q') || (letters[index - 1] === 'Q'))) {
				first++;
				return true;
			}
			return !isConsonant(letter);
		})
		return first;
	}

	let result = phrase.split(' ');

	result.forEach(function (word, index) {
		let start = firstConsonants(word)
		word = word.slice(start) + word.slice(0, start);
		
		result[index] = word + 'ay';
	})	

	return result.join(' ');
}


module.exports = {
	translate
}

