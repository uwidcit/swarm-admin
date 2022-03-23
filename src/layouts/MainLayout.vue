<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated >
      <q-toolbar class="glossy">
      <div class="q-gutter-sm row items-center no-wrap ">
        <q-space/>
          <div  style="max-width: 1000px">
              <q-tabs
              v-model="tab"
              inline-label
              outside-arrows
              mobile-arrows
              class="text-white shadow-2"
              dense
              indicator-color="purple"
              active-color="white"
            >
              <q-tab name="all" label="ALL TOPICS" @click="tagText='0'" />
              <q-tab v-for="topic in tops" :key="topic.id" :label="topic.text" @click="tagText=topic.id"/>
                
            </q-tabs>
            
          </div>
        <q-btn round color="primary" icon="fas fa-plus"  @click="create= true" dense/>
        <q-space/>
        <q-btn round color="primary" icon="fas fa-trash"  @click="triggerPositive()" dense/>
    
     </div>
     <div class="board">
 </div>
    
     <q-space/>

      <div class="q-gutter-sm row items-center no-wrap ">
          <q-btn round flat>
            <q-avatar size="26px">
              <img src="https://cdn.quasar.dev/img/boy-avatar.png">
            </q-avatar>
          </q-btn>
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      class="bg-primary text-white"
      :mini="miniState"
      @mouseover="miniState = false"
      @mouseout="miniState = true"
      :width="200"
      :breakpoint="500"
    >
    <q-list>
         <q-item to="/" active-class="q-item-no-link-highlighting" >
          <q-item-section avatar>
          <span v-if="$q.platform.is.desktop" ><q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
        /> </span> 
          </q-item-section>
          <q-item-section>
            <q-item-label><strong>SWARMNET</strong></q-item-label>
          </q-item-section>
        </q-item>

        <q-separator color="orange" inset />
        <q-item to="/" active-class="q-item-no-link-highlighting v-ripple">
          <q-item-section avatar>
            <q-icon name="fas fa-home"/>
          </q-item-section>
          <q-item-section>
            <q-item-label>Post Board</q-item-label>
          </q-item-section>
        </q-item>

        <q-item to="/Alerts" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="fas fa-exclamation-triangle"/>
          </q-item-section>
          <q-item-section>
            <q-item-label>Alerts</q-item-label>
          </q-item-section>
        </q-item>

         <q-item to="/Note" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="fas fa-bell"/>
          </q-item-section>
          <q-item-section>
            <q-item-label>Notifications</q-item-label>
          </q-item-section>
        </q-item>
      
        <q-item to="/Charts" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="fas fa-chart-line"/>
          </q-item-section>
          <q-item-section>
            <q-item-label>Post Analytics</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container class="bg-grey-2">
      <!--<post-board :tabText="tagText" /> -->
      <router-view />
    </q-page-container>

    <q-dialog v-model="create">
      <q-card style="width: 600px; height: 400px; background-color: powderblue;">
        <q-card-section>
          <div class="text-h6">New Topic</div>
        </q-card-section>
        
        <q-card-section>
          <q-input filled  v-model="ph" placeholder="Enter Title of Topic"  />
        </q-card-section>

        <q-card-section>
          <div class="text-h6">Topic Level</div>
        </q-card-section>
        
        <q-card-section>
          <q-input filled  v-model="lev" placeholder="Enter Level of Topic"  />
        </q-card-section>
      
        <q-card-actions align="right">
          <q-btn flat label="Discard" color="primary" @click="ph = '', lev=''" v-close-popup />
          <q-btn flat label="Post" color="primary" v-close-popup @click="addTopic(ph,lev), ph = '', lev='';"/>
        </q-card-actions>
      </q-card>
    </q-dialog>

  </q-layout>
</template>


<script>
import EssentialLink from 'components/EssentialLink.vue'
import PostBoard from 'components/PostBoard.vue';
import { defineComponent, ref } from 'vue'
import { useQuasar } from 'quasar'
import { onMounted, onUpdated} from 'vue'
import { api } from 'boot/axios'
export default defineComponent({

  name: 'MainLayout',
  //props:['lorem'],
  components: {
    EssentialLink,
    PostBoard
  },
  data () {
    return {
      text: '',
      tag: '',
      dialogVis: false,
      dialogPos: {
        x: 0,
        y: 0,
      },
      search: ''
    }
  },
  
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
  setup () {
    const leftDrawerOpen = ref(false)
    const lorem = ref('')
    const $q = useQuasar()
    const tops = ref([])
    const data = ref(null)


     function loadData () {
       tops.value.splice[0]
    api.get('https://swarmnet-prod.herokuapp.com/topics',{
  method: 'GET',
  
  headers: {
          'Access-Control-Allow-Origin': '*'
        }
    })
      .then((response) => { 
        data.value = response.data
        for (let i of data.value) { 
          tops.value.push(i)
        }
        console.log(tops.value)
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
     function addTopic(newTopic, topLevel){
       console.log(newTopic)
       api.post("https://swarmnet-prod.herokuapp.com/topics",{        
              text: newTopic,
              level: parseInt(topLevel),
              },
              {
                headers: {
                  Authorization:'JWT '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*'   
                }
              }
              )
            .then((response) => {
              console.log(response.status)
              if(response.status == 201){
                triggerPositive ();
            }
          }
        )
            .catch(() => {
              $q.notify({
                color: 'negative',
                position: 'top',
                message: 'Loading failed',
                icon: 'report_problem'
              })
            })
     }
  onMounted(() => {
      loadData();
    })
 
    return {
      tagText: '0',
      addTopic,
      tops,
      loadData,
      leftDrawerOpen: ref(false),
      /*toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },*/
      
      miniState: ref(true),
      topic_tab:ref('all'),
      maximizedToggle: ref(false),
      dense: ref(false),
        topic_tab:ref('all'),
        create: ref(false),
        ph: ref(''),
        lev: ref(''),


        triggerPositive(){
            $q.notify({
              type: 'positive',
              message: 'TOPIC DELETED'
            })
            // simulate delay
            setTimeout(() => {
              notif({
                type: 'positive',
                message: 'Found the results that you were looking for',
                timeout: 1000
              })
            }, 4000)
          },
    }
  }
})
</script>