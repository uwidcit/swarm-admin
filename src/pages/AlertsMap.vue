<template>
  <q-page>
    <div id="wrapper">
    <div id="map" style=" height: 92.7vh; width: 100%"></div>
    <div id="over_map">
     <q-btn color="primary" icon="fas fa-exclamation-triangle" label="All Alerts" @click="all_alerts= true"/>
     <q-btn color="primary" icon="fas fa-book-open" label="Alerts History" @click="history= true"/>
    
    </div>
    <div id="floating-panel">
      <input id="hide-resolve" type="button" value="Hide Resolved Alerts" />
      <input id="show-resolve" type="button" value="Show Resolved Alerts" />
      <input id="delete-resolve" type="button" value="Delete Resolved Alerts" />
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

        <q-card-section v-for="alert in alerts " :key="alert.alertID" class="q-pt-none">
        <div class="text-h7">
         <ul>
           <li>
          <p>User: {{alert.userID}} <br />
            Alert: {{alert.text}} <br />
            Created: {{alert.created}}<br />
                Composed: {{alert.composed}}<br />
                latitude: {{alert.latitude}}<br />
                longitude: {{alert.longitude}}<br />
                Status: {{alert.status}}<br />
                </p>
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
import { MarkerClusterer } from "@googlemaps/markerclusterer";

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
    let markers = [];
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
    //let markers = [];
    var marker, i,count=0,a=3;
      
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
         // const status = {active: "true" };
         Object.defineProperty(i, "alertID", {value : count,
                       writable : true,
                       enumerable : true,
                       configurable : true});
          
          Object.defineProperty(i, "status", {value : "Active",
                       writable : true,
                       enumerable : true,
                       configurable : true});
          
          
          //console.log(i.alertID)
          alerts.value.push(i)
         // console.log(alerts.value[0].text)
           marker = new google.maps.Marker({
             position: new google.maps.LatLng(i.latitude,i.longitude),
             //visible:false,
             map: map
        });
        markers.push(marker);
        //console.log(markers[1]);
        console.log(i.latitude,i.longitude)

        google.maps.event.addListener(marker, 'click', (function(marker) {
             return function() {
                 infowindow.setContent("User : "+ i.userID+ 
                 "<br/> Created: " + i.created
                 +"<br/> Alert: "+i.text
                 +'<br/> Status: '+i.status
                 +"<br/>"
                 +'<center><button id="resolve">Resolve</button></center>');
                             
                 /*const someButton = document.getElementById('resolve');
                if (someButton) {
                  google.maps.listener.addDomListener(someButton, 'click',    
                  () => {
                          console.log("TEST");
                        })
                }*/
                 infowindow.open(map, marker);
                
             }
        })(marker));
        google.maps.event.addListener(infowindow, "domready", function () {
      document.getElementById("resolve").onclick= resolveAlert
  
    });
          count++
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
      
   document
    .getElementById("show-resolve")
    .addEventListener("click", showResolveAlerts);
  document
    .getElementById("hide-resolve")
    .addEventListener("click", hideResolveAlerts);
  document
    .getElementById("delete-resolve")
    .addEventListener("click", deleteResolveAlerts);   

  
 
}

 

function resolveAlert() {
  //console.log("TEST");
  alerts.value[3].status="Resolve";
 // console.log(alerts.value[3].status);
 /*for (var alert in alerts){
          this.markers[i]["visibility"] = false;
        }*/
}

function setMapOnAll(map) {
  for (let l = 0; l < markers.length; l++) {
    markers[l].setMap(map);
  }
}

function hideResolveAlerts() {
  let size=Object.keys(alerts).length
  for (let k=0;k<size;k++){
         if(alerts.value[k].status=="Resolve"){
            markers[k].setVisible(false);
         }
        }
  
  //visible:false,
  //markers[0].setVisible(false);
   //markers[1].setVisible(false);
    //markers[2].setVisible(false);
}
//showMarkers(markers);
function showResolveAlerts() {
  let size=Object.keys(alerts).length
  console.log(size)
  for (let m=0;m<size;m++){
         if(alerts.value[m].status=="Resolve"){
            markers[m].setVisible(true);
         }
        }
}
function deleteResolveAlerts() {
  let size=Object.keys(alerts).length
  console.log(size)
  for (let m=0;m<size;m++){
         if(alerts.value[m].status=="Resolve"){
            markers[m].setMap(null);
            markers.splice(m, 1);

         }
        }
}



 
/*onMounted(() => {
      loadAlerts();
    })*/
    return {
      mapData: ref(''),initMap,history: ref(false),all_alerts: ref(false),maximizedToggle: ref(false),alerts,deleteResolveAlerts,hideResolveAlerts,showResolveAlerts,setMapOnAll//loadAlerts
    
      
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
   #floating-panel {
  position: absolute;
  top: 50px;
  left: 35%;
  z-index: 5;
  
 
  text-align: center;
  font-family: "Roboto", "sans-serif";
  line-height: 30px;
  
}
</style>
