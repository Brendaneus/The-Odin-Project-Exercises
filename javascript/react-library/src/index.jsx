import React from 'react'
import ReactDOM from 'react-dom'

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
        <td><input name='pages' placeholder='Pages' type='number' defaultValue={pages} onChange={this.props.handlePagesChange} /></td>
        <td><button onClick={this.props.handleStatusClick}>{status}</button></td>
        <td><button onClick={this.props.handleRemoveClick}>Remove</button></td>
      </tr>
    )
  }
}

class Library extends React.Component {
  constructor (props) {
    super(props)
    const bookData = props.bookData || [{ key: Library.nextKey++, title: '', author: '', pages: 0, status: 'Unread' }]
    this.state = { bookData: bookData }
  }

  createBook () {
    const newBookData = this.state.bookData
    const key = Library.nextKey++
    const newBook = {
      key: key,
      title: '',
      author: '',
      pages: 0,
      status: 'Unread'
    }
    newBookData.push(newBook)
    this.setState({ bookData: newBookData })
  }

  onTitleChange (key, e) {
    const newBookData = this.state.bookData.map((book) => {
      if (book.key === key) {
        book.title = e.target.value
      }
      return book
    })
    this.setState({ bookData: newBookData })
  }

  onAuthorChange (key, e) {
    const newBookData = this.state.bookData.map((book) => {
      if (book.key === key) {
        book.author = e.target.value
      }
      return book
    })
    this.setState({ bookData: newBookData })
  }

  onPagesChange (key, e) {
    const newBookData = this.state.bookData.map((book) => {
      if (book.key === key) {
        book.pages = e.target.value
      }
      return book
    })
    this.setState({ bookData: newBookData })
  }

  onStatusClick (key, e) {
    const newBookData = this.state.bookData.map((book) => {
      if (book.key === key) {
        console.log(book)
        if (book.status === 'Unread') {
          book.status = 'Reading'
        } else if (book.status === 'Reading') {
          book.status = 'Read'
        } else {
          book.status = 'Unread'
        }
      }
      return book
    })
    this.setState({ bookData: newBookData })
  }

  onRemoveClick (key, e) {
    const newBookData = this.state.bookData.filter((book) => {
      return !(book.key === key)
    })
    this.setState({ bookData: newBookData })
  }

  // loadData

  // saveData

  render () {
    const books = []

    this.state.bookData.forEach((book) => {
      books.push(
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
      <table>
        <thead>
          <tr>
            <th>Title</th>
            <th>Author</th>
            <th>Pages</th>
            <th>Status</th>
            <th />
          </tr>
        </thead>
        <tbody>
          {books}
        </tbody>
        <tr colSpan='5'>
          <button onClick={this.createBook.bind(this)}>Create New</button>
        </tr>
      </table>
    )
  }
}
Library.nextKey = 0

// --------------------------------

const BOOKS = [
  { key: 0, title: 'test', author: 'man', pages: 100, status: 'Reading' },
  { key: 1, title: 'test', author: 'man', pages: 100, status: 'Reading' },
  { key: 2, title: 'test', author: 'man', pages: 100, status: 'Reading' }
]

ReactDOM.render(
  <Library />,
  document.getElementById('root')
)

// TODO: Change create button to automatic process
// TODO: Add sorting states
// TODO: Add load/save on change
