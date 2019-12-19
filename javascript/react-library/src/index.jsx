import React from 'react'
import ReactDOM from 'react-dom'
import './index.css'

class Book extends React.Component {
  render () {
    const title = this.props.title || ''
    const author = this.props.author || ''
    const pages = this.props.pages || null
    const status = this.props.status || 'Unread'

    return (
      <tr>
        <td><input name='title' placeholder='Title' type='text' defaultValue={title} onChange={this.props.handleTitleChange} /></td>
        <td><input name='author' placeholder='Author' type='text' defaultValue={author} onChange={this.props.handleAuthorChange} /></td>
        <td><input name='pages' placeholder='Pages' type='number' min='0' defaultValue={pages} onChange={this.props.handlePagesChange} /></td>
        <td><button onClick={this.props.handleStatusClick}>{status}</button></td>
        <td><button onClick={this.props.handleRemoveClick}>Remove</button></td>
      </tr>
    )
  }
}

class Library extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      sortOptions: {
        title: '',
        author: '',
        pages: '',
        status: ''
      },
      titleFilter: '',
      authorFilter: '',
      autoSaveOn: JSON.parse(window.localStorage.getItem('autoSaveOn'))
    }

    if (this.state.autoSaveOn) {
      this.state.books = JSON.parse(window.localStorage.getItem('savedBooks'))
    } else {
      this.state.books = props.books || [this.newBook()]
    }
  }

  usingKey (key) {
    return this.state.books.some((book) => {
      return (book.key === key)
    })
  }

  hasNew () {
    const newestBook = this.state.books.slice(-1).pop()

    return (newestBook !== undefined) &&
      (newestBook.title === null) &&
      (newestBook.author === null) &&
      (newestBook.pages === null) &&
      (newestBook.status === null)
  }

  // Change keys to local variable based on lowest key in use?
  newBook () {
    let newKey = 0

    if ((this.state.books) && (this.state.books.length > 0)) {
      newKey = this.state.books.reduce((first, second) => {
        return (second.key > first.key) ? second : first
      }).key + 1
    }

    return {
      key: newKey,
      title: null,
      author: null,
      pages: null,
      status: null
    }
  }

  loadData () {
    this.setState({ books: JSON.parse(window.localStorage.getItem('savedBooks')) })
  }

  saveData () {
    window.localStorage.setItem('savedBooks', JSON.stringify(this.state.books))
  }

  onTitleChange (key, e) {
    const newBooks = this.state.books.map((book) => {
      if (book.key === key) {
        book.title = e.target.value
      }
      return book
    })
    if (!this.hasNew()) {
      newBooks.push(this.newBook())
    }

    this.setState({ books: newBooks })

    if (this.state.autoSaveOn) this.saveData()
  }

  onAuthorChange (key, e) {
    const newBooks = this.state.books.map((book) => {
      if (book.key === key) {
        book.author = e.target.value
      }
      return book
    })
    if (!this.hasNew()) {
      newBooks.push(this.newBook())
    }

    this.setState({ books: newBooks })

    if (this.state.autoSaveOn) this.saveData()
  }

  onPagesChange (key, e) {
    const newBooks = this.state.books.map((book) => {
      if (book.key === key) {
        book.pages = e.target.value
      }
      return book
    })
    if (!this.hasNew()) {
      newBooks.push(this.newBook())
    }

    this.setState({ books: newBooks })

    if (this.state.autoSaveOn) this.saveData()
  }

  onStatusClick (key, e) {
    const newBooks = this.state.books.map((book) => {
      if (book.key === key) {
        if (book.status === 'Reading') {
          book.status = 'Read'
        } else if (book.status === 'Read') {
          book.status = 'Unread'
        } else {
          book.status = 'Reading'
        }
      }
      return book
    })
    if (!this.hasNew()) {
      newBooks.push(this.newBook())
    }

    this.setState({ books: newBooks })

    if (this.state.autoSaveOn) this.saveData()
  }

  onRemoveClick (key, e) {
    if (this.state.books.slice(-1).pop().key === key) { return }

    const newBooks = this.state.books.filter((book) => {
      return !(book.key === key)
    })
    if (!this.hasNew()) {
      newBooks.push(this.newBook())
    }

    this.setState({ books: newBooks })

    if (this.state.autoSaveOn) this.saveData()
  }

  handleTitleSearchChange (e) {
    this.setState({ titleFilter: e.target.value })
  }

  handleAuthorSearchChange (e) {
    this.setState({ authorFilter: e.target.value })
  }

  handleTitleSortClick (e) {
    const newSortOptions = this.state.sortOptions

    if (this.state.sortOptions.title === 'ascending') {
      newSortOptions.title = 'descending'
    } else if (this.state.sortOptions.title === 'descending') {
      newSortOptions.title = 'none'
    } else {
      newSortOptions.title = 'ascending'
    }

    this.setState({ sortOptions: newSortOptions })
  }

  handleAuthorSortClick (e) {
    const newSortOptions = this.state.sortOptions

    if (this.state.sortOptions.author === 'ascending') {
      newSortOptions.author = 'descending'
    } else if (this.state.sortOptions.author === 'descending') {
      newSortOptions.author = 'none'
    } else {
      newSortOptions.author = 'ascending'
    }

    this.setState({ sortOptions: newSortOptions })
  }

  handlePagesSortClick (e) {
    const newSortOptions = this.state.sortOptions

    if (this.state.sortOptions.pages === 'ascending') {
      newSortOptions.pages = 'descending'
    } else if (this.state.sortOptions.pages === 'descending') {
      newSortOptions.pages = 'none'
    } else {
      newSortOptions.pages = 'ascending'
    }

    this.setState({ sortOptions: newSortOptions })
  }

  handleStatusSortClick (e) {
    const newSortOptions = this.state.sortOptions

    if (this.state.sortOptions.status === 'ascending') {
      newSortOptions.status = 'descending'
    } else if (this.state.sortOptions.status === 'descending') {
      newSortOptions.status = 'none'
    } else {
      newSortOptions.status = 'ascending'
    }

    this.setState({ sortOptions: newSortOptions })
  }

  handleClearClick (e) {
    this.setState({ books: [this.newBook()] })
  }

  handleAutoSaveChange (e) {
    window.localStorage.setItem('autoSaveOn', e.target.checked)
    this.setState({ autoSaveOn: e.target.checked })
  }

  sortTitle (first, second) {
    const titleSort = this.state.sortOptions.title.toLowerCase()
    let firstTitle = first.title
    let secondTitle = second.title

    if (firstTitle != null) {
      firstTitle = firstTitle.toLowerCase()
    }
    if (secondTitle != null) {
      secondTitle = secondTitle.toLowerCase()
    }

    if (titleSort === 'ascending') {
      return ((firstTitle) && (!secondTitle)) ? -1
        : ((!firstTitle) && (secondTitle)) ? 1
          : ((!firstTitle) && (!secondTitle)) ? this.sortAuthor(first, second)
            : (firstTitle < secondTitle) ? -1
              : (firstTitle > secondTitle) ? 1
                : this.sortAuthor(first, second)
    } else if (titleSort === 'descending') {
      return ((firstTitle) && (!secondTitle)) ? 1
        : ((!firstTitle) && (secondTitle)) ? -1
          : ((!firstTitle) && (!secondTitle)) ? this.sortAuthor(first, second)
            : (firstTitle > secondTitle) ? -1
              : (firstTitle < secondTitle) ? 1
                : this.sortAuthor(first, second)
    } else {
      return this.sortAuthor(first, second)
    }
  }

  sortAuthor (first, second) {
    const authorSort = this.state.sortOptions.author.toLowerCase()
    let firstAuthor = first.author
    let secondAuthor = second.author

    if (firstAuthor != null) {
      firstAuthor = firstAuthor.toLowerCase()
    }
    if (secondAuthor != null) {
      secondAuthor = secondAuthor.toLowerCase()
    }

    if (authorSort === 'ascending') {
      return ((firstAuthor) && (!secondAuthor)) ? -1
        : ((!firstAuthor) && (secondAuthor)) ? 1
          : ((!firstAuthor) && (!secondAuthor)) ? this.sortPages(first, second)
            : (firstAuthor < secondAuthor) ? -1
              : (firstAuthor > secondAuthor) ? 1
                : this.sortPages(first, second)
    } else if (authorSort === 'descending') {
      return ((firstAuthor) && (!secondAuthor)) ? 1
        : ((!firstAuthor) && (secondAuthor)) ? -1
          : ((!firstAuthor) && (!secondAuthor)) ? this.sortPages(first, second)
            : (firstAuthor > secondAuthor) ? -1
              : (firstAuthor < secondAuthor) ? 1
                : this.sortPages(first, second)
    } else {
      return this.sortPages(first, second)
    }
  }

  sortPages (first, second) {
    const pagesSort = this.state.sortOptions.pages.toLowerCase()
    let firstPages = first.pages
    let secondPages = second.pages

    if (firstPages != null) {
      firstPages = firstPages.toLowerCase()
    }
    if (secondPages != null) {
      secondPages = secondPages.toLowerCase()
    }

    if (pagesSort === 'ascending') {
      return ((firstPages) && (!secondPages)) ? -1
        : ((!firstPages) && (secondPages)) ? 1
          : ((!firstPages) && (!secondPages)) ? this.sortStatus(first, second)
            : (firstPages < secondPages) ? -1
              : (firstPages > secondPages) ? 1
                : this.sortStatus(first, second)
    } else if (pagesSort === 'descending') {
      return ((firstPages) && (!secondPages)) ? 1
        : ((!firstPages) && (secondPages)) ? -1
          : ((!firstPages) && (!secondPages)) ? this.sortStatus(first, second)
            : (firstPages > secondPages) ? -1
              : (firstPages < secondPages) ? 1
                : this.sortStatus(first, second)
    } else {
      return this.sortStatus(first, second)
    }
  }

  sortStatus (first, second) {
    const statusSort = this.state.sortOptions.status.toLowerCase()
    let firstStatus = first.status
    let secondStatus = second.status

    if (firstStatus != null) {
      firstStatus = firstStatus.toLowerCase()
    }
    if (secondStatus != null) {
      secondStatus = secondStatus.toLowerCase()
    }

    if (statusSort === 'ascending') {
      return ((firstStatus) && (!secondStatus)) ? -1
        : ((!firstStatus) && (secondStatus)) ? 1
          : ((!firstStatus) && (!secondStatus)) ? 0
            : (firstStatus < secondStatus) ? -1
              : (firstStatus > secondStatus) ? 1
                : 0
    } else if (statusSort === 'descending') {
      return ((firstStatus) && (!secondStatus)) ? 1
        : ((!firstStatus) && (secondStatus)) ? -1
          : ((!firstStatus) && (!secondStatus)) ? 0
            : (firstStatus < secondStatus) ? 1
              : (firstStatus > secondStatus) ? -1
                : 0
    } else {
      return 0
    }
  }

  render () {
    const bookListings = []

    const filteredBooks = this.state.books.filter((book, index) => {
      // Allow last book in library (new blank)
      if (index === (this.state.books.length - 1)) { return true }

      let match = true
      // Check against title filter
      if ((this.state.titleFilter.length > 0) &&
        !(book.title.toLowerCase().includes(this.state.titleFilter.toLowerCase()))) {
        match = false
      }
      // Check against author filter
      if ((this.state.authorFilter.length > 0) &&
        !(book.author.toLowerCase().includes(this.state.authorFilter.toLowerCase()))) {
        match = false
      }
      return match
    })

    const sortedBooks = filteredBooks.slice(0, -1).sort((first, second) => {
      return this.sortTitle(first, second)
    })
    sortedBooks.push(filteredBooks.slice(-1).pop())

    sortedBooks.forEach((book) => {
      bookListings.push(
        <Book
          key={book.key}
          title={book.title}
          author={book.author}
          pages={book.pages}
          status={book.status}
          handleTitleChange={this.onTitleChange.bind(this, book.key)}
          handleAuthorChange={this.onAuthorChange.bind(this, book.key)}
          handlePagesChange={this.onPagesChange.bind(this, book.key)}
          handleStatusClick={this.onStatusClick.bind(this, book.key)}
          handleRemoveClick={this.onRemoveClick.bind(this, book.key)}
        />
      )
    })

    return (
      <main>

        <header>
          <h1>A Library in React</h1>
        </header>

        <table>

          <thead>
            <tr>
              <th>
                <div>
                  <button className={this.state.sortOptions.title} onClick={this.handleTitleSortClick.bind(this)}>Title</button>
                  <input type='text' placeholder='Search...' onChange={this.handleTitleSearchChange.bind(this)} />
                </div>
              </th>
              <th>
                <div>
                  <button className={this.state.sortOptions.author} onClick={this.handleAuthorSortClick.bind(this)}>Author</button>
                  <input type='text' placeholder='Search...' onChange={this.handleAuthorSearchChange.bind(this)} />
                </div>
              </th>
              <th>
                <button className={this.state.sortOptions.pages} onClick={this.handlePagesSortClick.bind(this)}>Pages</button>
              </th>
              <th>
                <button className={this.state.sortOptions.status} onClick={this.handleStatusSortClick.bind(this)}>Status</button>
              </th>
              <th />
            </tr>
          </thead>

          <tbody>
            {bookListings}
          </tbody>

        </table>

        <footer>
          <button onClick={this.handleClearClick.bind(this)}>Clear</button>
          <button onClick={this.loadData.bind(this)}>Load Data</button>
          <button onClick={this.saveData.bind(this)}>Save Data</button>
          <div>
            <input type='checkbox' defaultChecked={this.state.autoSaveOn} onChange={this.handleAutoSaveChange.bind(this)} />
            <span>Autosave</span>
          </div>
        </footer>

      </main>
    )
  }
}

// --------------------------------

ReactDOM.render(
  <Library />,
  document.getElementById('root')
)

// TODO: Debounce all text inputs (think filters while populating new)
// TODO: Make Remove button disabled on new books
// TODO: Make entire autosave div clickable
// TODO: Implement better case-wise alphebetizing
// TODO: Add some sort of notification for unloaded data (ie- class on button)
// TODO: Add Delete Data Button
// TODO: Add sample data
// TODO: Clean up!!!!

// IMPORTANT: Separate headers into components for code reuse???
//  - can use calculated variables

// IDEA: Dim text before triggering onChange (separate text?)
