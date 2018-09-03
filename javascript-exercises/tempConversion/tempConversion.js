var ftoc = function(input) {
	return Math.round((input - 32) * (5 / 9) * 10) / 10;
}

var ctof = function(input) {
	return Math.round((input * (9 / 5) + 32) * 10) / 10;
}

module.exports = {
  ftoc,
  ctof
}
