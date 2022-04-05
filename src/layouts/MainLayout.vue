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
        <q-btn round color="primary" icon="fas fa-pen-nib" @click="edit=true" dense/>
        <q-btn round color="primary" icon="fas fa-plus"  @click="create= true" dense/>
        <q-btn round color="primary" icon="fas fa-trash" @click="remove=true" dense/>
        <q-space/>
    
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
        <q-item to="/home" active-class="q-item-no-link-highlighting v-ripple">
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

    <q-dialog v-model="edit">
      <q-card style="width: 600px; height: 400px; background-color: powderblue;">
        <q-card-section>
          <div class="text-h6">Edit Topic</div>
        </q-card-section>
        <q-card-actions>
          <q-btn-dropdown color="primary" label="TOPICS">
            <q-list v-for="topic in tops" :key="topic.id">
              <q-item clickable v-close-popup @click="ptabtext= topic.text , ptopid= topic.id">
                <q-item-section>
                  <q-item-label>{{topic.text}}</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-btn-dropdown>
        </q-card-actions>

        <q-card-section>
          <div class="text-h6">TOPIC SELECTED: {{ptabtext}} </div>
        </q-card-section>
        <q-separator />
       
        <q-card-actions align="right">
          <q-btn flat label="Discard" color="primary" @click="ph = '', lev=''" v-close-popup />
          <q-btn flat label="Edit" color="primary" @click="ph = '', lev=''" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>

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

     <q-dialog v-model="remove">
      <q-card style="width: 350px; height: 350px; background-color: powderblue;">
        <q-card-section>
          <div class="text-h6">Delete Topic</div>
        </q-card-section>
        
        <q-card-actions>
          <q-btn-dropdown color="primary" label="TOPICS">
            <q-list v-for="topic in tops" :key="topic.id">
              <q-item clickable v-close-popup @click="ptabtext= topic.text , ptopid= topic.id">
                <q-item-section>
                  <q-item-label>{{topic.text}}</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-btn-dropdown>
        </q-card-actions>

        <q-card-section>
          <div class="text-h6">TOPIC SELECTED: {{ptabtext}} </div>
        </q-card-section>
        <q-separator />
        
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" @click="ph = '', lev=''" v-close-popup />
          <q-btn flat label="Delete Topic" color="primary" @click="deleteTopic(ptopid)" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>


    <q-dialog v-model="confirm">
      <q-card style="width: 250px; height: 250px; background-color: powderblue;">
        <q-card-section>
          <div class="text-h6">ARE YOU SURE YOU WANT TO DELETE THIS TOPIC?</div>
        </q-card-section>
        
        <q-card-actions align="right">
          <q-btn flat label="Yes" color="primary"  @click="ph = '', lev=''" v-close-popup />
          <q-btn flat label="No" color="primary" @click="ph = '', lev=''" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>

      <q-page-container class="bg-grey-2">
      <router-view />
    </q-page-container>

  </q-layout>
</template>


<script>

import PostBoard from 'components/PostBoard.vue';
import { defineComponent, ref, provide  } from 'vue'
import { useQuasar } from 'quasar'
import { onMounted, onUpdated} from 'vue'
import { api } from 'boot/axios'
import { useRouter, useRoute } from 'vue-router'
export default defineComponent({

  name: 'MainLayout',
  //props:['lorem'],
  components: {
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
    const $q = useQuasar()
    const tops = ref([])
    const data = ref(null)
    const tagText = ref('0')
    const ptabtext = ref('')
    //const confirm = ref(false)


     function loadData () {
       tops.value.splice(0)
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
       console.log(newTopic , topLevel)

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
                loadData ();
                $q.notify({
                  color: 'positive',
                  type: 'positive',
                  position: 'bottom',
                  message: 'NEW TOPIC CREATED',
                })
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

/*edit a topic on the postboard
function editTopic(topicId){
  console.log(topicId)
  api.put("https://swarmnet-prod.herokuapp.com/topics/:{topicId}",{
              headers: {
                  Authorization:'JWT '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*'   
                }
  }
  )
}
/*


/*to delete a topic from the postboard*/ 
function deleteTopic(postID){
       console.log(postID)

       api.delete(`https://swarmnet-prod.herokuapp.com/topics/${postID}`,
              {
                headers: {
                  Authorization:'JWT '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*'   
                }
              }
              )
            .then((response) => {
              console.log(response.status)
              if(response.status == 201 || response.status == 200){
                console.log("entered")
              /*  confirm = false;  set this to false here or in the dialog to close after deleting*/
                loadData()
                $q.notify({
                  color: 'positive',
                  type: 'positive',
                  position: 'bottom',
                  message: 'TOPIC DELETED',
                })
                
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
    provide('message', tagText)
 
    return { 
      ptabtext,
      ptopid: ref(''),
      tagText,
      addTopic,
      tops,
      loadData,
      deleteTopic,
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
        remove:ref(false),
        confirm: ref(false),
        edit: ref(false), 
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