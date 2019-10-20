// Create contact tab and headline
const contact = document.createElement('article');
contact.id = 'contact';
const headline = document.createElement('h1');
headline.className = "headline";
headline.innerText = "Contact";

// Create contact tab content
const phoneNumber = document.createElement('p');
phoneNumber.innerText = "Please call for more information: 508-543-7962";

// Add contact tab to DOM (on pageload)
function initializeContact() {
	const contentDiv = document.querySelector('div#content');
	contentDiv.appendChild(contact);
	contact.appendChild(headline);
}

function generateContact() {
	if (contact.className != 'active') {
		contact.appendChild(phoneNumber);

		contact.className = "active";
	}
}

function degenerateContact() {
	if (contact.className != 'inactive') {
		contact.removeChild(phoneNumber);

		contact.className = "inactive";
	}
}

export { contact, initializeContact, generateContact, degenerateContact };