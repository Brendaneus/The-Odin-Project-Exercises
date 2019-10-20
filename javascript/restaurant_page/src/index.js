import { landing, initializeLanding, generateLanding, degenerateLanding } from './landing'
import { menu, initializeMenu, generateMenu, degenerateMenu } from './menu'
import { contact, initializeContact, generateContact, degenerateContact } from './contact'

function initializeTabs() {
	initializeLanding();
	initializeMenu();
	initializeContact();
	generateLanding();
	menu.className = 'inactive';
	contact.className = 'inactive';
}

function activateLanding() {
	generateLanding();
	degenerateMenu();
	degenerateContact();
}

function activateMenu() {
	degenerateLanding();
	generateMenu();
	degenerateContact();
}

function activateContact() {
	degenerateLanding();
	degenerateMenu();
	generateContact();
}

window.addEventListener('load', initializeTabs);
window.addEventListener('load', activateLanding);

landing.addEventListener('click', activateLanding);
menu.addEventListener('click', activateMenu);
contact.addEventListener('click', activateContact);