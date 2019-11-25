import _ from 'lodash';
import './style.css';
import Icon from './icon.png';

function component() {
	const element = document.createElement('div');

	// Lodash required
	element.innerHTML = _.join(['Hello', 'webpack'], ' ');
	element.classList.add('hello');

	// Local image
	const myIcon = new Image();
	myIcon.src = Icon;

	element.appendChild(myIcon);

	return element;
}

document.body.appendChild(component());
