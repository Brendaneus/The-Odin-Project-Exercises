// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
require('./image-modules.js')

// Vue.use(TurbolinksAdapter)

/* eslint-disable no-new */
document.addEventListener('turbolinks:load', loadVue, { once: true })
document.addEventListener('turbolinks:render', loadVue)

function loadVue () {
  if (document.querySelector('main#picture') == null) return

  Turbolinks.clearCache()

  new Vue({
    el: '#picture',
    data: function () {
      return {
        finished: null,
        message: {
          text: null,
          type: null
        },
        initialTime: null,
        time: {
          total: 0,
          added: 0
        },
        timer: null,
        selection: {
          active: null,
          moving: null,
          contexted: null,
          x_coord: null,
          y_coord: null,
          character_id: null
        },
        characters: [],
        locations: [],
        hintsUrl: document.querySelector('span.hints-url').innerText,
        matchesUrl: document.querySelector('span.matches-url').innerText,
        guessUrl: document.querySelector('span.guess-url').innerText
      }
    },
    mounted: function () {
      this.setMessage('notice', 'Loading game, please wait...')
      this.loadGame()
    },
    methods: {
      print: function (...values) {
        values.forEach((value) => {
          console.log(JSON.parse(JSON.stringify(value)))
        })
      },
      setMessage: function (type, message) {
        this.message.text = message
        this.message.type = type
      },
      startTimer: function () {
        this.timer = setInterval(function () {
          this.time.total += 1
          this.time.added += 1
        }.bind(this), 1000)
      },
      stopTimer: function () {
        clearInterval(this.timer)
      },
      welcome: function () {
        this.setMessage('notice', ((this.initialTime == 0) ? 'New Game Started. Welcome' : 'Game Loaded. Welcome Back'))
      },
      finishGame: function () {
        this.finished = true
        this.stopTimer()
      },
      constrained: function (number) {
        return (number < 0) ? 0 : (number > 100) ? 100 : number
      },
      updateCoords: function (event) {
        this.selection.x_coord = this.constrained((event.pageX - event.currentTarget.offsetLeft) * 100 / event.currentTarget.offsetWidth)
        this.selection.y_coord = this.constrained((event.pageY - event.currentTarget.offsetTop) * 100 / event.currentTarget.offsetHeight)
      },
      handleMouseDown: function (event) {
        if ((event.target === event.currentTarget)) {
          this.closeSelection()
          this.setContext()
        }
        // console.log('REMINDER: Filter non-primary keys on-click')

        this.selection.active = true
        this.selection.moving = true

        this.updateCoords(event)
      },
      handleMouseMove: function (event) {
        if (!this.selection.moving) { return }

        this.updateCoords(event)
      },
      handleMouseUp: function (event) {
        if (!this.selection.active || this.selection.contexted) { return }

        this.selection.moving = false
        this.updateCoords(event)
        this.setContext()
        this.selection.contexted = true
      },
      closeSelection: function () {
        this.selection.active = false
        this.selection.moving = false
        this.selection.contexted = false
        this.selection.x_coord = 0
        this.selection.y_coord = 0
        this.selection.character_id = null
      },
      setContext: function (focus) {
        this.locations.forEach((location, index) => {
          if (focus && (location.id === focus.id)) {
            this.locations[index].contexted = true
          } else {
            this.locations[index].contexted = false
          }
        })
      },
      layerAreas: function (focus, unfocus) {
        if (this.selection.active || this.selection.contexted) {
          this.closeSelection()
        }
        if (focus) {
          const focusedLocation = this.locations.splice(this.locations.findIndex((location) => { return (location.id === focus.id) }), 1)[0]
          this.locations.push(focusedLocation)
          this.setContext(focus)
        } else if (unfocus) {
          const unfocusedLocation = this.locations.splice(this.locations.findIndex((location) => { return (location.id === unfocus.id) }), 1)[0]
          this.locations.unshift(unfocusedLocation)
          this.setContext()
        }
      },
      selectCharacter: function (character) {
        this.selection.character_id = character.id
      },
      submitSelection: function (url) {
        var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        var data = {
          guess: { /* eslint-disable no-undef */
            x_coord: this.selection.x_coord,
            y_coord: this.selection.y_coord,
            character_id: this.selection.character_id
          } /* eslint-enable no-undef */
        }

        var goodResponse = null
        const self = this
        const selectedCharacterId = this.selection.character_id
        var selectedCharacterName = this.characters.find((character) => {
          return (character.id == selectedCharacterId)
        }).name

        /* eslint-disable-next-line no-undef */
        fetch(this.guessUrl, {
          method: 'POST',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify(data)
        }).then(function (response) {
          goodResponse = response.ok
          return response.json()
        }).then(function (json) {
          if (goodResponse) {
            if (json.discovery) {
              const matchedIndex = self.characters.findIndex((character) => {
                return character.id == selectedCharacterId
              })
              self.characters[matchedIndex].available = false

              self.getMatches()

              self.setMessage('success', `You found ${selectedCharacterName}!`)
            }

            if (json.finished) {
              self.finishGame()
            }
          } else {
            self.setMessage('failure', `Couldn't find ${selectedCharacterName} there. Try again!`)
          }
        }).catch(function (error) {
          self.setMessage('error', 'There was a problem handling your guess.')
          console.error('Request Failed!', error)
        })

        this.closeSelection()
      },
      getHints: function (stackLoad, attemptCounter = 0) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

        var goodResponse = null
        const self = this

        /* eslint-disable-next-line no-undef */
        fetch(this.hintsUrl, {
          method: 'GET',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          }
        }).then(function (response) {
          goodResponse = response.ok
          return response.json()
        }).then(function (json) {
          if (goodResponse) {
            if (stackLoad) {
              self.getMatches(stackLoad)
            }
            self.characters = json
          } else {
            throw new Error(json)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.getHints(stackLoad, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was a problem loading the character selection.')
          }
        })
      },
      getMatches: function (stackLoad, attemptCounter = 0) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

        var goodResponse = null
        const self = this

        /* eslint-disable-next-line no-undef */
        return fetch(this.matchesUrl, {
          method: 'GET',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          }
        }).then(function (response) {
          goodResponse = response.ok
          return response.json()
        }).then(function (json) {
          if (goodResponse) {
            if (stackLoad) {
              self.welcome()
            }
            self.locations = json.map((gottenMatch) => { return ({ ...gottenMatch, contexted: null }) })
          } else {
            throw new Error(json)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.getMatches(stackLoad, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was a problem loading your matched characters.')
          }
          return null
        })
      },
      loadGame: function () {
        this.initialTime = Number.parseInt(this.$el.attributes['initial-time'].value)
        this.time.total = this.initialTime
        this.finished = (this.$el.attributes.finished.value == 'true')
        if (!this.finished) {
          this.startTimer()
        }
        this.getHints(true)
      }
    }
  })
}
