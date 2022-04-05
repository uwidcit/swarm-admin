<template>
  <q-page>
    <div id="wrapper">
    <div id="map" style=" height: 92.7vh; width: 100%"></div>
    <div id="over_map">
     <q-btn color="primary" icon="fas fa-exclamation-triangle" label="All Alerts" @click="all_alerts= true"/>
     <q-btn color="primary" icon="fas fa-book-open" label="History" @click="history= true"/>
    </div>
  </div>
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

        <q-card-section v-for="alert in alerts " :key="alert.created" class="q-pt-none">
        <div class="text-h7">
         <ul>
           <li>
          <p>User: {{alert.userID}} <br />
            Alert: {{alert.text}} <br />
            Created: {{alert.created}}<br />
                Composed: {{alert.composed}}<br />
                latitude: {{alert.latitude}}<br />
                longitude: {{alert.longitude}}</p>
           </li>
         </ul>
         </div>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import { api } from 'boot/axios'
import axios from 'axios';
import { onMounted} from 'vue'

export default defineComponent({
  name: "Map",
  data () {
    return {
      dialogVis: false,
      dialogPos: {
        x: 0,
        y: 0,
      },
       infoWindowOptions: {
                pixelOffset: {
                    width: 0,
                    height: -35
                }
            },
      
    }
    
  },
   /*async created () {
    try {
        const response = await axios.get('https://swarmnet-prod.herokuapp.com/alerts', {
            headers: {
                  'Access-Control-Allow-Origin': '*',
                  Authorization:'JWT '+ localStorage.getItem('token'),
            }
        });

        this.alerts=response.data;
    } catch (err) {
        // Handle Error Here
        console.error(err);
    }
},*/
  computed: {
    dialogStyle() {
      return {
        transform: `translate(${this.dialogPos.x}px, ${this.dialogPos.y}px)`
      }
    },
  },
  
  methods: {
    onPan(evt) {
      this.dialogPos = {
        x: this.dialogPos.x + evt.delta.x,
        y: this.dialogPos.y + evt.delta.y
      }
    },
  },
  setup() {
    const alerts = ref([])
    
    const data = ref(null)

       /*function loadAlerts () {
    api.get('https://swarmnet-prod.herokuapp.com/alerts',{
  method: 'GET',
  
  headers: {
          Authorization:'JWT '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
          
        }
    })
    .then((response) => { 
        data.value = response.data
        for (let i of data.value) { 
          alerts.value.push(i)
        }
       
      })
      .catch(() => {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: 'Loading failed',
          icon: 'report_problem'
        })
      })
  } */
    function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
         zoom: 8,
         center: new google.maps.LatLng(10.643423917461453,-61.39967380855142),
         mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow;

    var marker, i;
      
      api.get('https://swarmnet-prod.herokuapp.com/alerts',{
  method: 'GET',
  
  headers: {
          Authorization:'JWT '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
          
        }
    })
    .then((response) => { 
        data.value = response.data
        for (let i of data.value) { 
          
          alerts.value.push(i)
          //console.log(i.longitude,i.latitude)
           marker = new google.maps.Marker({
          
             position: new google.maps.LatLng(i.latitude,i.longitude),
             map: map
        });
        google.maps.event.addListener(marker, 'click', (function(marker) {
             return function() {
                 infowindow.setContent("User : "+ i.userID+ "<br/> Created: " + i.created+"<br/> Alert : "+i.text);
                 infowindow.open(map, marker);
             }
        })(marker));
          
        }
       
      })
      .catch(() => {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: 'Loading failed',
          icon: 'report_problem'
        })
      })
  
  
       
          
 //for (i = 0; i < alerts.length; i++) {  
  // for (const alert of Object.entries(alerts) ){
  // for (var alert in alerts){
    //Object.keys(alerts).forEach(alert => {
     // for (let i of alerts.value) { 
      /* for (let x of alerts.value) { 
          console.log("test")
         console.log(x)
        marker = new google.maps.Marker({
          
             position: new google.maps.LatLng(x.latitude,x.longitude),
             map: map
        });

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
             return function() {
                 infowindow.setContent(x.text);
                 infowindow.open(map, marker);
             }
        })(marker, i));
  }*/
    
}

 
/*onMounted(() => {
      loadAlerts();
    })*/
    return {
      mapData: ref(''),initMap,history: ref(false),all_alerts: ref(false),maximizedToggle: ref(false),alerts//loadAlerts
    
      
    }
  },
  mounted() {
    this.initMap();
   
  },
})
</script>
<style scoped>
   #wrapper { position: relative; }
   #over_map { position: absolute; top: 10px; right: 500px; z-index: 99; }
</style>