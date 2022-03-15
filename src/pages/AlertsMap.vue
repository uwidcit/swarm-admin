<template>
    <div id="wrapper">
  <GoogleMap
  api-key=""
  style="width: 100%; height: 635px"
  :center="center"
  :zoom="15"
  >
    <Marker :options="{ position: center }" />
  </GoogleMap>
   <div id="over_map">
     <q-btn color="primary" icon="fas fa-exclamation-triangle" label="All Alerts" @click="all_alerts= true"/>
     <q-btn color="primary" icon="fas fa-book-open" label="History" @click="history= true"/>
    </div>
  </div>
  <q-dialog
      v-model="history"
      :maximized="maximizedToggle"
      transition-show="slide-up"
      transition-hide="rotate"
      seamless
    >
      <q-card class="bg-primary text-white" :style="dialogStyle" >
        <q-bar v-touch-pan.mouse="onPan">
          <q-icon name="fas fa-book-open"/>
          <div>Alerts History</div>
          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip class="bg-white text-primary">Close</q-tooltip>
          </q-btn>
        </q-bar>

        <q-card-section>
          <div class="text-h6">Resolved Alerts</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <p>none</p>
        </q-card-section>
      </q-card>
    </q-dialog>

    <q-dialog
      v-model="all_alerts"
      :maximized="maximizedToggle"
      transition-show="slide-up"
      transition-hide="rotate"
      seamless
    >
      <q-card class="bg-primary text-white" :style="dialogStyle" >
        <q-bar v-touch-pan.mouse="onPan">
          <q-icon name="fas fa-book-open"/>
          <div>All Alerts</div>
          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip class="bg-white text-primary">Close</q-tooltip>
          </q-btn>
        </q-bar>

        <q-card-section>
          <div class="text-h6">Alerts</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <p>none</p>
        </q-card-section>
      </q-card>
    </q-dialog>
</template>

<script>
import { defineComponent, ref } from 'vue'
import { GoogleMap, Marker } from 'vue3-google-map'

export default defineComponent({
  components: { 
    GoogleMap, 
    Marker,
     },
      data () {
    return {
      dialogVis: false,
      dialogPos: {
        x: 0,
        y: 0,
      }
    }
  },
  /*mounted() {
      let recaptchaScript = document.createElement('script')
      recaptchaScript.setAttribute('src', 'https://unpkg.com/vue3-google-map')
      document.head.appendChild(recaptchaScript)
    },*/

  computed: {
    dialogStyle() {
      return {
        transform: `translate(${this.dialogPos.x}px, ${this.dialogPos.y}px)`
      }
    }
  },
  
  methods: {
    onPan(evt) {
      this.dialogPos = {
        x: this.dialogPos.x + evt.delta.x,
        y: this.dialogPos.y + evt.delta.y
      }
    }
  },
  setup() {
    const center = { lat: 10.643423917461453, lng: -61.39967380855142 }
    const markerOptions = { position: center, label: 'U', title: 'UWI' }
    return { center, markerOptions ,history: ref(false),all_alerts: ref(false),maximizedToggle: ref(false),}
  },
})
</script>
<style>
   #wrapper { position: relative; }
   #over_map { position: absolute; top: 10px; left: 10px; z-index: 99; }
</style>
