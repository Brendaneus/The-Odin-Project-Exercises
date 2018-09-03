var caesar = function(phrase, shift) {
	let result = Array.from(phrase);
	result.forEach(function (item, index) {
		let code = item.charCodeAt(0);
		let direction = Math.sign(shift);
		if (((code >= 65) && (code <= 90)) || ((code >= 97) && (code <= 122))) {
			for(let i = 0; i < Math.abs(shift); i++) {
				if (((code + direction) === 64) || ((code + direction) === 91) || ((code + direction) === 96) || ((code + direction) === 123))
					code += -(25 * direction);
				else
					code += direction;
			}
			result[index] = String.fromCharCode(code);
		}
	})

	return result.join('');
}

module.exports = caesar
