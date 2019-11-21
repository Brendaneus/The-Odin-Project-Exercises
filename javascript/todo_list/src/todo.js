// Class controlling data for todo tasks
class Todo {
	constructor(title, description="", dueDate=null, priority=1) {
		if (!Todo.validTitle(title)) {
			throw new Error(`Title: '${title}' must be a non-empty string.`)
		} else if (!Todo.titleAvailable(title)) {
			throw new Error(`Title: '${title}' is already in use.`);
		} else {
			this._title = title;
		}

		if (!Todo.validDescription(description)) {
			throw new Error(`Description: '${description}' must be a string.`);
		} else {
			this._description = description;
		}

		if (dueDate === null) {
			this._dueDate = null;
		} else if (!Todo.validDate(dueDate)) {
			throw new Error(`Date: '${dueDate}' must be a Date object or null.`);
		} else if (!Todo.dateInRange(dueDate)) {
			throw new Error(`Due Date: '${dueDate}' must fall on or past current Date: '${Date(Todo.currentDate)}.'`)
		} else {
			this._dueDate = dueDate;
		}

		if (!Todo.validPriority(priority)) {
			throw new Error(`Priority: '${priority}' must be an integer.`)
		} else if (!Todo.priorityInRange(priority)) {
			throw Todo.priorityRangeError;
		} else {
			this._priority = priority;
		}

		this._done = false;

		Todo.list.push(this);
	}

	// Check if object is an instance of Todo class
	static validInstance(obj) {
		return (obj instanceof Todo);
	}

	// Check if Todo is in master list
	static listed(todo) {
		return Todo.list.indexOf(todo) >= 0;
	}

	// Check if title is a string and not empty
	static validTitle(newTitle) {
		return (typeof newTitle === 'string') && (newTitle.length > 0);
	}

	// Check if title is already in use by another listed Todo
	static titleAvailable(newTitle) {
		for (let index in Todo.list) {
			if (Todo.list[index].title === newTitle) {
				return false;
			}
		}
		return true;
	}

	// Check if description is a string
	static validDescription(newDescription) {
		return (typeof newDescription === 'string');
	}

	// Check if object is a Date and has a valid time
	static validDate(newDate) {
		return (newDate instanceof Date) && !isNaN(newDate.getTime());
	}

	// TODO: Would like to clean this up
	// Check if date is on or after current date
	static dateInRange(newDate) {
		var currentDate = new Date(Date.now());
		
		if ( newDate.getYear() > currentDate.getYear() ) {
			return true;
		} else if ( newDate.getYear() == currentDate.getYear() ) {
			if ( newDate.getMonth() > currentDate.getMonth() ) {
				return true;
			} else if ( newDate.getMonth() == currentDate.getMonth() ) {
				if ( newDate.getDate() >= currentDate.getDate() ) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	// Check if priority is an integer number
	static validPriority(newPriority) {
		return (typeof newPriority === 'number') && isFinite(newPriority) && (Math.floor(newPriority) === newPriority);
	}

	// Check if priority is within bounds of MIN and MAX static presets
	static priorityInRange(newPriority) {
		return !(newPriority < Todo.MIN_PRIORITY || newPriority > Todo.MAX_PRIORITY);
	}

	// Delete Todo from master list -- dereferencing tool
	static delete(todo) {
		if (!Todo.validInstance(todo)) {
			throw new Error(`Object: '${todo}' is not a valid instance of Todo class.`)
		} else if (!Todo.listed(todo)) {
			throw new Error(`Todo: '${todo._title}' cannot be found in master list.`)
		} else {
			Todo.list.splice(Todo.list.indexOf(todo), 1);
		}
	}

	// Add Todo back to master list -- referencing tool
	static relist(todo) {
		if (!Todo.validInstance(todo)) {
			throw new Error(`Object: '${todo}' is not a valid instance of Todo class.`)
		} else if (Todo.listed(listed)) {
			throw new Error(`Todo: '${todo._title}' is already in master list.`)
		} else {
			Todo.list.push(todo);
		}
	}

	get title() {
		return this._title;
	}

	set title(newTitle) {
		if (!Todo.validTitle(newTitle)) {
			throw new Error(`Title: '${newTitle}' must be a non-empty string.`)
		} else if (!Todo.titleAvailable(newTitle)) {
			throw new Error(`Title: '${newTitle}' is already in use.`);
		} else {
			this._title = newTitle;
		}
	}

	get description() {
		return this._description;
	}

	set description(newDescription) {
		if (!Todo.validDescription(newDescription)) {
			throw new Error(`Description: '${newDescription}' must be a string.`);
		} else {
			this._description = newDescription;
		}
	}

	get dueDate() {
		return this._dueDate;
	}

	set dueDate(newDate) {
		if (newDate === null) {
			this._dueDate = null;
		} else if (!Todo.validDate(newDate)) {
			throw new Error(`Date: '${newDate}' must be a Date object or null.`);
		} else if (!Todo.dateInRange(newDate)) {
			throw new Error(`Due Date: '${newDate}' must fall on or past current Date: '${Date(Todo.currentDate)}.'`)
		} else {
			this._dueDate = newDate;
		}
	}

	get priority() {
		return this._priority;
	}

	set priority(newPriority) {
		if (!Todo.validPriority(newPriority)) {
			throw new Error(`Priority: '${newPriority}' must be an integer.`)
		} else if (!Todo.priorityInRange(newPriority)) {
			throw Todo.priorityRangeError;
		} else {
			this._priority = newPriority;
		}
	}

	// Mark todo as done
	check() {
		if (this._done === true) {
			throw new Error(`Todo: '${this._title}' has already been checked off.`);
		} else {
			this._done = true;
		}
	}

	// Mark todo as not done
	uncheck() {
		if (this._done === false) {
			throw new Error(`Todo: '${this._title}' has not been checked.`);
		} else {
			this._done = false;
		}
	}

	checked() {
		return this._done;
	}

	unchecked() {
		return !(this._done);
	}

	hasDate() {
		return this._dueDate != null
	}
}

Todo.list = []; // Master Collection of all todos
Todo.MAX_PRIORITY = 5; // Technically lowest priority
Todo.MIN_PRIORITY = 1; // think "Priority Number One"
Todo.priorityRangeError = new Error(`Priority must be within range ${Todo.MIN_PRIORITY} to ${Todo.MAX_PRIORITY}.`)

export { Todo };
