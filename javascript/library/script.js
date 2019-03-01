let myLibrary = [];
let localStorage = window.localStorage;

// Starting library data
if (localStorage.getItem("myLibrary")) {
	loadData();
} else {
	clearData();

	let myBook = new Book("The Holy Bibble", "St. Jesus", 1234, "Unpalettable");
	let anotherBook = new Book("Childhoods End", "Arthur C Clarke", 214, "Read");
	let theBook = new Book("The Pickaxe", "Dave Thomas, Andy Hunt, Chad Fowler", 829, "Uh...");
	let theGoodBook = new Book("The C Programming Language", "Brian W Kernighan, Dennis M Ritchie", 272, "Shelved");
	let everybodyWantsBooks = new Book("Nintendo Power", "Reggie Miyamoto", 20, "Unread");

	myLibrary.push(myBook, anotherBook, theBook, theGoodBook, everybodyWantsBooks);
}


// Book constructor
function Book(title = "Unlisted", author = "Unknown", pages = "Undefined", status) {
	this.title = title;
	this.author = author;
	this.pages = pages;
	this.status = status;
}

function addBookToLibrary(book) {
	myLibrary.push(book);
}

// Add myLibrary and form to html window
function render() {
	let libraryTable = document.createElement("table");
	libraryTable.setAttribute("id", "libraryTable");

	// Create headers for columns
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

	libraryTable.appendChild(tableHeader);

	// Iterate through books in library
	for(let i = 0; i < myLibrary.length; i++) {
		let bookListing = document.createElement("tr");

		for (property in myLibrary[i]) {
			let dataEntry = document.createElement("td");
			dataEntry.innerHTML = myLibrary[i][property];
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

		libraryTable.appendChild(bookListing);
	}

	document.body.appendChild(libraryTable);


	// Create a "NEW BOOK" button
	let newBookButton = document.createElement("button");
	newBookButton.innerHTML = "ADD BOOK";
	document.body.appendChild(newBookButton);
	newBookButton.addEventListener("click", toggleBookForm);


	// Create a "SAVE DATA" button
	let saveButton = document.createElement("button");
	saveButton.innerHTML = "SAVE DATA";
	document.body.appendChild(saveButton);
	saveButton.addEventListener("click", saveData);


	// Create a "CLEAR DATA" button
	let clearButton = document.createElement("button");
	clearButton.innerHTML = "CLEAR DATA";
	document.body.appendChild(clearButton);
	clearButton.addEventListener("click", clearData);


	// Create form for new book
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

	document.body.appendChild(newBookForm);
}

// Get book index
function getIndexOf(bookListing) {
	let index = -1;
	while ( (bookListing = bookListing.previousSibling) !== null) index++;
	return index;
}

function toggleBookStatus(e) {
	let status = e.target.parentElement.children[3];
	let index = getIndexOf(e.target.parentElement);
	if (status.innerHTML !== "Read") {
		status.innerHTML = "Read";
		myLibrary[index].status = "Read";
	} else {
		status.innerHTML = "Unread";
		myLibrary[index].status = "Unread";
	}
}

// Remove book listing from Library array and table
function removeBook(e) {
	let element = e.target.parentElement;

	// remove array element
	let index = getIndexOf(element);
	myLibrary.splice(index,1);

	//remove DOM element
	e.target.parentElement.remove();
}

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
	let book = new Book(bookTitleText, bookAuthorText, bookPagesText, bookStatusText);
	myLibrary.push(book);

	// Add Listing to Table
	let libraryTable = document.querySelector("#libraryTable")
	libraryTable.appendChild(bookListing);


	// Clear form for new entry
	e.target.reset();
}

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

function saveData() {
	localStorage.setItem("myLibrary", JSON.stringify(myLibrary));
	console.log(localStorage.getItem("myLibrary"));
}

function loadData() {
	myLibrary = JSON.parse(localStorage.getItem("myLibrary"));
}

function clearData() {
	localStorage.removeItem("myLibrary");
}

render();


/* TODO:
 * Change all methods to use render to make changes (re-render) and change render to delete last render
 * Associate all Listings with their objects and refactor
 * Refactor book listing / elemetn creation into helper method(s) that take(s) text and return complete DOM element
 * Clean up this mess
 */