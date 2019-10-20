// Create landing tab and headline headline
const landing = document.createElement('article');
landing.id = 'landing';
const headline = document.createElement('h1');
headline.className = "headline";
headline.innerText = "Welcome";

// Create landing tab contents
const bannerLarge = document.createElement('img');
bannerLarge.src = "catalina_banner_large.jpg";
bannerLarge.id = 'banner_large';
const bannerSmall = document.createElement('img');
bannerSmall.src = "catalina_banner_small.jpg";
bannerSmall.id = 'banner_small';
const description = document.createElement('p');
description.innerText = "The premier helecopter leasing event.";
description.id = 'description';

// Add landing tab to DOM (on pageload)
function initializeLanding() {
	const contentDiv = document.querySelector('div#content');
	contentDiv.appendChild(landing);
	landing.appendChild(headline);
}

function generateLanding() {
	if (landing.className != 'active') {
		landing.appendChild(bannerLarge);
		landing.appendChild(bannerSmall);
		landing.appendChild(description);

		landing.className = 'active';
	}
}

function degenerateLanding() {
	if (landing.className != 'inactive') {
		landing.removeChild(bannerLarge);
		landing.removeChild(bannerSmall);
		landing.removeChild(description);

		landing.className = 'inactive';
	}
}

export { landing, initializeLanding, generateLanding, degenerateLanding };