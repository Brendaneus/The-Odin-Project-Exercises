function add (addendA, addendB) {
	return addendA + addendB;
}

function subtract (minuend, subtrahend) {
	return minuend - subtrahend;
}

function sum (addends) {
	let total = 0;
	addends.forEach(addend => total += addend);
	return total;
}

function multiply (multipliers) {
	if (!multipliers[0])
		return;	
	let product = 1;
	multipliers.forEach(multiplier => product *= multiplier);
	return product;
}

function power(base, exponent) {
	if(exponent === 0)
		return 1;
	return base * power(base, --exponent);
}

function factorial(value) {
	if(value === 0)
		return 1;
	return value * factorial(--value);
}

module.exports = {
	add,
	subtract,
	sum,
	multiply,
    power,
	factorial
}