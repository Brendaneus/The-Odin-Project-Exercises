import { Todo } from './todo.js';
import { Project } from './project.js';
import { Display } from './display.js';

// Acts as intermediary between core objects and browser display
class Interstruct {
	constructor(givenName) {
		// If not provided, get first available unique name for a new Project
		if (!givenName) {	
			var projectName = "New Project ";
			var num = 1;
			while ( !Project.uniqueName(projectName + num) ) {
				num++;
			}
			projectName += num;
		} else {
			var projectName = givenName;
		}

		// Attempt to create new Project...
		try {
			this.project = new Project(projectName);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// ...and add it to the Display
		try {
			this.display = new Display(this);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			Project.delete(this.project);
			return -1;
		}

		// Create blank list of Todo list sort states
		this.sortStates = {};

		// Add this struct to master list
		Interstruct.list[projectName] = this;

		Interstruct.saveData();

		Display.updateMessage(`Project: '${projectName}' Created`);
	}

	// UNUSED???
	// Verify a project is a valid, listed instance of Project class, else throw error
	static verifyProject(object) {
		if (!Project.validInstance(object)) {
			throw new Error(`Object: '${object}' is not a valid instance of the Project class.`);
		} else if (!Project.listed(object)) {
			throw new Error(`Project: '${object}' is delisted and awaiting dereferencing.`)
		} else {
			return true;
		}
	}

	// Delete an Interstruct's Project, Display, and Interstruct object
	static delete(projectName) {
		// Attempt to get struct by name
		var struct = Interstruct.list[projectName];
		if (struct == undefined) {
			Display.updateMessage(`No Struct listed with name: '${projectName}'`, 'error');
			return -1;
		}

		// Attempt to delete Project from master list...
		try {
			Project.delete(struct.project);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// ...and delete from Display
		try {
			Display.delete(struct.display);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			Project.relist(struct.project);
			return -1;
		}

		delete Interstruct.list[projectName];

		Interstruct.saveData();

		Display.updateMessage(`Project: '${projectName}' Deleted`);
	}

	// Delete each Interstruct in master list
	static deleteAll() {
		for (let ref in Interstruct.list) {
			if (Interstruct.delete(ref) == -1) {
				return -1;
			}
		}

		Display.updateMessage("All Projects Deleted");
	}

	// IMPORTANT: All finished checks rely on Display checks instead of Project checks
	// Apply sort state options to Display
	static applySort() {
		// Get list of references to structs
		var sortedRefs = Object.keys(Interstruct.list);
		
		// Sort list and update Display to show finished sort state
		if (Interstruct.sortStates.finished == 'ascending') {
			sortedRefs.sort( (a, b) => {
				let first = Interstruct.list[a];
				let second = Interstruct.list[b];

				if (first.display.finished() && second.display.unfinished()) {
					return -1;
				} else if (first.display.unfinished() && second.display.finished()) {
					return 1;
				} else {
					if (Interstruct.sortStates.name == 'ascending') {
						return (a > b) ? 1 : (a < b) ? -1 : 0;
					} else if (Interstruct.sortStates.name == 'descending') {
						return (a < b) ? 1 : (a > b) ? -1 : 0;
					} else {
						return 0;
					}
				}
			} );
		} else if (Interstruct.sortStates.finished == 'descending') {
			sortedRefs.sort( (a, b) => {
				let first = Interstruct.list[a];
				let second = Interstruct.list[b];

				if (first.display.finished() && second.display.unfinished()) {
					return 1;
				} else if (first.display.unfinished() && second.display.finished()) {
					return -1;
				} else {
					if (Interstruct.sortStates.name == 'ascending') {
						return (a > b) ? 1 : (a < b) ? -1 : 0;
					} else if (Interstruct.sortStates.name == 'descending') {
						return (a < b) ? 1 : (a > b) ? -1 : 0;
					} else {
						return 0;
					}
				}
			} );
		} else {
			if (Interstruct.sortStates.name == 'ascending') {
				sortedRefs.sort();
			}
			if (Interstruct.sortStates.name == 'descending' ) {
				sortedRefs.sort( (a, b) => { return (a < b) ? 1 : (a > b) ? -1 : 0 } );
			}
		}

		// Update Display to show sort states
		Display.setFinishedSort(this.sortStates.finished);
		Display.setNameSort(this.sortStates.name);

		// Clear all Displays from DOM
		for (let ref in Interstruct.list) {
			Display.remove(Interstruct.list[ref].display);
		}

		// Rebuild DOM using sorted order of Structs
		for (let index in sortedRefs) {
			Display.replace(Interstruct.list[sortedRefs[index]].display);
		}
	}

	// Set Projects to sort by finished state
	static sortFinished() {
		// Mark sort state for finished and update Display
		if (Interstruct.sortStates.finished == 'ascending') {
			Interstruct.sortStates.finished = 'descending';
		} else if (Interstruct.sortStates.finished == 'descending') {
			Interstruct.sortStates.finished = 'none';
		} else {
			Interstruct.sortStates.finished = 'ascending';
		}

		Interstruct.applySort();

		Interstruct.saveData();
	}

	// Set Projects to sort by name
	static sortName() {
		// Mark sort state for names and update Display
		if (Interstruct.sortStates.name == 'ascending') {
			Interstruct.sortStates.name = 'descending';
		} else if (Interstruct.sortStates.name == 'descending') {
			Interstruct.sortStates.name = 'none';
		} else {
			Interstruct.sortStates.name = 'ascending';
		}

		Interstruct.applySort();
	
		Interstruct.saveData();
	}

	// Update Project name, and update Display
	changeName(newName) {
		var oldName = this.project.name;

		// Attempt to rename Project...
		try {
			this.project.name = newName;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.display.name = oldName;
			return -1;
		}

		// ...and update Display...
		try {
			this.display.name = newName;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.project.name = oldName;
			this.display.name = oldName;
			return -1;
		}

		// ...and reassign master Struct listing
		if (newName in Interstruct.list) {
			Display.updateMessage(`Name: '${newName}' already exists in the master Struct list.`)
			this.project.name = oldName;
			this.display.name = oldName;
		} else {
			Interstruct.list[newName] = this;
			if (newName != oldName) {
				delete Interstruct.list[oldName];
			}
		}

		Interstruct.saveData();

		Display.updateMessage(`Project: '${oldName}' renamed to '${newName}'`)
	}

	// TODO: Error handling?
	// Update Display Project checkbox to reflect finished state
	updateStatus() {
		if (this.project.empty()) {
			return; // Short circuit and keep Display as Checked Off
		} else {
			if (this.project.finished() && this.display.unfinished()) {
				this.display.finish();
				Display.updateMessage(`Project: '${this.project.name}' finished!`, 'congrat')
			}
			if (this.project.unfinished() && this.display.finished()) {
				this.display.unfinish();
			}
		}
	}

	// Create a new Todo, add to Project todo list, and list on Display
	createTodo(givenTitle, description='', dueDate=null, priority=1) {
		// Create a default name for todo if one is not given
		if (!givenTitle) {
			var newTitle = this.project.name + " Task ";
			var num = 1;
			while ( !Todo.titleAvailable(newTitle + num) ) {
				num++;
			}
			newTitle += num;
		} else {
			var newTitle = givenTitle; 
		}

		// Attempt to create new Todo...
		try {
			var newTodo = new Todo(newTitle, description, dueDate, priority); // Separate this?
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// ...add it to Project...
		try {
			this.project.add(newTodo);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			Todo.delete(newTodo);
			return -1;
		}

		// ...and Display
		try {
			this.display.list(newTodo);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			Todo.delete(newTodo);
			this.project.delete(newTodo.title)
			return -1;
		}

		this.updateStatus();

		this.applySort();

		Interstruct.saveData();

		Display.updateMessage(`Todo: '${newTodo.title}' added to Project: '${this.project.name}'`)
	}

	// Change a Todo's title, and update Display
	changeTitle(title, newTitle) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// Attempt to change Todo's title...
		try {
			todo.title = newTitle;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.display.changeTitle(title, title);
			return -1;
		}

		// ...and update Display
		try {
			this.display.changeTitle(title, newTitle);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			todo.title = title;
			this.display.changeTitle(title, title);
			return -1;
		}

		this.applySort();

		Interstruct.saveData();

		Display.updateMessage(`Todo: '${title}' retitled to '${newTitle}'`);
	}

	// Change a Todo's description, and update Display
	changeDescription(title, newDescription) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		var oldDescription = todo.description;

		// Attempt to change Todo's description...
		try {
			todo.description = newDescription;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.display.changeDescription(oldDescription);
			return -1;
		}

		// ...and update Display
		try {
			this.display.changeDescription(title, newDescription);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			todo.description = oldDescription;
			this.display.changeDescription(oldDescription);
			return -1;
		}

		this.applySort();

		Interstruct.saveData();
	}

	// Change a Todo's due date, and update Display
	changeDueDate(title, newDate) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		var oldDate = todo.dueDate;

		// Attempt to change Todo's due date...
		try {
			todo.dueDate = newDate;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.display.changeDueDate(title, oldDate);
			return -1;
		}

		// ...and update Display
		try {
			this.display.changeDueDate(title, newDate);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			todo.dueDate = newDate;
			this.display.changeDueDate(oldDate);
			return -1;
		}

		this.applySort();

		Interstruct.saveData();
	}

	// Change a Todo's priority, and update Display
	changePriority(title, newPriority) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		var oldPriority = todo.priority;

		// Attempt to change Todo's priority...
		try {
			todo.priority = newPriority;
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			this.display.changePriority(title, todo.priority);
			return -1;
		}

		// Attempt to change Todo and Display, else reset
		try {
			todo.priority = newPriority;
			this.display.changePriority(title, newPriority);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			todo.priority = oldPriority;
			this.display.changePriority(title, todo.priority);
			return -1;
		}

		this.applySort();

		Interstruct.saveData();
	}

	// Check a Todo, and update Display if necessary
	check(title) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// Attempt to mark Todo as done...
		try {
			todo.check();
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// ...and update Display (if necessary)
		try {
			if (this.display.unchecked(title)) {
				this.display.check(title);
			}
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		this.updateStatus();

		this.applySort();

		Interstruct.saveData();
	}

	// Uncheck a Todo, and update Display if necessary
	uncheck(title) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// Mark a todo as not done...
		try {
			todo.uncheck();
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// ...and update Display (if necessary)
		try {
			if (this.display.checked(title)) {
				this.display.uncheck(title);
			}
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		this.updateStatus();

		this.applySort();

		Interstruct.saveData();
	}

	// TODO: Error handling?
	// Toggle a Todo as checked/unchecked
	toggle(title) {
		if (this.project.get(title).unchecked()) {
			this.check(title);
		} else {
			this.uncheck(title);
		}

		this.applySort();
		
		Interstruct.saveData();
	}

	// TODO: Error handling?
	// Toggle all Todos to finish/unfinish Project, and update Displays where necessary
	toggleAll() {
		if (this.project.populated()) {
			var finished = this.project.finished();

			for (let index in this.project.todoList) {
				let todo = this.project.todoList[index];

				if (finished) {
					if (todo.checked()) {
						this.uncheck(todo.title);
					}
				} else {
					if (todo.unchecked()) {
						this.check(todo.title);
					}
				}
			}
		}

		// Could the below two be implemented cleaner? -- (???)
		Interstruct.saveData();

		// Display message if project is marked as finished
		if (this.display.finished()) {
			Display.updateMessage(`Project: '${this.project.name}' finished!`, 'congrat')
		}
	}

	// Delete a Todo from Project, master list, and Display
	delete(title) {
		// Attempt to get Todo from Project list by title
		try {
			var todo = this.project.get(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}

		// Attempt to delete Todo from Project todo list and master list...
		try {
			this.project.delete(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			return -1;
		}
		
		// ...and delete from Display
		try {
			this.display.delete(title);
		} catch(err) {
			Display.updateMessage(err.message, 'error');
			Todo.relist(todo);
			return -1;
		}

		this.updateStatus();

		this.applySort();

		Interstruct.saveData();

		Display.updateMessage(`Todo: '${title}' deleted from Project: '${this.project.name}'`)
	}

	// Delete all Todos from Project, master list, and Display
	deleteAll() {
		var copyList = Array.from(this.project.todoList);
		for (let index in copyList) {
			let todo = copyList[index];

			this.delete(todo.title);
		}

		Display.updateMessage(`Project: '${this.project.name}' todo list cleared`);
	}

	// Sort Project's Todo list too [?]	
	// TODO: Apply Project sort state options to Display
	// ...or keep for original sort order.  (Any way to get current sorted order?)
	applySort() {
		// Get copy of Todo list
		var todoList = Array.from(this.project.todoList);

		// Sort list
		todoList.sort( (first, second) => {
			return sortByDueDate(first, second, this.sortStates);
		});

		// Update Project Display to show sort states
		this.display.setCheckedSort(this.sortStates.checked);
		this.display.setPrioritySort(this.sortStates.priority);
		this.display.setTitleSort(this.sortStates.title);
		this.display.setDueDateSort(this.sortStates.dueDate);

		// Remove all Todos from Project's Display
		for (let index in todoList) {
			let listing = this.display.get(todoList[index].title);
			this.display.remove(listing);
		}

		// Replace all Todos in sorted order on Project's Display
		for (let index in todoList) {
			let listing = this.display.get(todoList[index].title);
			this.display.replace(listing);
		}
	}

	// TODO: Set Todo list to sort by checked state
	sortChecked() {
		if (this.sortStates.checked == 'ascending') {
			this.sortStates.checked = 'descending';
		} else if (this.sortStates.checked == 'descending') {
			this.sortStates.checked = 'none';
		} else {
			this.sortStates.checked = 'ascending';
		}

		this.applySort();

		Interstruct.saveData();
	}

	// TODO: Set Todo list to sort by priority
	sortPriority() {
		if (this.sortStates.priority == 'ascending') {
			this.sortStates.priority = 'descending';
		} else if (this.sortStates.priority == 'descending') {
			this.sortStates.priority = 'none';
		} else {
			this.sortStates.priority = 'ascending';
		}

		this.applySort();

		Interstruct.saveData();
	}

	// TODO: Set Todo list to sort by title
	sortTitle() {
		if (this.sortStates.title == 'ascending') {
			this.sortStates.title = 'descending';
		} else if (this.sortStates.title == 'descending') {
			this.sortStates.title = 'none';
		} else {
			this.sortStates.title = 'ascending';
		}

		this.applySort();

		Interstruct.saveData();
	}

	// TODO: Set Todo list to sort by due date
	sortDueDate() {
		if (this.sortStates.dueDate == 'ascending') {
			this.sortStates.dueDate = 'descending';
		} else if (this.sortStates.dueDate == 'descending') {
			this.sortStates.dueDate = 'none';
		} else {
			this.sortStates.dueDate = 'ascending';
		}

		this.applySort();

		Interstruct.saveData();
	}

	// TODO: Save Todo list sorting states
	// Save data to localStorage
	static saveData() {
		// Create formatted list of Projects and their Todo lists
		var formattedList = {};
		for (let projectName in Interstruct.list) {
			formattedList[projectName] = {};
			formattedList[projectName].finished = Interstruct.list[projectName].display.finished();
			formattedList[projectName].todoList = [];

			let project = Interstruct.list[projectName].project;

			for (let index in project.todoList) {
				formattedList[projectName].todoList.push(project.todoList[index]);
			}
		}

		// Save project list to localStorage
		window.localStorage.setItem('project_list', JSON.stringify(formattedList));

		// Save sorting states to localStorage
		window.localStorage.setItem('sort_states', JSON.stringify(Interstruct.sortStates));
	}

	// TODO: Load Todo list sorting states
	// Load data from localStorage
	static loadData() {
		// Load sorting states from localStorage and apply
		Interstruct.sortStates = JSON.parse(window.localStorage.getItem('sort_states'));

		// Load project list from localStorage
		var formattedList = JSON.parse(window.localStorage.getItem('project_list'));

		// Re-create formatted list
		for (let projectName in formattedList) {
			let struct = new Interstruct(projectName);

			if (formattedList[projectName].finished) {
				struct.display.finish();
			}

			let todoList = formattedList[projectName].todoList;

			for (let index in todoList) {
				let todoData = todoList[index];
				let dueDate = (todoData._dueDate == null) ? null : new Date(todoData._dueDate);
				struct.createTodo(todoData._title, todoData._description, dueDate, todoData._priority);
				if (todoData._done) {
					struct.check(todoData._title);
				}
			}
		}

		Interstruct.applySort();

		if (Object.keys(Interstruct.list).length > 0) {
			Display.updateMessage("Welcome back!");
		} else {
			Display.updateMessage("Welcome!");
		}
	}

	// TODO: Clear Todo list sorting states
	// Clear data from localStorage
	static clearData() {
		window.localStorage.clear();
		Interstruct.list = {};
	}

	// Log all master object lists to console
	static logAllLists() {
		console.log(Interstruct.list);
		console.log(Display.list);
		console.log(Project.list);
		console.log(Todo.list);
	}
}

function sortByTitle(first, second, sortStates) {
	if (sortStates.title == 'ascending') {
		return (first.title < second.title) ? -1 : (first.title > second.title) ? 1 : 0;
	} else if (sortStates.title == 'descending') {
		return (first.title > second.title) ? -1 : (first.title < second.title) ? 1 : 0;
	} else {
		return 0;
	}
}

function sortByChecked(first, second, sortStates) {
	if (sortStates.checked == 'ascending') {
		return (first.checked() && second.unchecked()) ? -1 : (first.unchecked() && second.checked()) ? 1 : sortByTitle(first, second, sortStates);
	} else if (sortStates.checked == 'descending') {
		return (first.unchecked() && second.checked()) ? -1 : (first.checked() && second.unchecked()) ? 1 : sortByTitle(first, second, sortStates);
	} else {
		return sortByTitle(first, second, sortStates);
	}
}

function sortByPriority(first, second, sortStates) {
	if (sortStates.priority == 'ascending') {
		return (first.priority < second.priority) ? -1 : (first.priority > second.priority) ? 1 : sortByChecked(first, second, sortStates);
	} else if (sortStates.priority == 'descending') {
		return (first.priority > second.priority) ? -1 : (first.priority < second.priority) ? 1 : sortByChecked(first, second, sortStates);
	} else {
		return sortByChecked(first, second, sortStates);
	}
}

function sortByDueDate(first, second, sortStates) {
	if (sortStates.dueDate == 'ascending') {
		if (first.hasDate() && !second.hasDate()) {
			return -1;
		} else if (!first.hasDate() && second.hasDate()) {
			return 1;
		} else if (!first.hasDate() && !second.hasDate()) {
			sortByPriority(first, second, sortStates);
		} else if (first.dueDate.getTime() < second.dueDate.getTime()) {
			return -1;
		} else if (first.dueDate.getTime() > second.dueDate.getTime()) {
			return 1;
		} else {
			sortByPriority(first, second, sortStates);
		}
	} else if (sortStates.dueDate == 'descending') {
		if (!first.hasDate() && second.hasDate()) {
			return -1;
		} else if (first.hasDate() && !second.hasDate()) {
			return 1;
		} else if (!first.hasDate() && !second.hasDate()) {
			sortByPriority(first, second, sortStates);
		} else if (first.dueDate.getTime() > second.dueDate.getTime()) {
			return -1;
		} else if (first.dueDate.getTime() < second.dueDate.getTime()) {
			return 1;
		} else {
			sortByPriority(first, second, sortStates);
		}
	} else {
		return sortByPriority(first, second, sortStates);
	}
}

Interstruct.list = {};
Interstruct.sortStates = {};

// >>> DELETE THIS <<<
Interstruct.todoError = new Error("TODO: Interstruct Module");

export { Interstruct };

// TODO: 'Node not found' error handling
