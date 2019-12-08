// Book class
class Book {
  constructor (title = 'Unlisted', author = 'Unknown', pages = 'Undefined', status) {
    this.title = title
    this.author = author
    this.pages = pages
    this.status = status
    Book.library.push(this)
  }
}
Book.library = [] // Static variable, as clean as it gets

const localStorage = window.localStorage // Saved library data

// THIS SHOULD BE THE ONLY GLOBAL SCOPE CODE
// Reload saved library data, or create new library
if (localStorage.getItem('myLibrary')) {
  loadData()
} else {
  clearData()

  /* eslint-disable no-new */
  new Book("Ender's Game", 'Orson Scott Card', 324, 'Read')
  new Book('Childhoods End', 'Arthur C Clarke', 214, 'Read')
  new Book('The Pickaxe', 'Dave Thomas, Andy Hunt, Chad Fowler', 829, 'TODO')
  new Book('The C Programming Language', 'Brian W Kernighan, Dennis M Ritchie', 272, 'Shelved')
  new Book('Practical Electronics for Inventors', 'Paul Scherz, Simon Monk', 1056, 'Standing By')
  new Book('Nintendo Power', 'Reggie Miyamoto', 20, 'Unread')
}

// MOVE: DISPLAY
// Render library and new Book form to html window
function render () {
  const libraryTable = document.createElement('table')
  libraryTable.setAttribute('id', 'libraryTable')

  // Create Header for columns
  const tableHeader = document.createElement('tr')

  // Title
  const titleHeader = document.createElement('th')
  titleHeader.innerHTML = 'Title'
  tableHeader.appendChild(titleHeader)

  // Author
  const authorHeader = document.createElement('th')
  authorHeader.innerHTML = 'Author'
  tableHeader.appendChild(authorHeader)

  // Pages
  const pagesHeader = document.createElement('th')
  pagesHeader.innerHTML = 'Pages'
  tableHeader.appendChild(pagesHeader)

  // Status
  const statusHeader = document.createElement('th')
  statusHeader.innerHTML = 'Status'
  tableHeader.appendChild(statusHeader)

  // Add Header to Library Table
  libraryTable.appendChild(tableHeader)

  // Add Book Listing to Library Table for each Book
  for (let i = 0; i < Book.library.length; i++) {
    const bookListing = document.createElement('tr')

    // Add a column for each property on Book Listing
    for (const property in Book.library[i]) {
      const dataEntry = document.createElement('td')
      dataEntry.innerHTML = Book.library[i][property]
      bookListing.appendChild(dataEntry)
    }

    // Create a "CHANGE STATUS" button
    const statusButton = document.createElement('button')
    statusButton.innerHTML = 'CHANGE STATUS'
    statusButton.addEventListener('click', toggleBookStatus)
    bookListing.appendChild(statusButton)

    // Create a "REMOVE BOOK" button
    const removeButton = document.createElement('button')
    removeButton.innerHTML = 'REMOVE BOOK'
    removeButton.addEventListener('click', removeBook)
    bookListing.appendChild(removeButton)

    // Add Book Listing to Library Table
    libraryTable.appendChild(bookListing)
  }

  // Add Library Table to DOM
  document.body.appendChild(libraryTable)

  // Create a "NEW BOOK" button and add to DOM
  const newBookButton = document.createElement('button')
  newBookButton.innerHTML = 'ADD BOOK'
  document.body.appendChild(newBookButton)
  newBookButton.addEventListener('click', toggleBookForm)

  // Create a "SAVE DATA" button and add to DOM
  const saveButton = document.createElement('button')
  saveButton.innerHTML = 'SAVE DATA'
  document.body.appendChild(saveButton)
  saveButton.addEventListener('click', saveData)

  // Create a "CLEAR DATA" button and add to DOM
  const clearButton = document.createElement('button')
  clearButton.innerHTML = 'CLEAR DATA'
  document.body.appendChild(clearButton)
  clearButton.addEventListener('click', clearData)

  // Create Form for new Book Listings
  const newBookForm = document.createElement('form')
  newBookForm.setAttribute('id', 'newBookForm')
  newBookForm.style.display = 'none'

  // Title
  const bookTitleInputLabel = document.createElement('label')
  bookTitleInputLabel.innerHTML = 'Title:'
  bookTitleInputLabel.setAttribute('name', 'title')
  const bookTitleInput = document.createElement('input')
  bookTitleInput.setAttribute('name', 'title')
  bookTitleInput.required = true
  newBookForm.appendChild(bookTitleInputLabel)
  newBookForm.appendChild(bookTitleInput)

  // Author
  const bookAuthorInputLabel = document.createElement('label')
  bookAuthorInputLabel.innerHTML = 'Author:'
  bookAuthorInputLabel.setAttribute('name', 'author')
  const bookAuthorInput = document.createElement('input')
  bookAuthorInput.setAttribute('name', 'author')
  bookAuthorInput.required = true
  newBookForm.appendChild(bookAuthorInputLabel)
  newBookForm.appendChild(bookAuthorInput)

  // Pages
  const bookPagesInputLabel = document.createElement('label')
  bookPagesInputLabel.innerHTML = 'Page Count:'
  bookPagesInputLabel.setAttribute('name', 'pages')
  const bookPagesInput = document.createElement('input')
  bookPagesInput.setAttribute('name', 'pages')
  bookPagesInput.required = true
  newBookForm.appendChild(bookPagesInputLabel)
  newBookForm.appendChild(bookPagesInput)

  // Status
  const bookStatusInputLabel = document.createElement('label')
  bookStatusInputLabel.innerHTML = 'Status<span title="Have you read this book?">(?)</span>:'
  bookStatusInputLabel.setAttribute('name', 'status')
  const bookStatusInput = document.createElement('input')
  bookStatusInput.setAttribute('name', 'status')
  bookStatusInput.required = true
  newBookForm.appendChild(bookStatusInputLabel)
  newBookForm.appendChild(bookStatusInput)

  // Submit Button
  const newBookSubmit = document.createElement('button')
  newBookSubmit.innerHTML = 'Submit'
  newBookForm.addEventListener('submit', submitBookToTable)
  newBookForm.appendChild(newBookSubmit)

  // Add Book Form to DOM
  document.body.appendChild(newBookForm)
}

// MOVE: DISPLAY >>>>>>> CLEAN THIS MESS
// Get book index
function getIndexOf (bookListing) {
  let index = -1
  while ((bookListing = bookListing.previousSibling) !== null) index++
  return index
}

// MOVE: DISPLAY & LIBRARY
function toggleBookStatus (e) {
  const status = e.target.parentElement.children[3]
  const index = getIndexOf(e.target.parentElement)
  if (status.innerHTML !== 'Read') {
    status.innerHTML = 'Read'
    Book.library[index].status = 'Read'
  } else {
    status.innerHTML = 'Unread'
    Book.library[index].status = 'Unread'
  }
}

// MOVE: DISPLAY & LIBRARY
// Remove book listing from Library array and table
function removeBook (e) {
  const element = e.target.parentElement

  // remove array element
  const index = getIndexOf(element)
  Book.library.splice(index, 1)

  // remove DOM element
  e.target.parentElement.remove()
}

// MOVE: DISPLAY & LIBRARY
// Add a book listing to library table
function submitBookToTable (e) {
  // Prevent Page Reload
  e.preventDefault()

  const bookListing = document.createElement('tr')

  // Title
  const bookTitleText = e.target.elements.title.value
  const bookTitle = document.createElement('td')
  bookTitle.innerHTML = bookTitleText
  bookListing.appendChild(bookTitle)

  // Author
  const bookAuthorText = e.target.elements.author.value
  const bookAuthor = document.createElement('td')
  bookAuthor.innerHTML = bookAuthorText
  bookListing.appendChild(bookAuthor)

  // Pages
  const bookPagesText = e.target.elements.pages.value
  const bookPages = document.createElement('td')
  bookPages.innerHTML = bookPagesText
  bookListing.appendChild(bookPages)

  // Status
  const bookStatusText = e.target.elements.status.value
  const bookStatus = document.createElement('td')
  bookStatus.innerHTML = bookStatusText
  bookListing.appendChild(bookStatus)

  // "CHANGE STATUS" button
  const statusButton = document.createElement('button')
  statusButton.innerHTML = 'CHANGE STATUS'
  statusButton.addEventListener('click', toggleBookStatus)
  bookListing.appendChild(statusButton)

  // "REMOVE BOOK" button
  const removeButton = document.createElement('button')
  removeButton.innerHTML = 'REMOVE BOOK'
  removeButton.addEventListener('click', removeBook)
  bookListing.appendChild(removeButton)

  // Add listing to Library array
  new Book(bookTitleText, bookAuthorText, bookPagesText, bookStatusText)

  // Add Listing to Table
  const libraryTable = document.querySelector('#libraryTable')
  libraryTable.appendChild(bookListing)

  // Clear form for new entry
  e.target.reset()
}

// MOVE: DISPLAY
// Open / Close Form for new books
function toggleBookForm (e) {
  const newBookForm = document.getElementById('newBookForm')
  if (e.target.innerHTML !== 'ADD BOOK') {
    e.target.innerHTML = 'ADD BOOK'
    newBookForm.reset()
    newBookForm.style.display = 'none'
  } else {
    e.target.innerHTML = 'CANCEL'
    newBookForm.style.display = 'block'
  }
}

// MOVE: STORAGE
function saveData () {
  localStorage.setItem('myLibrary', JSON.stringify(Book.library))
  console.log(localStorage.getItem('myLibrary'))
}

// MOVE: STORAGE
function loadData () {
  Book.library = JSON.parse(localStorage.getItem('myLibrary'))
}

// MOVE: STORAGE
// Remove all Books from Library and delete local save
function clearData () {
  // Book.library = [];
  localStorage.removeItem('myLibrary')
}

render()

/* TODO:
 * REFACTOR INTO DISPLAY MODULE/CLASS, STORAGE MODULE, AND LIBRARY CLASS
 *
 * Change all methods to use render to make changes (re-render) and change render to delete last render
 * Associate all Listings with their objects and refactor
 * Refactor book listing / element creation into helper method(s) that take(s) text and return complete DOM element
 * Clean up this mess - Make sure everything follows StandardJS
 */
