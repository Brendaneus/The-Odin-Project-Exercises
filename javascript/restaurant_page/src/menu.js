// Create menu tab and headline
const menu = document.createElement('article');
menu.id = 'menu';
const headline = document.createElement('h1');
headline.className = "headline";
headline.innerText = "Menu";

// Create menu tab content
const listings = document.createElement('section');
listings.id = 'listings';
const scout = document.createElement('p');
scout.innerText = "Scout Helecopter";
const transport = document.createElement('p');
transport.innerText = "Transport Helecopter";
const attack = document.createElement('p');
attack.innerText = "Attack Helecopter";
listings.appendChild(scout);
listings.appendChild(transport);
listings.appendChild(attack);

// Add menu tab to DOM (on pageload)
function initializeMenu() {
	const contentDiv = document.querySelector('div#content');
	contentDiv.appendChild(menu);
	menu.appendChild(headline);
}

function generateMenu() {
	if (menu.className != 'active') {
		menu.appendChild(listings);

		menu.className = "active";
	}
}

function degenerateMenu() {
	if (menu.className != 'inactive') {
		menu.removeChild(listings);

		menu.className = "inactive";
	}
}

export { menu, initializeMenu, generateMenu, degenerateMenu };