import Vue from 'vue/dist/vue.esm'
require('./timer.js')

Vue.component('display-bar', {
  props: {
    message: Object,
    time: Object,
    quitUrl: String,
    finished: Boolean,
    timed: Boolean,
    inGame: Boolean
  },
  computed: {
    messageClass: function () {
      return `message ${this.message.type}`
    },
    quitText: function () {
      return (this.finished ? 'Finish' : 'Save & Quit')
    }
  },
  template: `
    <nav class="display-bar">
      <timer v-if="timed" :total="time.total" :added="time.added" />
      <h2 :class="messageClass">
        {{ message.text }}
      </h2>
      <a v-if="inGame" class="quit" :href="quitUrl">
        <h3>{{ quitText }}</h3>
      </a>
    </nav>
  `
})

Vue.component('finish-menu', {
  props: {
    finalTime: Number
  },
  computed: {
    formattedTime: function () {
      let seconds = Math.floor(this.finalTime % 60).toString()
      let minutes = Math.floor((this.finalTime / 60) % 60).toString()
      let hours = Math.floor((this.finalTime / (60 * 60))).toString()

      if (seconds.length < 2) { seconds = ('0' + seconds) }
      if (minutes.length < 2) { minutes = ('0' + minutes) }
      if (hours.length < 2) { hours = ('0' + hours) }

      return (hours > 0)
        ? (hours + ':' + minutes + ':' + seconds)
        : (minutes + ':' + seconds)
    }
  },
  template: `
    <section class="finish-menu">
      <h1>Game Over</h1>
      <h3>Your final time: {{ this.formattedTime }}</h3>
      <slot></slot>
    </section>
  `
})

Vue.component('context-menu', {
  props: {
    characters: Array,
    initialCharacterId: Number,
    selectedCharacter: Object,
    hint: String,
    submitText: {
      type: String,
      default: 'Submit'
    },
    selecting: Boolean,
    editing: Boolean,
    deletable: Boolean
  },
  data: function () {
    return {
      expanded: this.hint != null // MOVE THIS STATE UP, RESET ON CLOSE-CLICKED
    }
  },
  computed: {
    styles: function () {
      return {
        position: 'absolute',
        top: '-3px',
        left: 'calc(100% + 5px)',
        width: '160px',
        pointerEvents: 'auto'
      }
    },
    headerText: function () {
      return (this.selecting) ? 'Character Select' : this.selectedCharacterName
    },
    currentImage: function () {
      if (this.characterSelected()) {
        return this.selectedCharacter.avatar_url
      } else {
        return ''
      }
    },
    selectableCharacters: function () {
      return this.characters.filter(this.characterAvailable)
    },
    charactersEmpty: function () {
      return this.selectableCharacters.length === 0
    },
    characterSelectedWithHint: function () {
      return this.characterSelected() && (!!this.selectedCharacter.hint)
    },
    selectedCharacterHint: function () {
      if (this.characterSelected()) {
        return this.selectedCharacter.hint
      } else {
        return ''
      }
    },
    selectedCharacterName: function () {
      if (this.characterSelected()) {
        return this.selectedCharacter.name
      } else {
        return ''
      }
    }
  },
  methods: {
    characterAvailable: function (character) {
      return character.available || this.characterInitial(character.id)
    },
    characterInitial: function (id) {
      return (this.initialCharacterId != null) && (this.initialCharacterId == id)
    },
    characterSelected: function (id) {
      if (id === undefined) {
        return (this.selectedCharacter != null)
      } else {
        return (this.selectedCharacter != null) && (this.selectedCharacter.id === id)
      }
    },
    handleTabClick: function (character) {
      if (this.characterSelected(character.id)) {
        this.$emit('character-selected', '')
      } else {
        this.$emit('character-selected', character)
      }
    },
    handleCloseClick: function () {
      this.expanded = !!this.hint
      this.$emit('close-clicked')
    }
  },
  template: `
    <div class="context-menu" :style="styles">
      <div class="context-header">
        <h4>{{ headerText }}</h4>
        <button class="close"
          @click.stop="handleCloseClick" >
          &#10005;
        </button>
      </div>
      <div class="tab-container">
        <div v-if="selecting" class="tablist">
          <button v-for="character in selectableCharacters"
            :key="character.id"
            :class="{ active: characterSelected(character.id) }"
            @click.stop="handleTabClick(character)">
            {{ character.name }}
          </button>
          <h5 v-if="charactersEmpty">
            No more characters to select!
          </h5>
        </div>
        <div class="avatar" v-show="characterSelected()">
          <img :src="currentImage">
        </div>
      </div>
      <div v-if="editing" class="context-footer">
        <button @click.stop="$emit('submit-clicked')" >
          {{ submitText }}
        </button>
        <button @click.stop="expanded = !expanded">
          Hint
        </button>
        <button v-if="deletable" @click.stop="$emit('delete-clicked')">
          Delete
        </button>
        <input v-show="expanded" class="hint" type="textarea"
          :value="hint" placeholder="Enter a hint..."
          @input.stop="$emit('hint-input', $event.target.value)" />
      </div>
      <div v-else v-show="characterSelected()" class="context-footer">
        <p v-show="characterSelectedWithHint" class="hint">
          {{ hint }}
        </p>
        <button v-if="selecting" @click.stop="$emit('submit-clicked')">
          Check for Match
        </button>
      </div>
    </div>
  `
})

Vue.component('selection-box', {
  props: {
    selection: Object,
    characters: Array,
    selecting: Boolean,
    editing: Boolean
  },
  data: function () {
    return {
      contexted: this.selection.contexted
    }
  },
  computed: {
    locationStyles: function () {
      return {
        position: 'absolute',
        top: `${this.selection.top}%`,
        left: `${this.selection.left}%`,
        width: `${this.selection.width}%`,
        height: `${this.selection.height}%`,
        border: '3px dashed rgba(0,0,0,0.5)',
        pointerEvents: 'none'
      }
    },
    guessStyles: function () {
      return {
        position: 'absolute',
        top: `calc(${this.selection.y_coord}% - 16px)`,
        left: `calc(${this.selection.x_coord}% - 16px)`,
        width: '20px',
        height: '20px',
        border: 'thick solid rgba(0,0,255,0.7)',
        borderRadius: '50%',
        pointerEvents: 'none'
      }
    },
    selectedCharacter: function () {
      return this.characters.find((character) => { return character.id === this.selection.character_id })
    },
    currentHint: function () {
      if (this.editing) {
        return this.selection.hint
      } else {
        if (this.selectedCharacter != null) {
          return this.selectedCharacter.hint
        } else {
          return ''
        }
      }
    }
  },
  template: `
    <div class="selection-box" :style="editing ? locationStyles : guessStyles">
      <context-menu v-show="selection.contexted"
        :characters="characters"
        :selectedCharacter="selectedCharacter"
        :hint="currentHint"
        :selecting="selecting"
        :editing="editing"
        @character-selected="$emit('character-selected', $event)"
        @hint-input="$emit('hint-input')"
        @close-clicked="$emit('close-clicked')"
        @submit-clicked="$emit('submit-clicked')" />
    </div>
  `
})

Vue.component('location-area', {
  props: {
    location: Object,
    characters: Array,
    selecting: Boolean,
    editing: Boolean
  },
  data: function () {
    return {
      initialCharacterId: this.location.character_id,
      locationData: {
        id: this.location.id,
        character_id: this.location.character_id,
        hint: this.location.hint
      }
    }
  },
  computed: {
    styles: function () {
      return {
        display: 'inline-block',
        position: 'absolute',
        top: `${this.location.top_coord}%`,
        left: `${this.location.left_coord}%`,
        width: `${this.location.right_coord - this.location.left_coord}%`,
        height: `${this.location.bottom_coord - this.location.top_coord}%`,
        background: (this.location.contexted ? 'rgba(255,125,0,0.2)' : 'transparent'),
        border: `3px dashed ${this.location.contexted ? 'rgba(255,125,0,0.7)' : 'rgba(0,0,255,0.5)'}`
      }
    },
    selectedCharacter: function () {
      return this.characters.find((character) => { return character.id === this.locationData.character_id })
    }
  },
  methods: {
    handleClick: function () {
      if (this.location.contexted) {
        this.$emit('unfocus-location', this.location)
      } else {
        this.$emit('focus-location', this.location)
      }
    },
    handleChararacterSelect: function (event) {
      if (this.editing) {
        this.locationData.character_id = event.id
      }
    },
    handleHintInput: function (event) {
      this.locationData.hint = event
    },
    handleUpdateClick: function () {
      if (this.editing) {
        this.$emit('update-clicked', this.locationData)
        console.log('TODO: rig up context menus better ...use dynamic calculated placement?')
      }
    },
    handleDeleteClick: function () {
      if (window.confirm('Are you sure?')) {
        this.$emit('delete-clicked', this.location)
      }
    },
    handleCloseClick: function () {
      this.locationData = {
        id: this.location.id,
        character_id: this.location.character_id,
        hint: this.location.hint
      }
      this.$emit('close-clicked')
    }
  },
  template: `
    <div class="location"
      :style="styles"
      @click.self="handleClick" >
      <context-menu v-show="location.contexted"
        :characters="characters"
        :initial-character-id="initialCharacterId"
        :selected-character="selectedCharacter"
        :hint="locationData.hint"
        :selecting="selecting"
        :editing="editing"
        :deletable="editing"
        :submit-text="'Update'"
        @character-selected="handleChararacterSelect"
        @hint-input="handleHintInput"
        @submit-clicked="handleUpdateClick"
        @close-clicked="handleCloseClick"
        @delete-clicked="handleDeleteClick" />
    </div>
  `
})
