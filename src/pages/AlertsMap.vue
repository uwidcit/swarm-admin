<template>
  <q-page>
    <div id="wrapper">
    <div id="map" style=" height: 92.7vh; width: 100%"></div>
    <div id="over_map">


<!-- Slide In box will be hidden until toggled open -->
<div class="slidein overflow-y: scroll" >
      <h6>Emergency Report</h6>
      <p id="text"></p>
      <!--<p id="tags" class="row rounded-borders"></p>-->
      <h6>Reported by</h6>
      <p id="user"></p> 
      <h6>Location</h6>
      <div class="q-gutter-sm row no-wrap">
      <p >Latitude</p> 
      <p >Longitude</p> 
      </div>
     <div class="q-gutter-sm row no-wrap">
      <p id="lat" ></p> 
      <p id="lng"></p> 
      </div>
       <q-btn id="resolve" class="butn" color="blue" label="Mark as Resolve" @click="r_alert = true"  />
      <q-btn id="false" class="butn" outline style="color: #2D86BC" label="Mark as False" @click="f_alert = true"/>
        <button class="close-btn"> X </button>
    </div>

    </div>
    <div id="floating-panel">
     <!-- <input id="hide-resolve" type="button" value="Hide Resolved Alerts" />
      <input id="show-resolve" type="button" value="Show Resolved Alerts" />-->
       
    </div>
  </div>
    
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
      openBar: false,
      thumbStyle: {
        right: '4px',
        borderRadius: '5px',
        backgroundColor: '#027be3',
        width: '5px',
        opacity: 0.75
      },

      barStyle: {
        right: '2px',
        borderRadius: '9px',
        backgroundColor: '#027be3',
        width: '9px',
        opacity: 0.2
      },
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
    let url= process.env.COMMON_API_URL+"/alert"
    let urll='https://swarmnet-prod.herokuapp.com/alerts'
      api.get(url,{
  method: 'GET',
  
  headers: {
          Authorization:'Bearer '+ localStorage.getItem('token'), 
          'Access-Control-Allow-Origin': '*'
        }
    })
    .then((response) => { 
        data.value = response.data //alert collected from api
       // console.log(data.value.alerts)
        for (let i of data.value.alerts) { 
          if((i.is_false==false) && (i.is_resolved==false)){
    
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
        /*google.maps.event.addListener(marker, 'mouseover', (function(marker) { //Add info window to each marker
             return function() {
                 infowindow.setContent("User : "+ i.user.first_name+ 
                 "<br/> Created: " + i.created
                 +"<br/> Alert: "+i.text
                 +"<br/>"
                );
                             
                 infowindow.open(map, marker);
                
             }
        })(marker));*/
    
       google.maps.event.addListener(marker, 'click', function() {// Listener for resolve alert function
       //openBar=true;
       //console.log("Hello")
      document.getElementById("text").innerHTML = i.text;
      //document.getElementById("tags").innerHTML = "Eartquake"+" "+"Landslide";
      document.getElementById("user").innerHTML = i.user.first_name+" "+ i.user.last_name;
      document.getElementById("lat").innerHTML = i.latitude;
      document.getElementById("lng").innerHTML = i.longitude;
       
       let slidein = document.querySelector('.slidein');
       slidein.classList.toggle('open');
       
       document.getElementById("resolve")
      .addEventListener("click", function(){
        resolveAlert(i.id);
      });
      
      document.getElementById("false")
         .addEventListener("click", function(){
        falseAlert(i.id);
      });
       let closeBtn = document.querySelector('.close-btn');
       closeBtn.addEventListener('click', function() {
        slidein.classList.toggle('open');
      });
      
        
       //document.getElementById("testing").innerHTML = "Peace";
        });
          count++
          a++
        }// end of if statement
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
    
}


    function falseAlert(a_id){
      api.put( process.env.ADMIN_API_URL+"/alert/falsify/"+a_id,
                {
                 
                },
                {
                headers: {
                  Authorization:'Bearer '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*',
                  'Content-Type': 'application/json'
                }
              })
                  .then((response) => { 
                    $q.notify({// alert to show alert change was successful
                    message: 'Alert has been set to False',
                    type: 'positive',
                    position: 'top',
                    icon: 'check',
                    color:'orange',
                    caption: 'Check the False Map',
                  })       
                  })
                  .catch(() => {
                      $q.notify({
                      color: 'negative',
                      position: 'top',
                      message: 'Loading failed',
                      icon: 'report_problem'
                      })
                  })
    }

     function resolveAlert(a_id){
      //console.log(a_id,"Hello there")
      api.put( process.env.ADMIN_API_URL+"/alert/resolve/"+a_id,
                {
                 
                },
                {
                headers: {
                  Authorization:'Bearer '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*',
                  'Content-Type': 'application/json'
                }
              })
                  .then((response) => { 
                     $q.notify({// alert to show alert change was successful
                    message: 'Alert has been set to Resolve',
                    type: 'positive',
                    position: 'top',
                    icon: 'check',
                    color:'orange',
                    caption: 'Check the Resolve Map',
                  })   
                  })
                  .catch(() => {
                      $q.notify({
                      color: 'negative',
                      position: 'top',
                      message: 'Loading failed',
                      icon: 'report_problem'
                      })
                  })
    }

    return {
      mapData: ref(''),initMap,resolve_alerts: ref(false),active_alerts: ref(false),alerts,falseAlert,resolveAlert,r_alert: ref(false),
      f_alert: ref(false),
    
      
    }
  },
  mounted() {
    this.initMap();
   
  },
})
</script>
<style scoped>
   #wrapper { position: relative; }
   #over_map { position: absolute; top: 10px; right: 250px; z-index: 99; }
   #floating-panel {
  position: absolute;
  top: 50px;
  left: 35%;
  z-index: 5;
  
 
  text-align: center;
  font-family: "Roboto", "sans-serif";
  line-height: 30px;
  
  
}
/* Make slide in box hidden off screen with fixed positioning 100% to the right */
.slidein {
  max-width: 350px;
  padding: 2em 3em; 
  position: fixed; 
  z-index: 100;
  top: 13%;
  right: -100%;
  background: #FFFFFF;
  color: #393D3D;
  height: 100%;
  box-shadow: 1px 1px 10px rgba(0,0,0,.5);
  transition: all .5s ease-in-out; 
}

/* Set positioning back to 0 when toggled opened */
.open {
  right: 0; 
}
h6{
  margin: 1px;
}
.butn{
    height:50px;
    width:200px;
    margin: 20px;
}

/* add a close button in case toggle button is hidden on smaller screens */
.close-btn {
  border: none; 
  font-weight: bold; 
  font-size: 2em; 
  background: transparent; 
  position: absolute; 
  top: 0;
  right: 0;
  padding: .5em;
}

/* General styles unrelated to slide in */



</style>