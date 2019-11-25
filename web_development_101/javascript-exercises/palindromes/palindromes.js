var palindromes = function(phrase) {
	return (phrase.replace(/[^\w]/g, '').toLowerCase() === phrase.replace(/[^\w]/g, '').toLowerCase().split('').reverse().join(''));
}

module.exports = palindromes
