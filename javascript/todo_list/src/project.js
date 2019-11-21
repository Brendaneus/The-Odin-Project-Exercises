import { Todo } from './todo.js';

// Class controlling data for projects of todo lists
class Project {
	constructor(name, todoList=[]) {
		if (!Project.validName(name)) {
			throw new Error(`Name: '${name}' must be a non-empty string.`)
		} else if (!Project.uniqueName(name)) {
			throw new Error(`Name: '${name}' is already in use.`);
		} else {
			this._name = name;
		}

		if (!Project.validTodoList(todoList)) {
			throw new Error(`Todo List: '${todoList}' must be an array of valid Todo objects.`);
		} else if (!Project.uniqueTodoList(todoList)) {
			throw new Error(`Todo List: '${todoList}' must contain only unassigned unique Todo objects.`)
		} else {
			this._todoList = todoList;
		}

		Project.list.push(this);
	}

	// Check if object is an instance of Project class
	static validInstance(object) {
		return (object instanceof Project);
	}

	// Check if Project is in master list
	static listed(project) {
		return Project.list.indexOf(project) >= 0;
	}

	// Check if name is a non-empty string
	static validName(newName) {
		return (typeof newName === 'string') && (newName.length > 0);
	}

	// Check if name is already in use by another listed Project
	static uniqueName(newName) {
		for (let index in Project.list) {
			if (Project.list[index]._name == newName) {
				return false;
			}
		}
		return true;
	}

	// Check if todo list is filled with only Todo objects
	static validTodoList(newList) {
		for (let index in newList) {
			if (!Todo.validInstance(newList[index])) {
				return false;
			}
		}
		return true;
	}

	// >>>PLEASE CLEAN THIS -- (Why???)
	// Check if Todos in todo list are all unique
	static uniqueTodoList(todoList) {
		var uniqueListings = [];
		for (let index in todoList) {
			let todo = todoList[index];
			if (uniqueListings.includes(todo)) {
				return false;
			// >>>HERE - see todoList setter function
			} else if (Project.listedInProject(todo)) {
				return false;
			} else {
				uniqueListings.push(todo);
			}
		}
		return true;
	}

	// TODO: Make this check more thorough?
	// Check if Todo is listed in a Project already
	static listedInProject(todo) {
		for (let index in Project.list) {
			if (Project.list[index]._todoList.includes(todo)) {
				return true;
			}
		}
		return false;
	}

	// Get a project by name
	static get(name) {
		for (let index in Project.list) {
			if (Project.list[index].name == name) {
				return Project.list[index];
			}
		}

		throw new Error(`No Project listed with name: '${name}'.`)
	}

	// Delete Project and its listed Todo from their respective master lists -- dereferencing tool
	static delete(project) {
		if (!Project.validInstance(project)) {
			throw new Error(`Object: '${project}' is not a valid instance of Project Class.`)
		} else if (!Project.listed(project)) {
			throw new Error(`Project: '${project._name}' cannot be found in master list.`)
		} else {
			if (project.populated()) {
				project.deleteAll();
				Project.list.splice(Project.list.indexOf(project), 1);
			} else {
				Project.list.splice(Project.list.indexOf(project), 1);
			}
		}
	}

	// Add Project back to master list -- referencing tool
	static relist(project) {
		if (!Project.validInstance(project)) {
			throw new Error(`Object: '${project}' is not a valid instance of Project Class.`)
		} else if (Project.listed(project)) {
			throw new Error(`Project: '${project._name}' is already in master list.`)
		} else {
			Project.list.push(project);
		}
	}

	// UNUSED???
	// Delete all Projects and their listed Todos from their respective master lists -- dereferencing tool
	static deleteAll() {
		if (Project.list.length == 0 ) {
			throw new Error(`Project list is empty.`);
		} else {
			for (let index in Project.list) {
				if (Project.list[index].populated()) {
					Project.list[index].deleteAll();
				}
			}

			Project.list = [];
		}
	}

	get name() {
		return this._name;
	}

	set name(newName) {
		if (!Project.validName(newName)) {
			throw new Error(`Name: '${newName}' must be a non-empty string.`)
		} else if (!Project.uniqueName(newName)) {
			throw new Error(`Name: '${newName}' is already in use.`);
		} else {
			this._name = newName;
		}
	}

	get todoList() {
		return this._todoList;
	}

	set todoList(newList) {
		// Temporarily remove current list from known Project lists to check uniqueness
		var oldList = this._todoList;
		this._todoList = [];
		if (!Project.validTodoList(newList)) {
			this._todoList = oldList;
			throw new Error(`Todo List: '${newList}' must be an array of valid Todos.`);
		} else if (!Project.uniqueTodoList(newList)) {
			this._todoList = oldList;
			throw new Error(`Todo List: '${newList}' must contain only unassigned unique Todos.`)
		} else {
			this._todoList = newList;
		}
	}

	// Get Todo from todo list by title
	get(title) {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to get.`);
		} else if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in Project: '${this._name}'.`);
		} else {
			return this._todoList.find( (todo) => {return todo.title == title} );
		}
	}

	// Add Todo to todo list
	add(newTodo) {
		if (!Todo.validInstance(newTodo)) {
			throw new Error(`Object: '${newTodo.title}' is not a valid instance of Todo class.`)
		} else if (Project.listedInProject(newTodo)) {
			throw new Error(`Todo: '${newTodo.title}' is already listed in a Project.`)
		} else {
			this._todoList.push(newTodo);
		}
	}

	// Delete Todo from todo list and Todo master list -- dereferencing tool
	delete(title) {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to delete.`);
		} else if (!this.listed(title)) {
			throw new Error(`Todo: '${title}' is not listed in Project '${this._name}'.`)
		} else {
			var todo = this._todoList.find( (todo) => {return todo.title == title} );
			Todo.delete(todo);
			this._todoList.splice( this._todoList.indexOf(todo), 1 );
		}
	}

	// Delete all Todos from todo list and Todo master list -- dereferencing tool
	deleteAll() {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to delete.`);
		}

		// TODO: Change to use temp copy?
		// Delete each Todo in todo list from Todo master list
		while (this._todoList.length > 0) {
			Todo.delete(this._todoList[0].title);
		}

		this._todoList = [];
	}

	// WHY IS THERE NO CHECKALL FUNCTION???
	// Uncheck all Todos in todo list; throw error if all were previously unchecked
	uncheckAll() {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to uncheck.`);
		}

		let allPreUnchecked = true;
		for (let index in this._todoList) {
			if (this._todoList[index].checked()) {
				allPreUnchecked = false;
				this._todoList[index].uncheck();
			}
		}
		// Throw error if all Todos were previously checked
		if (allPreUnchecked) {
			throw new Error(`Project: '${this._name}' has already been unchecked.`)
		}
	}

	// Check all Todos in todo list; throw error if all were previously checked
	finish() {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to finish.`);
		}

		let allPreChecked = true;
		for (let index in this._todoList) {
			if (this._todoList[index].unchecked()) {
				allPreChecked = false;
				this._todoList[index].check();
			}
		}
		// Throw error if all Todos were previously checked
		if (allPreChecked) {
			throw new Error(`Project: '${this._name}' has already been finished.`)
		}
	}

	// Check if any Todos in todo list are not done
	finished() {
		if (this.empty()) {
			throw new Error(`Project: '${this._name}' has no listed Todos to finish.`);
		}

		for (let index in this._todoList) {
			if (this._todoList[index].unchecked()) {
				return false;
			}
		}
		return true;
	}

	// Check if any Todos in todo list are not done
	unfinished() {
		return !this.finished();
	}

	// Check if todo list is empty
	empty() {
		return this._todoList.length == 0;
	}

	// Check if todo list is populated
	populated() {
		return !this.empty();
	}

	// Check if Todo is in todo list
	listed(title) {
		return this._todoList.some( (todo) => {return todo.title == title} );
	}
}

Project.list = []; // Master list of all projects

export { Project };
