import Vue from 'vue/dist/vue.esm'

Vue.component('timer', {
  props: {
    total: Number,
    added: Number
  },
  computed: {
    showingAdded: function () {
      return (this.added != null)
    },
    formattedTotal: function () {
      let seconds = Math.floor(this.total % 60).toString()
      let minutes = Math.floor((this.total / 60) % 60).toString()
      let hours = Math.floor((this.total / (60 * 60))).toString()

      if (seconds.length < 2) { seconds = ('0' + seconds) }
      if (minutes.length < 2) { minutes = ('0' + minutes) }
      if (hours.length < 2) { hours = ('0' + hours) }

      return (hours > 0)
        ? (hours + ':' + minutes + ':' + seconds)
        : (minutes + ':' + seconds)
    },
    formattedAdded: function () {
      let seconds = Math.floor(this.added % 60).toString()
      let minutes = Math.floor((this.added / 60) % 60).toString()
      let hours = Math.floor((this.added / (60 * 60))).toString()

      if (seconds.length < 2) { seconds = ('0' + seconds) }
      if (minutes.length < 2) { minutes = ('0' + minutes) }
      if (hours.length < 2) { hours = ('0' + hours) }

      return (hours > 0)
        ? (hours + ':' + minutes + ':' + seconds)
        : (minutes + ':' + seconds)
    }
  },
  template: `
    <div class="timer">
      <h3 class="total"> {{ formattedTotal }} </h3>
      <h3 v-if="showingAdded" class="added"> {{ formattedAdded }} </h3>
    </div>
  `
})
