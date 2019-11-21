import { Todo } from './todo.js';
import { Project } from './project.js';
import { Display } from './display.js';
import { Interstruct } from './interstruct.js';


// window.addEventListener('load', Interstruct.clearData);
window.addEventListener('load', Display.initialize);
window.addEventListener('load', Interstruct.loadData);
// window.addEventListener('load', doStuff);

function doStuff() {
	Interstruct.clearData();

	let interstructProject = new Interstruct("Interstruct Class");
	interstructProject.createTodo("Sorting functions and states",
		"Allow multiple sort states at once",
		null, 1);
	
	let displayProject = new Interstruct("Display Class");
	displayProject.createTodo("'Sort By' Options",
		"Allow multiple sorts at once?\n-checked\n-priority\n-name\n-due date",
		null, 1);
	
	let projectProject = new Interstruct("Project Class");
	projectProject.createTodo("Clean Up Code",
		"Redundant methods and comments",
		null, 5);
	
	let todoProject = new Interstruct("Todo Class");
	todoProject.createTodo("Clean Up Code Too",
		"Redundant methods and comments",
		null, 5);
	
	let designProject = new Interstruct("Visual Design");
	designProject.createTodo("Rework Control Panel Layout",
		"", null, 3);
	designProject.createTodo("Visual Feedback",
		"", null, 4);
	designProject.createTodo("Beautify/Organize Elements on Page",
		"Color based on priority,\ncenter main elements,\nmake responsive",
		null, 4);

	Display.updateMessage("Todo List Created");

	window.removeEventListener('load', doStuff);
}

try {
	
} catch {
	console.log("Failed");
}


// Class-based implementation, private variables emulated with prefixed underscores
// >>>Change getters and setters to use copies and enforce set usage?
// >>>Add move-to function for drag/drop capabilities?

// sort project lists by priority by default, then dueDate
//  - sortable by title
//  - sortable by dueDate
//  - sectionable by dates

// TODO: Add Error handling for unexpected DOM changes
// 	- include change reversal functionality in Interstruct's destructive methods

// currently, localStorage accesses 'private' variables when rebuilding Todo lists

// should more Display static variables be removed in favor of doc queries

// maybe change Project master list to use object instead of array

// IMPORTANT: Multiple message capabilities, reset options

// WARNING: Todo listings on Display use id attribute to store name; VERY DANGEROUS

// TODO: Add animations for sort triggered reorganization

// IDEA: Undo button with temp storage