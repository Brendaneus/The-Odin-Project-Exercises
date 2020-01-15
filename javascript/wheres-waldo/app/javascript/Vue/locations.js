// TODO: Add filter for non-primary mouse clicks

// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
require('./image-modules.js')

// Vue.use(TurbolinksAdapter)

/* eslint-disable no-new */
document.addEventListener('turbolinks:load', loadVue, { once: true })
document.addEventListener('turbolinks:render', loadVue)

function loadVue () {
  if (document.querySelector('main#locations') == null) return

  Turbolinks.clearCache()

  new Vue({
    el: '#locations',
    data: {
      message: {
        text: null,
        type: null
      },
      selection: { // move to component, send thru callbacks
        active: null,
        resizing: null,
        contexted: null,
        originX: null,
        originY: null,
        top: null,
        left: null,
        width: null,
        height: null,
        character_id: null,
        hint: null
      },
      characters: [],
      locations: [],
      selectionsUrl: document.querySelector('span.selections-url').innerText,
      locationsUrl: document.querySelector('span.locations-url').innerText
    },
    mounted: function () {
      this.setMessage('notice', 'Loading data, please wait...')
      this.loadData()
    },
    methods: {
      print: function (value) {
        console.log(JSON.parse(JSON.stringify(value)))
      },
      setMessage: function (type, message) {
        this.message.text = message
        this.message.type = type
      },
      constrained: function (number) {
        return (number < 0) ? 0 : (number > 100) ? 100 : number
      },
      updateCoords: function (event) {
        var offsetX = this.constrained((event.pageX - event.currentTarget.offsetLeft) * 100 / event.currentTarget.offsetWidth)
        var offsetY = this.constrained((event.pageY - event.currentTarget.offsetTop) * 100 / event.currentTarget.offsetHeight)
        this.selection.left = (this.selection.originX < offsetX)
          ? this.selection.originX : this.constrained(offsetX)
        this.selection.top = (this.selection.originY < offsetY)
          ? this.selection.originY : this.constrained(offsetY)
        this.selection.width = this.constrained(Math.abs(this.selection.originX - offsetX))
        this.selection.height = this.constrained(Math.abs(this.selection.originY - offsetY))
      },
      handleMouseDown: function (event) {
        if ((event.target === event.currentTarget)) {
          this.closeSelection()
          this.setContext()
        }
        // console.log('REMINDER: Filter non-primary keys on-click')

        this.selection.active = true
        this.selection.resizing = true

        this.selection.originX = this.constrained((event.pageX - event.currentTarget.offsetLeft) * 100 / event.currentTarget.offsetWidth)
        this.selection.originY = this.constrained((event.pageY - event.currentTarget.offsetTop) * 100 / event.currentTarget.offsetHeight)

        this.updateCoords(event)
      },
      handleMouseMove: function (event) {
        if (!this.selection.active || !this.selection.resizing) { return }

        this.updateCoords(event)
      },
      handleMouseUp: function (event) {
        if (!this.selection.active || this.selection.contexted) { return }

        this.updateCoords(event)

        this.setContext()
        this.selection.resizing = false
        if ((this.selection.height > 0.5) && (this.selection.width > 0.5)) {
          this.selection.contexted = true
        } else {
          this.closeSelection()
        }
      },
      closeSelection: function () {
        this.selection.active = false
        this.selection.contexted = false
        this.selection.resizing = false
        this.selection.originX = 0
        this.selection.originY = 0
        this.selection.top = 0
        this.selection.left = 0
        this.selection.width = 0
        this.selection.height = 0
        this.selection.character_id = null
        this.selection.hint = ''
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
        if (this.selection.contexted) {
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
      submitSelection: function (attemptCounter = 0) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        const data = {
          location: {
            left_coord: this.selection.left,
            right_coord: (this.selection.left + this.selection.width),
            top_coord: (this.selection.top),
            bottom_coord: (this.selection.top + this.selection.height),
            character_id: this.selection.character_id,
            hint: this.selection.hint
          }
        }

        var goodRequest = null
        const self = this

        /* eslint-disable-next-line no-undef */
        fetch(this.locationsUrl, {
          method: 'POST',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify(data)
        }).then(function (response) {
          goodRequest = response.ok
          return response.json()
        }).then(function (json) {
          if (goodRequest) {
            self.locations = self.locations.concat([{ ...json, contexted: false }])

            self.setMessage('notice', 'New location has been added.')
          } else {
            console.log(json)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.submitSelection(++attemptCounter)
          } else {
            self.setMessage('error', 'There was an error creating this selection.')
          }
        })

        this.closeSelection()
      },
      updateLocation: function (locationData, attemptCounter = 0) {
        const url = this.locationsUrl + '/' + locationData.id
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        const data = {
          location: {
            left_coord: locationData.left,
            right_coord: locationData.left,
            top_coord: locationData.top,
            bottom_coord: locationData.top,
            character: locationData.character,
            hint: locationData.hint
          }
        }

        var goodRequest = null
        const self = this

        /* eslint-disable-next-line no-undef */
        fetch(url, {
          method: 'PUT',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify(data)
        }).then(function (response) {
          goodRequest = response.ok
          return response.json()
        }).then(function (json) {
          if (goodRequest) {
            console.log(json)
          } else {
            self.locations[self.locations.findIndex((item) => { return (item.id === locationData.id) })] =
              { ...json, contexted: false }

            self.setMessage('notice', 'The location has been updated.')
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.updateLocation(locationData, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was an error updating this location.')
          }
        })
      },
      deleteLocation: function (location, attemptCounter = 0) {
        const url = this.locationsUrl + '/' + location.id
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

        const self = this

        /* eslint-disable-next-line no-undef */
        fetch(url, {
          method: 'DELETE',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          }
        }).then(function (response) {
          if (response.status === 204) {
            self.locations = self.locations.filter((item) => { return (item.id !== location.id) })

            self.setMessage('notice', 'The location has been deleted.')
          } else {
            throw new Error(response.statusText)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.deleteSelection(location, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was an error deleting this location.')
          }
        })
      },
      getCharacters: function (stackLoad, attemptCounter = 0) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

        var goodRequest = null
        const self = this

        /* eslint-disable-next-line no-undef */
        fetch(this.selectionsUrl, {
          method: 'GET',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          }
        }).then(function (response) {
          goodRequest = response.ok
          return response.json()
        }).then(function (json) {
          if (goodRequest) {
            if (stackLoad) {
              self.getLocations(stackLoad)
            }
            self.characters = json
          } else {
            throw new Error(json)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.getCharacters(stackLoad, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was an error loading the character selection.')
          }
        })
      },
      getLocations: function (stackLoad, attemptCounter = 0) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

        var goodRequest = null
        const self = this

        /* eslint-disable-next-line no-undef */
        return fetch(this.locationsUrl, {
          method: 'GET',
          mode: 'cors',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': csrfToken
          }
        }).then(function (response) {
          goodRequest = response.ok
          return response.json()
        }).then(function (json) {
          if (goodRequest) {
            if (stackLoad) {
              self.setMessage('notice', 'Data loaded.  Ready to start editing.')
            }
            self.locations = json.map((newLocation) => { return ({ ...newLocation, contexted: null }) })
          } else {
            throw new Error(json)
          }
        }).catch(function (error) {
          if (attemptCounter < 5) {
            console.error('Request Failed!', error)
            self.submitSelection(stackLoad, ++attemptCounter)
          } else {
            self.setMessage('error', 'There was an error loading the locations.')
          }
          return null
        })
      },
      loadData: function () {
        this.getCharacters(true)
      }
    }
  })
}
