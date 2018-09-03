var snakeCase = function(phrase) {
	let result = Array.from(phrase);
	for (var i = result.length - 1; i >= 0; i--) {
		if ((result[i] === ' ') || (result[i] === '-'))
			result[i] = '_';
		else if (result[i] === '_')
			continue;
		else if ((97 <= result[i].charCodeAt(0)) && (result[i].charCodeAt(0) <= 122))
			continue;
		else if ((65 <= result[i].charCodeAt(0)) && (result[i].charCodeAt(0) <= 90)) {
			if ((i >= 2) && ((97 <= result[i - 1].charCodeAt(0)) && (result[i - 1].charCodeAt(0) <= 122)) && !((65 <= result[i - 2].charCodeAt(0)) && (result[i - 2].charCodeAt(0) <= 90))) {
				result[i] = result[i].toLowerCase();
				result.splice(i, 0, '_');
			}
			else
				result[i] = String.fromCharCode(result[i].charCodeAt(0) + 32);
		}
		else if ((result[i] === '.') && (((65 <= result[i - 1].charCodeAt(0)) && (result[i - 1].charCodeAt(0) <= 90)) || ((97 <= result[i - 1].charCodeAt(0)) && (result[i - 1].charCodeAt(0) <= 122))))
			result[i] = '_';
		else
			result.splice(i, 1);
	}
	while (result[result.length - 1] === '_')
		result.pop();
	
	return result.join('');
}

module.exports = snakeCase
