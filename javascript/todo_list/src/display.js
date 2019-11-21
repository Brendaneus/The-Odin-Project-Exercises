import { Interstruct } from './interstruct.js';

// Class controlling display and interaction in the DOM
class Display {
	constructor(interstruct) {
		// Did I do this yet??
		// TODO: REFACTOR TO RELY ON INTERSTRUCT CLASS FOR ALL CORE OBJECT USE
		// SOME PRIVATE VARIABLES IN USE IN CONSTRUCTOR; REFACTOR INTERSTRUCT TO REFLECT
		Display.enforceInitialize();
		this._interstruct = interstruct;
		this._name = interstruct.project.name;

		// Root Project element
		this._projectListing = document.createElement('div');
		this._projectListing.className = 'project';

		// Project Control Section
		var projectControl = document.createElement('div');
		projectControl.className = 'project_control';

		// Todo List Control Panel
		var infoPanel = document.createElement('fieldset');
		infoPanel.className = 'info_panel';

		// Project Checkbox
		this._projectCheckbox = document.createElement('input');
		this._projectCheckbox.className = 'project_checkbox';
		this._projectCheckbox.type = 'checkbox';
		this._projectCheckbox.checked = false;
		this._projectCheckbox.addEventListener('click', this.handleProjectCheckboxChange.bind(this));

		// Name Input
		this._projectName = document.createElement('input');
		this._projectName.className = 'project_name';
		this._projectName.value = interstruct.project.name;
		this._projectName.addEventListener('change', this.handleNameChange.bind(this));

		// Delete Button
		var deleteButton = document.createElement('button');
		deleteButton.className = 'delete';
		deleteButton.innerText = "Delete";
		deleteButton.addEventListener('click', this.handleProjectDeleteClick.bind(this));

		// Todo List Control Panel
		var todoListPanel = document.createElement('fieldset');
		todoListPanel.className = 'todo_list_panel';

		// New Todo Button
		var newTodoButton = document.createElement('button');
		newTodoButton.className = 'new';
		newTodoButton.innerText = 'Add Task';
		newTodoButton.addEventListener('click', this.handleNewTodoClick.bind(this));

		// Expand All Button
		var expandAllButton = document.createElement('button');
		expandAllButton.className = 'expand_all';
		expandAllButton.innerText = 'Expand All'
		expandAllButton.addEventListener('click', this.handleExpandAllClick.bind(this))

		// Collapse All Button
		var collapseAllButton = document.createElement('button');
		collapseAllButton.className = 'collapse_all';
		collapseAllButton.innerText = 'Collapse All'
		collapseAllButton.addEventListener('click', this.handleCollapseAllClick.bind(this))

		// Delete All Button
		var deleteAllButton = document.createElement('button');
		deleteAllButton.className = 'delete_all';
		deleteAllButton.innerText = 'Clear';
		deleteAllButton.addEventListener('click', this.handleDeleteAllClick.bind(this));

		// Todo List Sort Bar
		this._todoListSortBar = document.createElement('div');
		this._todoListSortBar.className = 'sort_todo_list';

		// Sort-by-Checked Button
		var sortCheckedButton = document.createElement('button');
		sortCheckedButton.className = 'sort_checked';
		sortCheckedButton.innerHTML = '&#10003;';
		sortCheckedButton.addEventListener('click', this.handleSortCheckedClick.bind(this));

		// Sort-by-Priority Button
		var sortPriorityButton = document.createElement('button');
		sortPriorityButton.className = 'sort_priority';
		sortPriorityButton.innerText = '#';
		sortPriorityButton.addEventListener('click', this.handleSortPriorityClick.bind(this));

		// Sort-by-Title Button
		var sortTitleButton = document.createElement('button');
		sortTitleButton.className = 'sort_title';
		sortTitleButton.innerText = 'Title';
		sortTitleButton.addEventListener('click', this.handleSortTitleClick.bind(this));

		// Sort-by-DueDate Button
		var sortDueDateButton = document.createElement('button');
		sortDueDateButton.className = 'sort_due_date';
		sortDueDateButton.innerText = 'Due Date';
		sortDueDateButton.addEventListener('click', this.handleSortDueDateClick.bind(this));

		// TODO: Create <progress> bar showing completion

		// Put together control panel elements
		projectControl.appendChild(infoPanel);
		projectControl.appendChild(todoListPanel);
		infoPanel.appendChild(this._projectCheckbox);
		infoPanel.appendChild(this._projectName);
		infoPanel.appendChild(deleteButton);
		todoListPanel.appendChild(newTodoButton);
		todoListPanel.appendChild(expandAllButton);
		todoListPanel.appendChild(collapseAllButton);
		todoListPanel.appendChild(deleteAllButton);
		todoListPanel.appendChild(this._todoListSortBar);
		this._todoListSortBar.appendChild(sortCheckedButton);
		this._todoListSortBar.appendChild(sortPriorityButton);
		this._todoListSortBar.appendChild(sortTitleButton);
		this._todoListSortBar.appendChild(sortDueDateButton);

		// Todo List
		this._todoList = document.createElement('div');
		this._todoList.className = 'todo_list';
		// ...and an internal collection of Todo display references
		this._listings = {};

		// Put together project display elements
		this._projectListing.appendChild(projectControl);
		this._projectListing.appendChild(this._todoList);

		// Add this display to project list section of DOM
		Display.projectList.appendChild(this._projectListing);

		// Add this display to master list
		Display.list[this._name] = this;
	}

	// Set root element and create base layout
	static initialize() {
		// Find and assign root element
		Display.main = document.querySelector('#display');
		if (Display.main === null) {
			throw Display.rootElementNotFoundError;
		}

		// Project Control Panel
		Display.projectControl = document.createElement('header');
		Display.projectControl.id = 'project_list_control';
		Display.main.appendChild(Display.projectControl);

		// Message Headline
		Display.messageHeadline = document.createElement('h2');
		Display.messageHeadline.id = 'message';
		Display.messageHeadline.className = 'notice';
		Display.messageHeadline.innerText = "Welcome";

		// New Project Button
		var createButton = document.createElement('button');
		createButton.className = 'create';
		createButton.innerText = "Create New Project";
		createButton.addEventListener('click', Display.handleCreateClick);

		// Delete All Button
		var deleteAllButton = document.createElement('button');
		deleteAllButton.className = 'delete_all';
		deleteAllButton.innerText = "Delete All";
		deleteAllButton.addEventListener('click', Display.handleDeleteAllClick);

		// Project Sorting Bar
		Display.projectSortBar = document.createElement('div');
		Display.projectSortBar.id = 'sort_projects';

		// Sort-by-Finished Button
		var sortFinishedButton = document.createElement('button');
		sortFinishedButton.className = 'sort_finished';
		sortFinishedButton.innerHTML = '&#10003;';
		sortFinishedButton.addEventListener('click', Display.handleSortFinishedClick);

		// Sort-by-Name Button
		var sortNameButton = document.createElement('button');
		sortNameButton.className = 'sort_name';
		sortNameButton.innerText = 'Name';
		sortNameButton.addEventListener('click', Display.handleSortNameClick);

		// Put together Project Control Panel
		Display.projectControl.appendChild(Display.messageHeadline);
		Display.projectControl.appendChild(createButton);
		Display.projectControl.appendChild(deleteAllButton);
		Display.projectSortBar.appendChild(sortFinishedButton);
		Display.projectSortBar.appendChild(sortNameButton);
		Display.projectControl.appendChild(Display.projectSortBar);

		// Project List Display
		Display.projectList = document.createElement('section');
		Display.projectList.id = 'project_list';
		Display.main.appendChild(Display.projectList);

		// Mark Display as initialized
		Display._initialized = true;
	}

	// Ensure Display area has been prepared
	static enforceInitialize() {
		if (!Display._initialized) {
			throw Display.uninitializedError;
		}
	}

	// Check if object is an instance of Display class
	static validInstance(object) {
		return (object instanceof Display);
	}

	// Check if any Displays are listed
	static listEmpty() {
		return Display.list.length == 0;
	}

	// Check if Display is in master list
	static listed(display) {
		Display.enforceInitialize();

		for (let name in Display.list) {
			if (Display.list[name] === display) {
				return true;
			}
		}
		return false;
	}

	// Check if Display is on DOM
	static DOMlisted(display) {
		Display.enforceInitialize();

		var listings = Display.projectList.children;

		for (let i = 0; i < listings.length; i++) {
			if (listings[i] == display._projectListing) {
				return true;
			}
		}
		return false;
	}

	// TODO: Check for missing DOM elements -- (Here in particular???)
	// Delete Display from DOM and remove from master list
	static delete(display) {
		if (!Display.validInstance(display)) {
			throw new Error(`Object: '${display}' is not a valid instance of the Display class.`)
		} else if (Display.listEmpty()) {
			throw Display.listEmptyError;
		} else if (!Display.listed(display)) {
			throw new Error(`Display: '${display.name}' is not currently listed.`)
		} else {
			Display.projectList.removeChild(display._projectListing);
			delete Display.list[display.name];
		}
	}

	// Remove listed Display from DOM -- sorting tool
	static remove(display) {
		if (!Display.validInstance(display)) {
			throw new Error(`Object: '${display}' is not a valid instance of the Display class.`)
		} else if (Display.listEmpty()) {
			throw Display.listEmptyError;
		} else if (!Display.listed(display)) {
			throw new Error(`Display: '${display.name}' is not currently listed.`)
		} else if (!Display.DOMlisted(display)) {
			throw new Error(`Display: '${display.name}' is not currently being displayed.`)
		} else {
			Display.projectList.removeChild(display._projectListing);
		}
	}

	// Replace listed Display on DOM -- sorting tool
	static replace(display) {
		if (!Display.validInstance(display)) {
			throw new Error(`Object: '${display}' is not a valid instance of the Display class.`)
		} else if (!Display.listed(display)) {
			throw new Error(`Display: '${display.name}' is not currently listed.`)
		} else if (Display.DOMlisted(display)) {
			throw new Error(`Display: '${display.name}' is already being displayed.`)
		} else {
			Display.projectList.appendChild(display._projectListing);
		}
	}

	// Update Headline message and type
	static updateMessage(newMessage, type='notice') {
		// Force browser to reload Headline's class and reset animation
		Display.messageHeadline.className = '';
		void Display.messageHeadline.offsetWidth;

		Display.messageHeadline.innerText = newMessage;
		if (type === 'congrat') {
			Display.messageHeadline.className = 'congrat';
		} else if (type === 'error') {
			Display.messageHeadline.className = 'error';
		} else {
			Display.messageHeadline.className = 'notice';
		}
	}

	// Update Sort-by-Finished Button class
	static setFinishedSort(mode) {
		var sortFinishedButton = Display.projectSortBar.querySelector('button.sort_finished');
		
		if (mode == 'ascending') {
			sortFinishedButton.className = 'sort_finished ascending';
		} else if (mode == 'descending') {
			sortFinishedButton.className = 'sort_finished descending';
		} else {
			sortFinishedButton.className = 'sort_finished';
		}
	}
	
	// Update Sort-by-Name Button class
	static setNameSort(mode) {
		var sortNameButton = Display.projectSortBar.querySelector('button.sort_name');

		if (mode == 'ascending') {
			sortNameButton.className = 'sort_name ascending';
		} else if (mode == 'descending') {
			sortNameButton.className = 'sort_name descending';
		} else {
			sortNameButton.className = 'sort_name';
		}
	}

	// Handle New Project Button 'click' event
	static handleCreateClick() {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			new Interstruct();
			
			Display.handlingEvent = false;
		}
	}

	// Handle Delete All Button 'click' event
	static handleDeleteAllClick() {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			Interstruct.deleteAll();
			
			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Sort-by-Finished Button 'click' event
	static handleSortFinishedClick() {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			Interstruct.sortFinished();

			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Sort-by-Name Button 'click' event
	static handleSortNameClick() {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			Interstruct.sortName();

			Display.handlingEvent = false;
		}
	}

	get name() {
		return this._name;
	}

	set name(newName) {
		// TODO: Build this function for redundancy checks
		// if (!Display.nameAvailable(newName)) {
		// 	throw new Error(`Name: '${newName}' is already in use.`)
		// }

		var oldName = this._name;

		try {
			this._name = newName;
			this._projectName.value = newName;
		} catch(err) {
			this._projectName.value = oldName;
			this._name = oldName;
			throw new Error(err.message);
		}

		if (newName != oldName) {
			Display.list[newName] = this;
			delete Display.list[oldName];
		}
	}

	finished() {
		return this._projectCheckbox.checked;
	}

	unfinished() {
		return !this.finished();
	}

	finish() {
		if (this.finished()) {
			throw new Error(`Project: '${this.name}' is already finished.`);
		} else {
			this._projectCheckbox.checked = true;
		}
	}

	unfinish() {
		if (this.unfinished()) {
			throw new Error(`Project: '${this.name}' has not been finished.`);
		} else {
			this._projectCheckbox.checked = false;
		}
	}

	// TODO: Change this to use Display listings like static method?
	// Check if Todo is in Display todo list
	listed(title) {
		return (title in this._listings);
	}

	// TODO: listEmpty function?

	// Check if Todo is on DOM
	DOMlisted(listing) {
		var listings = this._todoList.children;

		for (let i = 0; i < listings.length; i++) {
			if (listings[i] == listing) {
				return true;
			}
		}
		return false;
	}

	// Create display for todo and add to display todo list
	list(todo) {
		if (this.listed(todo.title)) {
			throw new Error(`Todo: '${todo.title}' is already listed in the project display.`);
		}

		var listing = document.createElement('fieldset');
		listing.className = 'todo';
		listing.id = todo.title;

		var checkbox = document.createElement('input');
		checkbox.className = 'checkbox';
		checkbox.type = 'checkbox';
		checkbox.checked = todo.checked();
		checkbox.addEventListener('change', this.handleTodoCheckboxChange.bind(this, listing));

		var priority = document.createElement('input');
		priority.className = 'priority';
		priority.type = 'number';
		priority.min = 1;
		priority.max = 5;
		priority.value = todo.priority;
		priority.addEventListener('change', this.handleTodoPriorityChange.bind(this, listing));

		var title = document.createElement('input');
		title.className = 'title';
		title.value = todo.title;
		title.addEventListener('change', this.handleTodoTitleChange.bind(this, listing));

		var dueDate = document.createElement('input');
		dueDate.className = 'due_date';
		dueDate.type = 'date';
		if (todo.hasDate()) {
			dueDate.valueAsDate = todo.dueDate;
		}
		dueDate.addEventListener('change', this.handleTodoDueDateChange.bind(this, listing));

		var deleteButton = document.createElement('button');
		deleteButton.className = 'delete';
		deleteButton.innerText = "X";
		deleteButton.addEventListener('click', this.handleTodoDeleteClick.bind(this, listing));

		var collapsable = document.createElement('div');
		collapsable.className = 'collapsed collapsable';

		var description = document.createElement('textarea');
		description.className = 'description';
		description.value = todo.description;
		description.addEventListener('change', this.handleTodoDescriptionChange.bind(this, listing));

		var dropDownBar = document.createElement('button');
		dropDownBar.className = 'dropdown';
		dropDownBar.innerText = 'expand';
		dropDownBar.addEventListener('click', this.handleTodoDropdownClick.bind(this, listing));

		listing.appendChild(checkbox);
		listing.appendChild(priority);
		listing.appendChild(title);
		listing.appendChild(dueDate);
		listing.appendChild(deleteButton);
		listing.appendChild(collapsable);
		collapsable.appendChild(description);
		collapsable.appendChild(dropDownBar);
		this._todoList.appendChild(listing);
		this._listings[todo.title] = listing;
	}

	// Get Todo listing from Display by name
	get(title) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		return this._listings[title];
	}

	// TODO: Remove Todo listing from Display
	remove(listing) {
		var title = listing.querySelector('input.title').value;
		
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the Project display.`);
		} else if (!this.DOMlisted(listing)) {
			throw new Error(`Display: '${title} is not currently being displayed.`)
		} else {
			this._todoList.removeChild(listing);
		}
	}

	// TODO: Replace Todo listing on Display
	replace(listing) {
		var title = listing.querySelector('input.title').value;
		
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the Project display.`);
		} else if (this.DOMlisted(listing)) {
			throw new Error(`Display: '${title} is already being displayed.`)
		} else {
			this._todoList.appendChild(listing);
		}
	}

	// Check if todo on list is checked
	checked(title) {
		return this._listings[title].querySelector('.checkbox').checked;
	}

	// Check if todo on list is checked
	unchecked(title) {
		return !this._listings[title].querySelector('.checkbox').checked;
	}

	// Check a Todo listing
	check(title) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		} else if (this.checked(title)) {
			throw new Error(`Todo: '${title}' is already checked off.`);
		} else {
			this._listings[title].querySelector('.checkbox').checked = true;
		}
	}

	// Uncheck a Todo listing
	uncheck(title) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		} else if (this.unchecked(title)) {
			throw new Error(`Todo: '${title}' is not checked off.`);
		} else {
			this._listings[title].querySelector('.checkbox').checked = false;
		}
	}

	// Update Todo listing priority
	changePriority(title, newPriority) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		this._listings[title].querySelector('.priority').value = newPriority;
	}

	// Update Todo listing reference and title display
	changeTitle(title, newTitle) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		var listing = this._listings[title];
		var listingTitle = listing.querySelector('.title');

		listing.id = newTitle;
		listingTitle.value = newTitle;

		this._listings[newTitle] = listing;
		if (title != newTitle) {
			delete this._listings[title];
		}
	}

	// Update Todo listing due date
	changeDueDate(title, newDate) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		this._listings[title].querySelector('.due_date').valueAsDate = newDate;
	}

	// Update Todo listing description
	changeDescription(title, newDescription) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		this._listings[title].querySelector('.description').value = newDescription;
	}

	// Delete todo listing from Project Todo List Display
	delete(title) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		var listing = this._listings[title];
		this._todoList.removeChild(listing);

		delete this._listings[title];
	}

	// Toggle a Todo listing's details between collapsed and expanded
	toggleCollapsable(title) {
		if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in the project display.`);
		}

		if (this.collapsed(title)) {
			this.expand(title);
		} else {
			this.collapse(title);
		}
	}

	// Check if Todo listing's details are collapsed
	collapsed(title) {
		return this._listings[title].querySelector('.collapsable').className == 'collapsed collapsable';
	}

	// Expand a Todo listing's details
	expand(title) {
		var collapsable = this._listings[title].querySelector('.collapsable');
		var dropdownBar = collapsable.querySelector('.dropdown');

		collapsable.className = 'expanded collapsable';
		dropdownBar.innerText = 'collapse';
	}

	// Collapse a Todo listing's details
	collapse(title) {
		var collapsable = this._listings[title].querySelector('.collapsable');
		var dropdownBar = collapsable.querySelector('.dropdown');

		collapsable.className = 'collapsed collapsable';
		dropdownBar.innerText = 'expand';
	}

	setCheckedSort(mode) {
		var sortCheckedButton = this._todoListSortBar.querySelector('button.sort_checked');

		if (mode == 'ascending') {
			sortCheckedButton.className = 'sort_checked ascending';
		} else if (mode == 'descending') {
			sortCheckedButton.className = 'sort_checked descending';
		} else {
			sortCheckedButton.className = 'sort_checked';
		}
	}

	setPrioritySort(mode) {
		var sortPriorityButton = this._todoListSortBar.querySelector('button.sort_priority');

		if (mode == 'ascending') {
			sortPriorityButton.className = 'sort_priority ascending';
		} else if (mode == 'descending') {
			sortPriorityButton.className = 'sort_priority descending';
		} else {
			sortPriorityButton.className = 'sort_priority';
		}
	}

	setTitleSort(mode) {
		var sortTitleButton = this._todoListSortBar.querySelector('button.sort_title');

		if (mode == 'ascending') {
			sortTitleButton.className = 'sort_title ascending';
		} else if (mode == 'descending') {
			sortTitleButton.className = 'sort_title descending';
		} else {
			sortTitleButton.className = 'sort_title';
		}
	}

	setDueDateSort(mode) {
		var sortDueDateButton = this._todoListSortBar.querySelector('button.sort_due_date');

		if (mode == 'ascending') {
			sortDueDateButton.className = 'sort_due_date ascending';
		} else if (mode == 'descending') {
			sortDueDateButton.className = 'sort_due_date descending';
		} else {
			sortDueDateButton.className = 'sort_due_date';
		}
	}

	// Handle Project Checkbox 'click' event
	handleProjectCheckboxChange(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.toggleAll();
			
			Display.handlingEvent = false;
		}
	}

	// Handle Project Name 'change' event
	handleNameChange(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.changeName(this._projectName.value);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Project Delete Button 'click' event
	handleProjectDeleteClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			Interstruct.delete(this._interstruct.project.name);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo List New Button 'click' event
	handleNewTodoClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.createTodo();
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo List Collapse All Button 'click' event
	handleCollapseAllClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			for (let title in this._listings) {
				this.collapse(title);
			}
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo List Collapse All Button 'click' event
	handleExpandAllClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			for (let title in this._listings) {
				this.expand(title);
			}
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo List Delete All Button 'click' event
	handleDeleteAllClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.deleteAll();
			
			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Todo List Sort-by-Checked Button 'click' event
	handleSortCheckedClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			this._interstruct.sortChecked();

			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Todo List Sort-by-Priority Button 'click' event
	handleSortPriorityClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			this._interstruct.sortPriority();

			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Todo List Sort-by-Title Button 'click' event
	handleSortTitleClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			this._interstruct.sortTitle();

			Display.handlingEvent = false;
		}
	}

	// TODO: Handle Todo List Sort-by-Due Date Button 'click' event
	handleSortDueDateClick(e) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;

			this._interstruct.sortDueDate();

			Display.handlingEvent = false;
		}
	}

	// Handle Todo Checkbox 'change' event
	handleTodoCheckboxChange(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.toggle(listing.id);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Priority 'change' event
	handleTodoPriorityChange(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			var priority = listing.querySelector('.priority');
			this._interstruct.changePriority(listing.id, parseInt(priority.value, 10));
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Title 'change' event
	handleTodoTitleChange(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			var title = listing.querySelector('.title');
			this._interstruct.changeTitle(listing.id, title.value);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Due Date 'change' event
	handleTodoDueDateChange(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			var dueDate = listing.querySelector('.due_date');
			var utcDate = dueDate.valueAsDate;
			if (utcDate != null) {
				var newDate = new Date(utcDate.getUTCFullYear(), utcDate.getUTCMonth(), utcDate.getUTCDate());
			} else {
				var newDate = null;
			}
			this._interstruct.changeDueDate(listing.id, newDate);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Delete Button 'click' event
	handleTodoDeleteClick(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this._interstruct.delete(listing.id);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Description 'change' event
	handleTodoDescriptionChange(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			var description = listing.querySelector('.description');
			this._interstruct.changeDescription(listing.id, description.value);
			
			Display.handlingEvent = false;
		}
	}

	// Handle Todo Dropdown 'click' event
	handleTodoDropdownClick(listing) {
		if (!Display.handlingEvent) {
			Display.handlingEvent = true;
			
			this.toggleCollapsable(listing.id);
			
			Display.handlingEvent = false;
		}
	}
}

Display.main; // root element
Display.projectControl; // project control panel
Display.messageHeadline; // feedback headline
Display.projectSortBar; // project sorting bar
Display.projectList; // project list
Display.list = {}; // master list of project displays
Display._initialized = false;
Display.handlingEvent = false;
Display.uninitializedError = new Error("Display has not been initialized yet.");
Display.rootElementNotFoundError = new Error("Root element could not be found.");
Display.listEmptyError = new Error("Display list is empty.");

// >>> DELETE THIS <<<
Display.todoError = new Error("TODO: Display Class/Module");

export { Display };