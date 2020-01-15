// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'

// Vue.use(TurbolinksAdapter)

/* eslint-disable no-new */
document.addEventListener('turbolinks:load', loadVue, { once: true })
document.addEventListener('turbolinks:render', loadVue)

function loadVue () {
  if (document.querySelector('#score-display') == null) return

  Turbolinks.clearCache()

  new Vue({
    el: '#score-display',
    data: {
      elapsedTime: 0,
      timer: null
    },
    mounted: function () {
      this.elapsedTime = Number.parseInt(this.$el.attributes['initial-time'].value)
      this.setTimer()
    },
    methods: {
      setTimer: function () {
        this.timer = setInterval(function () {
          this.elapsedTime += 1
        }.bind(this), 1000)
      }
    }
  })
}
