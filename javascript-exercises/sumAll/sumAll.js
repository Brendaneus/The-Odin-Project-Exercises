var sumAll = function(a, b) {
	if (((a || b) < 0) || ((typeof a !== 'number') || typeof b !== 'number')) return 'ERROR';
	let sum = 0;
	let lesser = (a < b)? a : b;
	let greater = (a > b)? a : b;
	for (let i = lesser; i <= greater; i++) {
		sum += i;
	}
	return sum;
}

module.exports = sumAll
