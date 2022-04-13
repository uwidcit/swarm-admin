<template>
  <q-page>
    <div id="wrapper">
    <div id="map" style=" height: 92.7vh; width: 100%"></div>
    <div id="over_map">
     <q-btn color="primary" icon="fas fa-exclamation-triangle" label="Active Alerts" @click="active_alerts= true"/>
     <q-btn color="primary" icon="fas fa-book-open" label="Resolve Alerts" @click="resolve_alerts= true"/>
    
    </div>
    <div id="floating-panel">
      <input id="hide-resolve" type="button" value="Hide Resolve Alerts" />
      <input id="show-resolve" type="button" value="Show Resolve Alerts" />
    </div>
  </div>
  <q-dialog
      v-model="active_alerts"
      transition-show="slide-up"
      transition-hide="rotate"
      seamless style="max-height: 50vh" class="scroll"
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
        <div v-if="alert.status=='Active'" class="text-h7">
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

    <q-dialog
      v-model="resolve_alerts"
      transition-show="slide-up"
      transition-hide="rotate"
      seamless style="max-height: 50vh" class="scroll"
    >
      <q-card class="bg-primary text-white" :style="dialogStyle2" >
        <q-bar v-touch-pan.mouse="onPan2">
          <q-icon name="fas fa-book-open"/>
          <div>Resolve Alerts</div>
          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip class="bg-white text-primary">Close</q-tooltip>
          </q-btn>
        </q-bar>

        <q-card-section>
          <div class="text-h6">Alerts</div>
        </q-card-section>

        <q-card-section v-for="alert in alerts " :key="alert.alertID" class="q-pt-none">
        <div v-if="alert.status=='Resolve'" class="text-h7">
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
import { MarkerClusterer } from "@googlemaps/markerclusterer";
import { useQuasar,Notify } from 'quasar'

export default defineComponent({
  name: "Map",
  data () {
    return {
      dialogVis: false,
      dialogPos: {
        x: 0,
        y: 0,
      },
      dialogPos2: {
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
  computed: {
    dialogStyle() {
      return {
        transform: `translate(${this.dialogPos.x}px, ${this.dialogPos.y}px)`
      }
    },
    dialogStyle2() {
      return {
        transform: `translate(${this.dialogPos2.x}px, ${this.dialogPos2.y}px)`
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
    onPan2(evt) {
      this.dialogPos2 = {
        x: this.dialogPos2.x + evt.delta.x,
        y: this.dialogPos2.y + evt.delta.y
      }
    },
    
  },
  setup() {
    const alerts = ref([])
    const $q = useQuasar()
    const data = ref(null)
    let markers = [];
    let a=0;
    
    function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {//Initialize map
         zoom: 8,
         center: new google.maps.LatLng(10.643423917461453,-61.39967380855142),
         mapTypeId: google.maps.MapTypeId.ROADMAP
    });


    var infowindow = new google.maps.InfoWindow;
    var marker, i,count=0;
      
      api.get('https://swarmnet-prod.herokuapp.com/alerts',{
  method: 'GET',
  
  headers: {
          Authorization:'JWT '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
          
        }
    })
    .then((response) => { 
        data.value = response.data //alert collected from api
        for (let i of data.value) { 
         Object.defineProperty(i, "alertID", {value : count, //add id to alert object
                       writable : true,
                       enumerable : true,
                       configurable : true});
          
          Object.defineProperty(i, "status", {value : "Active", //add status to alert object
                       writable : true,
                       enumerable : true,
                       configurable : true});
          
          
          alerts.value.push(i) //add alert to alert object array
           marker = new google.maps.Marker({
             position: new google.maps.LatLng(i.latitude,i.longitude),//Place marker with alert co ordinates
             icon:"https://i.ibb.co/JQDvsNm/marker.png",
             map: map,
             markerID: i.alertID
        });
            var circle = new google.maps.Circle({ //Add circle around markers
            map: map,
            radius: 500,    // metres
            fillColor: '#E8728F'
            });
            circle.bindTo('center', marker, 'position');
            marker.circle = circle;
            markers.push(marker);
        //console.log(markers[1]);

        google.maps.event.addListener(marker, 'mouseover', (function(marker) { //Add info window to each marker
             return function() {
                 infowindow.setContent("User : "+ i.userID+ 
                 "<br/> Created: " + i.created
                 +"<br/> Alert: "+i.text
                 +'<br/> Status: '+i.status
                 +"<br/>"
                 + "Click marker to resolve");
                             
                 infowindow.open(map, marker);
                
             }
        })(marker));
    

       google.maps.event.addDomListener(marker, 'click', function() {// listner for resolve alert function
       resolveAlert(i.alertID);
        });
        google.maps.event.addListener(marker, "rightclick", function () { // listner for set active function
               setActive(i.alertID);
            });
          count++
          a++
        }

      
new MarkerClusterer({ markers, map}); //Add marker cluster
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
}

 

 function resolveAlert(markAlert) {// Function to set alerts from active to resolve
    let size1=Object.keys(alerts.value).length
    var l
      for (l=0;l<size1;l++){
            if(alerts.value[l].alertID==markAlert){
                alerts.value[l].status="Resolve";//set alert to resolve
              break
            }
            }
      $q.notify({// alert to show it was successful
              message: 'Alert has been Resolved',
              type: 'positive',
              position: 'top',
              icon: 'check',
              color:'green',
              caption: 'Right click marker to set Alert Active',
            })
}
 function setActive(markAlert) {// Function to set alerts from resolve to active
    let size1=Object.keys(alerts.value).length
      for (let l=0;l<size1;l++){
            if(alerts.value[l].alertID==markAlert){
                alerts.value[l].status="Active";
            }
            }
            $q.notify({//alert to show it was successful
              message: 'Alert has been set to Active',
              type: 'positive',
              position: 'bottom',
              icon: 'check',
              color:'green',
              caption: 'Click marker to resolve Alert',
            })
    }

function hideResolveAlerts() { //Function to hide Resolve alerts markers
  let size2=Object.keys(alerts.value).length
  for (let k=0;k<size2;k++){
         if(alerts.value[k].status=="Resolve"){
            markers[k].setVisible(false);//hide marker
            markers[k].circle.setOptions({// hide circle
              fillOpacity: 0,
              strokeOpacity: 0
            }); 
         }
        }
}

function showResolveAlerts() {//Function to display resolve alerts markers
  let size=Object.keys(alerts.value).length
  for (let m=0;m<size;m++){
         if(alerts.value[m].status=="Resolve"){
            markers[m].setVisible(true);//show markers
            markers[m].circle.setOptions({//show circle
              fillOpacity: 0.35,
              strokeOpacity: 1
            });
         }
        }
}
    return {
      mapData: ref(''),initMap,resolve_alerts: ref(false),active_alerts: ref(false),alerts,setActive,hideResolveAlerts,showResolveAlerts
    
      
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
