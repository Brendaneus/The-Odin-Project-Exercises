class Form {
  static setup () {
    Form.root = document.createElement('form')

    // Email
    Form.email.set = document.createElement('div')
    Form.email.label = document.createElement('label')
    Form.email.label.for = 'email'
    Form.email.label.innerText = 'Email:'
    Form.email.input = document.createElement('input')
    Form.email.input.name = 'email'
    Form.email.input.type = 'text'
    Form.email.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.email.input.pattern = '^[a-zA-Z0-9-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$'
    Form.email.input.onchange = Form.validateEmail
    Form.email.message = document.createElement('span')
    // Form.email.message.className = 'hidden' // Uncomment when adding styles
    Form.email.set.appendChild(Form.email.label)
    Form.email.set.appendChild(Form.email.input)
    Form.email.set.appendChild(Form.email.message)

    // Email Confirmation
    Form.emailConfirm.set = document.createElement('div')
    Form.emailConfirm.label = document.createElement('label')
    Form.emailConfirm.label.for = 'email_confimation'
    Form.emailConfirm.label.innerText = 'Email Confimation:'
    Form.emailConfirm.input = document.createElement('input')
    Form.emailConfirm.input.name = 'email_confimation'
    Form.emailConfirm.input.type = 'text'
    Form.emailConfirm.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.emailConfirm.input.pattern = '^[a-zA-Z0-9-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$'
    Form.emailConfirm.input.onchange = Form.matchEmails
    Form.emailConfirm.message = document.createElement('span')
    // Form.emailConfirm.message.className = 'hidden' // Uncomment when adding styles
    Form.emailConfirm.set.appendChild(Form.emailConfirm.label)
    Form.emailConfirm.set.appendChild(Form.emailConfirm.input)
    Form.emailConfirm.set.appendChild(Form.emailConfirm.message)

    // Country
    Form.country.set = document.createElement('div')
    Form.country.label = document.createElement('label')
    Form.country.label.for = 'country'
    Form.country.label.innerText = 'Country:'
    Form.country.input = document.createElement('input')
    Form.country.input.name = 'country'
    Form.country.input.type = 'text'
    Form.country.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.country.input.pattern = '^[A-Z][a-zA-Z -]*$'
    Form.country.input.onchange = Form.validateCountry
    Form.country.message = document.createElement('span')
    // Form.country.message.className = 'hidden' // Uncomment when adding styles
    Form.country.set.appendChild(Form.country.label)
    Form.country.set.appendChild(Form.country.input)
    Form.country.set.appendChild(Form.country.message)

    // Zip Code
    Form.zipCode.set = document.createElement('div')
    Form.zipCode.label = document.createElement('label')
    Form.zipCode.label.for = 'zip_code'
    Form.zipCode.label.innerText = 'Zip Code:'
    Form.zipCode.input = document.createElement('input')
    Form.zipCode.input.name = 'zip_code'
    Form.zipCode.input.type = 'text'
    Form.zipCode.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.zipCode.input.pattern = '^[0-9]{5}$'
    Form.zipCode.input.onchange = Form.validateZipCode
    Form.zipCode.message = document.createElement('span')
    // Form.zipCode.message.className = 'hidden' // Uncomment when adding styles
    Form.zipCode.set.appendChild(Form.zipCode.label)
    Form.zipCode.set.appendChild(Form.zipCode.input)
    Form.zipCode.set.appendChild(Form.zipCode.message)

    // Password
    Form.password.set = document.createElement('div')
    Form.password.label = document.createElement('label')
    Form.password.label.for = 'password'
    Form.password.label.innerText = 'Password:'
    Form.password.input = document.createElement('input')
    Form.password.input.name = 'password'
    Form.password.input.type = 'password'
    Form.password.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.password.input.pattern = '.{8,}'
    Form.password.input.onchange = Form.validatePassword
    Form.password.message = document.createElement('span')
    // Form.password.message.className = 'hidden' // Uncomment when adding styles
    Form.password.set.appendChild(Form.password.label)
    Form.password.set.appendChild(Form.password.input)
    Form.password.set.appendChild(Form.password.message)

    // Password Confirmation
    Form.passwordConfirm.set = document.createElement('div')
    Form.passwordConfirm.label = document.createElement('label')
    Form.passwordConfirm.label.for = 'password_confirm'
    Form.passwordConfirm.label.innerText = 'Password Confirmation:'
    Form.passwordConfirm.input = document.createElement('input')
    Form.passwordConfirm.input.name = 'password_confirm'
    Form.passwordConfirm.input.type = 'password'
    Form.passwordConfirm.input.required = true
    /* eslint-disable-next-line no-useless-escape */
    Form.passwordConfirm.input.pattern = '.{8,}'
    Form.passwordConfirm.input.onchange = Form.matchPasswords
    Form.passwordConfirm.message = document.createElement('span')
    // Form.passwordConfirm.message.className = 'hidden' // Uncomment when adding styles
    Form.passwordConfirm.set.appendChild(Form.passwordConfirm.label)
    Form.passwordConfirm.set.appendChild(Form.passwordConfirm.input)
    Form.passwordConfirm.set.appendChild(Form.passwordConfirm.message)

    // Submit Button
    Form.submit.set = document.createElement('div')
    Form.submit.button = document.createElement('button')
    Form.submit.button.innerText = 'Submit'
    Form.submit.button.onclick = Form.submitForm
    Form.submit.message = document.createElement('span')
    // Form.submit.message.className = 'hidden' // Uncomment when adding styles
    Form.submit.set.appendChild(Form.submit.button)
    Form.submit.set.appendChild(Form.submit.message)

    // Add all labels and inputs to form...
    Form.root.appendChild(Form.email.set)
    Form.root.appendChild(Form.emailConfirm.set)
    Form.root.appendChild(Form.country.set)
    Form.root.appendChild(Form.zipCode.set)
    Form.root.appendChild(Form.password.set)
    Form.root.appendChild(Form.passwordConfirm.set)
    Form.root.appendChild(Form.submit.set)
    // ...and add form to body
    document.querySelector('body').appendChild(Form.root)
  }

  static validateEmail () {
    var valid = null
    if (Form.email.input.value === '') {
      Form.email.message.className = 'notice'
      Form.email.message.innerText = 'This field is required.'
      valid = false
    } else if (!Form.email.input.value.match(/^[a-zA-Z0-9-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$/)) {
      Form.email.message.className = 'error'
      Form.email.message.innerText = "Email must match the format 'user@domain.com'."
      valid = false
    } else {
      // Form.email.message.className = 'hidden' // Uncomment when adding styles
      Form.email.message.innerText = ''
      valid = true
    }

    const emailsMatching = Form.matchEmails()
    valid = (emailsMatching === null) ? valid : emailsMatching

    return valid
  }

  static matchEmails () {
    var valid = null
    if (Form.emailConfirm.input.value === '') {
      Form.emailConfirm.message.className = 'notice'
      Form.emailConfirm.message.innerText = 'Set this to match.'
    } else if (Form.email.input.value !== Form.emailConfirm.input.value) {
      Form.emailConfirm.message.className = 'error'
      Form.emailConfirm.message.innerText = 'Emails must match.'
      valid = false
    } else {
      // Form.emailConfirm.message.className = 'hidden' // Uncomment when adding styles
      Form.emailConfirm.message.innerText = ''
      valid = true
    }

    return valid
  }

  static validateCountry () {
    var valid = null
    if (Form.country.input.value === '') {
      Form.country.message.className = 'notice'
      Form.country.message.innerText = 'This field is required.'
      valid = false
    } else if (!Form.country.input.value.match(/^[A-Z][a-zA-Z -]*$/)) {
      Form.country.message.className = 'error'
      Form.country.message.innerText = 'Country name must be capitalized and made of letters, spaces, and hyphens.'
      valid = false
    } else {
      // Form.country.message.className = 'hidden' // Uncomment when adding styles
      Form.country.message.innerText = ''
      valid = true
    }

    return valid
  }

  static validateZipCode () {
    var valid = null
    if (Form.zipCode.input.value === '') {
      Form.zipCode.message.className = 'notice'
      Form.zipCode.message.innerText = 'This field is required.'
      valid = false
    } else if (!Form.zipCode.input.value.match(/^[0-9]{5}$/)) {
      Form.zipCode.message.className = 'error'
      Form.zipCode.message.innerText = 'Zip code must be 5 digits.'
      valid = false
    } else {
      // Form.zipCode.message.className = 'hidden' // Uncomment when adding styles
      Form.zipCode.message.innerText = ''
      valid = true
    }

    return valid
  }

  static validatePassword () {
    var valid = null
    /* eslint-disable no-useless-escape */
    if (Form.password.input.value === '') {
      Form.password.message.className = 'notice'
      Form.password.message.innerText = 'This field is required.'
      valid = false
    } else if (Form.password.input.value.length < 8) {
      Form.password.message.className = 'error'
      Form.password.message.innerText = 'Password must be at least 8 characters long'
      valid = false
    } else if (!Form.password.input.value.match(/[A-Z]/) ||
        !Form.password.input.value.match(/\d/) ||
        !Form.password.input.value.match(/[-!$%^&*()_+|~=`{}\[\]:";'<>?,\./]/)) {
      Form.password.message.className = 'error'
      Form.password.message.innerText = 'Password must contain a capital letter, number, and symbol.'
      valid = false
    } else {
      // Form.password.message.className = 'hidden' // Uncomment when adding styles
      Form.password.message.innerText = ''
      valid = true
    }
    /* eslint-enable no-useless-escape */

    const passwordsMatching = Form.matchPasswords()
    valid = (passwordsMatching === null) ? valid : passwordsMatching

    return valid
  }

  static matchPasswords () {
    var valid = null
    if (Form.passwordConfirm.input.value === '') {
      Form.passwordConfirm.message.className = 'notice'
      Form.passwordConfirm.message.innerText = 'Set this to match.'
      valid = false
    } else if (Form.password.input.value !== Form.passwordConfirm.input.value) {
      Form.passwordConfirm.message.className = 'error'
      Form.passwordConfirm.message.innerText = 'Passwords must match.'
      valid = false
    } else {
      // Form.passwordConfirm.message.className = 'hidden' // Uncomment when adding styles
      Form.passwordConfirm.message.innerText = ''
      valid = true
    }

    return valid
  }

  static submitForm () {
    if (Form.validateEmail() && Form.validateCountry() && Form.validateZipCode() && Form.validatePassword()) {
      Form.submit.message.class = ''
      Form.submit.message.innerText = ''
      window.alert('Success!')
    } else {
      Form.submit.message.class = 'error'
      Form.submit.message.innerText = 'All fields must be filled before submission.'
    }
  }
}

Form.root = null
Form.email = {}
Form.emailConfirm = {}
Form.country = {}
Form.zipCode = {}
Form.password = {}
Form.passwordConfirm = {}
Form.submit = {}

window.onload = Form.setup

// TODO: Figure out HTML's finicky regex implementation
// TODO: Add animations for emphasis (eg - password and confirmation mismatch)
// TODO: Make confirmations appear upon matching set focus?
