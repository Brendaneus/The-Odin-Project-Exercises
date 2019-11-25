// Book class
class Book {
	constructor(title = "Unlisted", author = "Unknown", pages = "Undefined", status) {
		this.title = title;
		this.author = author;
		this.pages = pages;
		this.status = status;
		Book.library.push(this);
	}
}
Book.library = []; // Static variable, as clean as it gets

let localStorage = window.localStorage; // Saved library data

// THIS SHOULD BE THE ONLY GLOBAL SCOPE CODE 
// Reload saved library data, or create new library
if (localStorage.getItem("myLibrary")) {
	loadData();
} else {
	clearData();

	let myBook = new Book("Ender's Game", "Orson Scott Card", 324, "Read");
	let anotherBook = new Book("Childhoods End", "Arthur C Clarke", 214, "Read");
	let theBook = new Book("The Pickaxe", "Dave Thomas, Andy Hunt, Chad Fowler", 829, "TODO");
	let theGoodBook = new Book("The C Programming Language", "Brian W Kernighan, Dennis M Ritchie", 272, "Shelved");
	let aNewBook = new Book("Practical Electronics for Inventors", "Paul Scherz, Simon Monk", 1056, "Standing By");
	let everybodyWantsBooks = new Book("Nintendo Power", "Reggie Miyamoto", 20, "Unread");
}

// MOVE: DISPLAY
// Render library and new Book form to html window
function render() {
	let libraryTable = document.createElement("table");
	libraryTable.setAttribute("id", "libraryTable");

	// Create Header for columns
	let tableHeader = document.createElement("tr");
	
	// Title
	let titleHeader = document.createElement("th");
	titleHeader.innerHTML = "Title";
	tableHeader.appendChild(titleHeader);
	
	// Author
	let authorHeader = document.createElement("th");
	authorHeader.innerHTML = "Author";
	tableHeader.appendChild(authorHeader);
	
	// Pages
	let pagesHeader = document.createElement("th");
	pagesHeader.innerHTML = "Pages";
	tableHeader.appendChild(pagesHeader);
	
	// Status
	let statusHeader = document.createElement("th");
	statusHeader.innerHTML = "Status";
	tableHeader.appendChild(statusHeader);

	// Add Header to Library Table
	libraryTable.appendChild(tableHeader);

	// Add Book Listing to Library Table for each Book
	for(let i = 0; i < Book.library.length; i++) {
		let bookListing = document.createElement("tr");

		// Add a column for each property on Book Listing
		for (property in Book.library[i]) {
			let dataEntry = document.createElement("td");
			dataEntry.innerHTML = Book.library[i][property];
			bookListing.appendChild(dataEntry);
		}

		// Create a "CHANGE STATUS" button
		let statusButton = document.createElement("button");
		statusButton.innerHTML = "CHANGE STATUS";
		statusButton.addEventListener("click", toggleBookStatus);
		bookListing.appendChild(statusButton);

		// Create a "REMOVE BOOK" button
		let removeButton = document.createElement("button");
		removeButton.innerHTML = "REMOVE BOOK";
		removeButton.addEventListener("click", removeBook);
		bookListing.appendChild(removeButton);

		// Add Book Listing to Library Table
		libraryTable.appendChild(bookListing);
	}

	// Add Library Table to DOM
	document.body.appendChild(libraryTable);


	// Create a "NEW BOOK" button and add to DOM
	let newBookButton = document.createElement("button");
	newBookButton.innerHTML = "ADD BOOK";
	document.body.appendChild(newBookButton);
	newBookButton.addEventListener("click", toggleBookForm);

	// Create a "SAVE DATA" button and add to DOM
	let saveButton = document.createElement("button");
	saveButton.innerHTML = "SAVE DATA";
	document.body.appendChild(saveButton);
	saveButton.addEventListener("click", saveData);

	// Create a "CLEAR DATA" button and add to DOM
	let clearButton = document.createElement("button");
	clearButton.innerHTML = "CLEAR DATA";
	document.body.appendChild(clearButton);
	clearButton.addEventListener("click", clearData);

	// Create Form for new Book Listings
	let newBookForm = document.createElement("form");
	newBookForm.setAttribute("id", "newBookForm");
	newBookForm.style.display = "none";

	// Title
	let bookTitleInputLabel = document.createElement("label");
	bookTitleInputLabel.innerHTML = "Title:";
	bookTitleInputLabel.setAttribute("name", "title");
	let bookTitleInput = document.createElement("input");
	bookTitleInput.setAttribute("name", "title");
	newBookForm.appendChild(bookTitleInputLabel);
	newBookForm.appendChild(bookTitleInput);

	// Author
	let bookAuthorInputLabel = document.createElement("label");
	bookAuthorInputLabel.innerHTML = "Author:";
	bookAuthorInputLabel.setAttribute("name", "author");
	let bookAuthorInput = document.createElement("input");
	bookAuthorInput.setAttribute("name", "author");
	newBookForm.appendChild(bookAuthorInputLabel);
	newBookForm.appendChild(bookAuthorInput);

	// Pages
	let bookPagesInputLabel = document.createElement("label");
	bookPagesInputLabel.innerHTML = "Page Count:";
	bookPagesInputLabel.setAttribute("name", "pages");
	let bookPagesInput = document.createElement("input");
	bookPagesInput.setAttribute("name", "pages");
	newBookForm.appendChild(bookPagesInputLabel);
	newBookForm.appendChild(bookPagesInput);

	// Status
	let bookStatusInputLabel = document.createElement("label");
	bookStatusInputLabel.innerHTML = 'Status<span title="Have you read this book?">(?)</span>:';
	bookStatusInputLabel.setAttribute("name", "status");
	let bookStatusInput = document.createElement("input");
	bookStatusInput.setAttribute("name", "status");
	newBookForm.appendChild(bookStatusInputLabel);
	newBookForm.appendChild(bookStatusInput);

	// Submit Button
	let newBookSubmit = document.createElement("button");
	newBookSubmit.innerHTML = "Submit"
	newBookForm.addEventListener("submit", submitBookToTable);
	newBookForm.appendChild(newBookSubmit);

	// Add Book Form to DOM
	document.body.appendChild(newBookForm);
}

// MOVE: DISPLAY >>>>>>> CLEAN THIS MESS
// Get book index
function getIndexOf(bookListing) {
	let index = -1;
	while ( (bookListing = bookListing.previousSibling) !== null) index++;
	return index;
}

// MOVE: DISPLAY & LIBRARY
function toggleBookStatus(e) {
	let status = e.target.parentElement.children[3];
	let index = getIndexOf(e.target.parentElement);
	if (status.innerHTML !== "Read") {
		status.innerHTML = "Read";
		Book.library[index].status = "Read";
	} else {
		status.innerHTML = "Unread";
		Book.library[index].status = "Unread";
	}
}

// MOVE: DISPLAY & LIBRARY
// Remove book listing from Library array and table
function removeBook(e) {
	let element = e.target.parentElement;

	// remove array element
	let index = getIndexOf(element);
	Book.library.splice(index,1);

	//remove DOM element
	e.target.parentElement.remove();
}

// MOVE: DISPLAY & LIBRARY
// Add a book listing to library table
function submitBookToTable(e) {
	// Prevent Page Reload
	e.preventDefault();

	let bookListing = document.createElement("tr");

	// Title
	let bookTitleText = e.target.elements["title"].value;
	let bookTitle = document.createElement("td");
	bookTitle.innerHTML = bookTitleText;
	bookListing.appendChild(bookTitle);

	// Author
	let bookAuthorText = e.target.elements["author"].value;
	let bookAuthor = document.createElement("td");
	bookAuthor.innerHTML = bookAuthorText;
	bookListing.appendChild(bookAuthor);

	// Pages
	let bookPagesText = e.target.elements["pages"].value;
	let bookPages = document.createElement("td");
	bookPages.innerHTML = bookPagesText;
	bookListing.appendChild(bookPages);

	// Status
	let bookStatusText = e.target.elements["status"].value;
	let bookStatus = document.createElement("td");
	bookStatus.innerHTML = bookStatusText;
	bookListing.appendChild(bookStatus);

	// "CHANGE STATUS" button
	let statusButton = document.createElement("button");
	statusButton.innerHTML = "CHANGE STATUS";
	statusButton.addEventListener("click", toggleBookStatus);
	bookListing.appendChild(statusButton);

	// "REMOVE BOOK" button
	let removeButton = document.createElement("button");
	removeButton.innerHTML = "REMOVE BOOK";
	removeButton.addEventListener("click", removeBook);
	bookListing.appendChild(removeButton);

	// Add listing to Library array
	new Book(bookTitleText, bookAuthorText, bookPagesText, bookStatusText);

	// Add Listing to Table
	let libraryTable = document.querySelector("#libraryTable")
	libraryTable.appendChild(bookListing);

	// Clear form for new entry
	e.target.reset();
}

// MOVE: DISPLAY
// Open / Close Form for new books
function toggleBookForm(e) {
	let newBookForm = document.getElementById("newBookForm");
	if (e.target.innerHTML !== 'ADD BOOK') {
		e.target.innerHTML = 'ADD BOOK';
		newBookForm.reset();
		newBookForm.style.display = "none";
	} else {
		e.target.innerHTML = 'CANCEL';
		newBookForm.style.display = "block";
	}
}

// MOVE: STORAGE
function saveData() {
	localStorage.setItem("myLibrary", JSON.stringify(Book.library));
	console.log(localStorage.getItem("myLibrary"));
}

// MOVE: STORAGE
function loadData() {
	Book.library = JSON.parse(localStorage.getItem("myLibrary"));
}

// MOVE: STORAGE
// Remove all Books from Library and delete local save
function clearData() {
	// Book.library = [];
	localStorage.removeItem("myLibrary");
}

render();


/* TODO:
 * REFACTOR INTO DISPLAY MODULE/CLASS, STORAGE MODULE, AND LIBRARY CLASS
 *
 * Change all methods to use render to make changes (re-render) and change render to delete last render
 * Associate all Listings with their objects and refactor
 * Refactor book listing / elemetn creation into helper method(s) that take(s) text and return complete DOM element
 * Clean up this mess
 */