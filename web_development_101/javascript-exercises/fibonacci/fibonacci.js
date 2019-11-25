var fibonacci = function(number) {
	if (number < 0)
		return 'OOPS';

	let total = 0;
	let totalBuffer;
	let totalOld;
	for (let i = 1; i < number; i++) {
		totalBuffer = total;
		total += totalOld || 1;
		totalOld = totalBuffer;
	}
	return total;
}

module.exports = fibonacci
