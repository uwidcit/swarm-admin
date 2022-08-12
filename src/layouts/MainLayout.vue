<template>
  <q-layout view="lHh Lpr lFf" class="shadow-2 rounded-borders">
    <q-header class="headerStyle text-black" style=" height: 100px;" elevated >
      <div class= "q-pa-md q-ml-xl q-gutter-y-sm">
      <q-toolbar>
         <q-toolbar-title>Welcome Back Admin </q-toolbar-title>
         <q-btn padding="xl" color="blue" icon="far fa-comment" to="/Chat" clickable :label="'Chat'" flat unelevated dense>
                <q-tooltip class="primary" :offset="[10, 10]">
                   Chat
                </q-tooltip>
            </q-btn>

          <q-btn padding="xl" color="orange" icon="far fa-bell" @click="edit=true" :label= "`Emergencies`" flat unelevated dense>
          <q-tooltip class="primary" :offset="[10, 10]">
            Emergencies
          </q-tooltip>
            </q-btn>

      <!--<div class="q-gutter-lg">
          <div class="">
            <div class="col">
            
          </div>
            <div class="col">
        
       </div>
       </div>-->
        <!-- <q-space/>
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
        <q-btn round color="primary" icon="fas fa-pen-nib" @click="edit=true" dense>
          <q-tooltip class="primary" :offset="[10, 10]">
          Edit Topic
        </q-tooltip>
          </q-btn>
        <q-btn round color="primary" icon="fas fa-plus"  @click="create= true" dense>
          <q-tooltip class="primary" :offset="[10, 10]">
          Add Topic
        </q-tooltip>
          </q-btn>
        <q-btn round color="primary" icon="fas fa-trash" @click="remove=true" dense>
          <q-tooltip class="primary" :offset="[10, 10]">
          Delete Topic
        </q-tooltip>
          </q-btn>
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
          </q-btn>>
        </div>-->
      </q-toolbar>
      </div>
    </q-header>
  
    <q-drawer
      v-model="drawer"
      show-if-above
      elevated
      class="text-black"
      @mouseover="miniState = false"
      @mouseout="miniState = true"
      :width="300"
      :breakpoint="500"
      style =" background: #FFFFFF 0% 0% no-repeat padding-box; box-shadow: 0px 3px 6px #00000029;"
    >
    <q-list class="bg-white">
        <div class= "row q-col-gutter-xs">
          <div class= "col">
          <q-img  class= "header-img" src="https://raw.githubusercontent.com/TheGreatDevourer/swarm-client-staging/main/src/logo.png"></q-img>
          </div>
        </div>
         <q-item to="/home" class="menuText" style="justify-content:left;" active-class="q-item-no-link-highlighting">
          <!--<q-item-section>
          <span v-if="$q.platform.is.desktop" ><q-btn
          flat
          dense
          round
          aria-label="Menu"
        /> </span> 
          </q-item-section>-->
          <q-item-section avatar>
            <q-icon style = "color:#457B9D;" name="fas fa-cube"></q-icon>
            </q-item-section>
            <q-item-section>
            <q-item-label class="menuText">Dashboard</q-item-label>
          </q-item-section>
        </q-item>

        <q-item to="/Post"  class="menuText"  active-class="q-item-no-link-highlighting v-ripple">
          <q-item-section avatar>
            <q-icon style = "color:#457B9D" name="fa-solid fa-file-lines"/>
          </q-item-section>
          <q-item-section>
            <q-item-label >Post</q-item-label>
          </q-item-section>
        </q-item>

        <q-expansion-item  style = "color:#457B9D" icon="fa-solid fa-exclamation" label="Alerts"  class="menuText" active-class="q-item-no-link-highlighting">
          <q-item to="/Active" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>

              <q-item-section no-wrap>
                <q-item-label class="menuText" >Active</q-item-label>
              </q-item-section>
            </q-item>

        <q-item to="/Resolve" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >Resolve</q-item-label>
              </q-item-section>
        </q-item>

         <q-item to="/False" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >False</q-item-label>
              </q-item-section>
        </q-item>
         
        </q-expansion-item>

        <q-item to="/Topics" class="menuText"  active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon style = "color:#457B9D" name="fa-solid fa-certificate"/>
          </q-item-section>
          <q-item-section>
            <q-item-label >Topics</q-item-label>
          </q-item-section>
        </q-item>

        <q-item to="/Broadcast"  class="menuText" active-class="q-item-no-link-highlighting" >
          <q-item-section avatar>
            <q-icon style = "color:#457B9D" name="fa-solid fa-podcast"/>
          </q-item-section>
          <q-item-section>
            <q-item-label class="menuText">Broadcast</q-item-label>
          </q-item-section>
        </q-item>

         <q-expansion-item  style = "color:#457B9D" icon="fa-solid fa-chart-area" label="Reports and Analytics"  class="menuText" active-class="q-item-no-link-highlighting">
          <q-item to="/UserAnalytics" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>

              <q-item-section no-wrap>
                <q-item-label class="menuText" >Active Users</q-item-label>
              </q-item-section>
            </q-item>

        <q-item to="/PostAnalytics" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >Post Activity</q-item-label>
              </q-item-section>
        </q-item>

         <q-item to="/EmergenciesAnalytics" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >Emergencies</q-item-label>
              </q-item-section>
        </q-item>

         <q-item to="/BroadcastAnalytics" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >Broadcast</q-item-label>
              </q-item-section>
        </q-item>
         
        </q-expansion-item>

        <q-expansion-item  style = "color:#457B9D" icon="fa-solid fa-circle-user" label="Users"  class="menuText" active-class="q-item-no-link-highlighting">
          <q-item to="/Users/AdminUsers" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>

              <q-item-section no-wrap>
                <q-item-label class="menuText" >Administrators</q-item-label>
              </q-item-section>
            </q-item>

        <q-item to="/Users/ExternalUsers" class="menuText" active-class="q-item-no-link-highlighting">
              <q-item-section avatar/>
              <q-item-section no-wrap>
                <q-item-label class="menuText" >External Users</q-item-label>
              </q-item-section>
        </q-item>
         
        </q-expansion-item>

        <q-item to="/DisasterReliefCenters"  class="menuText" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon style = "color:#457B9D" name="fa-solid fa-hand-holding-medical"/>
          </q-item-section>
          <q-item-section>
            <q-item-label class="menuText">Disaster Relief Center</q-item-label>
          </q-item-section>
        </q-item>

        <!-- <q-item to="/Note" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="fas fa-bell"/>
          </q-item-section>
          <q-item-section>
            <q-item-label>Notifications</q-item-label>
          </q-item-section>
        </q-item>-->
      
       
      </q-list>
    </q-drawer>

   <!-- <q-dialog v-model="edit">
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

        <q-card-section>
          <q-input rounded outlined v-model="text" placeholder="Enter edited topic" />
        </q-card-section>
       
        <q-card-actions align="right">
          <q-btn flat label="Discard" color="primary" @click="text=''" v-close-popup />
          <q-btn flat label="Edit" color="primary" @click="editTopic(ptopid, text), text=''" v-close-popup />
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
    </q-dialog> -->

    <q-page-container class="background">
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
    const text = ref('')
    //const confirm = ref(false)


     function loadData () {//get Topics from api
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
     function addTopic(newTopic, topLevel){//add topics 
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

/*edit a topic on the postboard */
function editTopic(topicId, text){
  console.log(topicId , text)
   api.put(`https://swarmnet-prod.herokuapp.com/topics/${topicId}`,
                {
                  text: text,
                  "level": 1
                },
                {
                headers: {
                  Authorization:'JWT '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*',
                  'Content-Type': 'application/json'
                }
              })
                  .then((response) => { 
                    console.log(response.data)
                    loadData () /* add check to ensure it only reloads if successul */

                          
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
      drawer:ref(false),
      ptopid: ref(0),
      tagText,
      addTopic,
      tops,
      loadData,
      deleteTopic,
      editTopic,
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
        text,


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

<style scoped>
.background{
  background-color: #F8F8F8;
  background: #F8F8F8 0% 0% no-repeat padding-box;
  opacity: 1;
}

.header-img{
  top: 5px;
  left: 60px;
  width: 169px;
  height: 114px;
  margin-bottom: 30px;
}

.b-items{
  top: 10px; 
  width: 209px; 
  height: 122px;

  max-width:209px;
  max-height: 122px;

}
  
.headerStyle{
  background: #FFFFFF 0% 0% no-repeat padding-box;
  box-shadow: 0px 3px 6px #00000029;
  border-radius: 0px 10px 10px 0px;
  opacity: 1;
}
.menuText {
  text-align: left;
  font: normal normal normal 20px/30px Poppins;
  letter-spacing: 0px;
  color: #707070;
  opacity: 1;
  margin-bottom: 10px;
}
</style>