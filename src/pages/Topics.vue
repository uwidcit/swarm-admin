<template>
        <q-page>
            <q-page-container style="padding-top: 50px;padding-left: 100px;">
              <div class="row">
              <div class="col-6"> 
                <q-btn class ="btnStyle" @click="prompt = true" label="Create Topic"> 
                </q-btn>
              </div>
              
              <div class="col-6">
                <q-input 
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search Topics"
                  style="width: 350px; padding-bottom: 32px"
                 
                  > </q-input> 
                </div>
      </div>
                <q-table  :rows ="topics" :columns="columns" :filter="filter" > 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props">


                    <q-td key ="topic" :props="props"> 
                      {{ props.row.topic}}
                    </q-td>
                    <q-td key ="level" :props="props"> 
                      {{ props.row.level}}
                    </q-td>
                      <q-td key ="createdby" :props="props"> 
                        {{ props.row.createdby}}
                      </q-td>

                    <q-td key ="createddate" :props="props"> 
                      {{ props.row.createddate}}
                    </q-td>


                    <q-td key ="seeAllPostByTopic" :props="props"> 
                      <q-btn :label="'View Post('+ props.row.seeAllPostByTopic + ')'"> </q-btn>
                    </q-td>
                  
                  <q-td key ="moreOptions" :props="props"> 
                      <q-btn-dropdown dropdown-icon="fas fa-ellipsis" flat round> 
                        <q-list>
                         <q-item clickable v-close-popup @click="promptEdit = true, current_row= props.row" >
                          <q-item-section>
                            <q-item-label>Edit</q-item-label>
                          </q-item-section>
                         </q-item>

                          <q-item clickable v-close-popup @click="promptDelete = true , current_row= props.row ">
                          <q-item-section>
                            <q-item-label>Delete</q-item-label>
                          </q-item-section>
                         </q-item>
                       </q-list>
                      </q-btn-dropdown>
                       
                  </q-td>

                  </q-tr>       
                  </template>
                  
                </q-table>

                <q-dialog v-model="prompt" persistent>
                  <q-card style="min-width:418px; min-height: 171px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "textStyle"> Create Topic</p>
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                     <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent"> 
                            <!-- <q-input outlined style="max-width : 90%" placeholder="Add topic..." v-model="text" counter maxlength="60" autogrow   :dense="dense" />
                            <q-select outlined style="max-width : 70%" v-model="topiclevel" stack-label label="Level" fill-input :options="levels"/>  -->
                            <q-select outlined style="max-width : 70%" v-model="topiclevel" stack-label label="Level" fill-input :options="levels"></q-select>
                            <q-input rounded outline style="max-width : 90%" placeholder="Add topic..." v-model="text" counter maxlength="60" autogrow  :dense="dense"></q-input>
                                                        
                        </div>
                     </div>
                     
                      <template v-slot:after>
                      
                      </template>
                      
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" @click="createTopic(text, topiclevel)" v-close-popup />
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                       
                      </q-card-actions>
                  </q-card>
                </q-dialog>
            </q-page-container>

          <q-dialog v-model="promptEdit" full-widthpersistent @show="text=current_row.topic">
                  <q-card style="min-width:418px; min-height: 171px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "textStyle"> Edit Topic </p>
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                      <q-input rounded outline style="padding:5% 15%"  v-model="text" counter maxlength="60" autogrow  :dense="dense">
                      <q-select outlined style="max-width : 70%" v-model="topiclevel" stack-label label="Level" fill-input :options="levels"/>
                      </q-input>
                      <template v-slot:after>
                      
                      </template>
                      <!-- </q-input> -->
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" @click = "editTopic(text, topiclevel, current_row)" v-close-popup />
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                      </q-card-actions>
                  </q-card>
                </q-dialog>
              

               <q-dialog v-model="promptDelete" full-widthpersistent>
                  <q-card style="min-width:418px; min-height: 171px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "textStyle"> Delete {{ current_row.topic }} </p>
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                      <div class= "text-p q-px-xl q-pt-lg q-pb-md"> 
                        Are you sure you want to delete this Topic 
                    </div>
                      <template v-slot:after>
                      
                      </template>
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Confirm" @click = "deleteTopic(current_row)" v-close-popup/>
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                      </q-card-actions>
                  </q-card>
                </q-dialog>


        </q-page>
</template>

<script>
import {defineComponent, ref, onMounted} from 'vue'
import { formatDistance} from 'date-fns'
import { api } from 'boot/axios'
import Quasar from 'quasar'
import UserProfile from './UserProfile.vue'



export default defineComponent({
  name: "Topics",

  props: ['data'],
  
  setup(props) {
    
    const value = Date.now()
    
    const text = ref('')
    const topics = ref([])
    const data = ref(null)
    const columns = [
    {
        name:'topic',
        label:'Topic',
        field:'topic',
        align: 'left',
        sortable:true,
        
    }, {
        name:'level',
        label:'Level',
        field:'level',
        align: 'left',
        sortable:true,
    }, {
        name:'createdby',
        label:'Last Edited By',
        field:'createdby',
        align: 'left',
        sortable:true,
        
    } ,
       {
        name:'createddate',
        label:'Date Last Edited',
        field:'createddate',
        align: 'left',
        sortable:true,
        
       }, 
       {
        name:'seeAllPostByTopic',
        label:'',
        field:'seeAllPostByTopic',
        align: 'left',
       }, 
       {
        name:'moreOptions',
        label:'',
        field:'moreOptions',
        align: 'left',
       }]

    const rows =[{
        id:1,
        topic:'Earthquakes',
        createdby:'Kwasi Edwards',
        createddate:'07.22.22',
        seeAllPostByTopic:'100',

    }, {
        id:2,
        topic:'Flood',
        createdby:'Kwasi Edwards',
        createddate:'07.22.22',
        seeAllPostByTopic:'12',
    }]

    function getTopics(){
        let url = process.env.BASE_URL+"/api/topics"
        api.get(url, {
          method: 'GET',
          headers: {
          'Access-Control-Allow-Origin': '*'
        }
        }).then((response) => {
            data.value =  response.data.topics
           // console.log(data.value)
            for(let i of data.value){
              topics.value.push({ id: i.id,
                topic: i.text,
                level: i.level,
                createdby:i.editor,
                createddate:i.edited,
                seeAllPostByTopic:i.post_count, //getNumPostsByTopic
            })
        }})
    }

  function loadData(current_row){
    text.value = current_row.topic
  }

    function createTopic(newTopic, topiclevel){
    //  console.log(topiclevel)
      var toplevel= 0
      if (topiclevel == "Broadcast"){
        toplevel= 1
      }
      
      let url = process.env.BASE_URL+"/api/admin/topics"
      api.post(url, {
        text:newTopic,
        level: toplevel
      }, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        data.value = response.data.topic
        //console.log(data.value)
        topics.value.push({
                id: data.value.id,
                topic: data.value.text,
                level: data.value.level,
                createdby: data.value.editor,
                createddate: data.value.edited,
                seeAllPostByTopic:data.value.post_count,
        })
      })
    }

    function editTopic(newTopic, topiclevel,currentTopic){
      var toplevel= 0
      if (topiclevel == "Broadcast"){
        toplevel= 1
      }

      let url = process.env.BASE_URL+"/api/admin/topics"
      api.put(url, 
      {
        // data: {
          text: newTopic,
          level: toplevel,
          topic_id: currentTopic.id
        // }
      }, 
        {headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        //console.log(response)
        topics.value = ([])
        getTopics()
      })
    }

    function deleteTopic(currentTopic){
      // console.log(currentTopic.id)
      let url = process.env.BASE_URL+"/api/admin/topics"
      api.delete(url, 
      {
        data: {
          topic_id: currentTopic.id
        },
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
        }
      }).then((response) => {
       // console.log(response)
        topics.value = ([])
        getTopics()
      })
    }

    function datePassed() {
    //  console.log(Date.parse(props.data.created))
    //  console.log(formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true }))
        let returnDate = new Date(Date.parse(props.data.created))
      return  returnDate.toLocaleString()
       // return formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true })
    }
  onMounted(() => {
    getTopics();
  })
    return{
      datePassed,
      data,
      prompt: ref(false),
      filter: ref(''),
      promptEdit: ref(false),
      promptDelete: ref(false),
      current_row:ref(''),
      search:ref(''),
      getTopics,
      editTopic,
      createTopic,
      deleteTopic,
      topics,
      columns,
      rows,
      text,
      levels: ['Topic', 'Broadcast']
    }
  }
})
</script>

<style scoped>
.btnStyle{
width: 175px;
height: 24px;
background: var(--unnamed-color-e29862) 0% 0% no-repeat padding-box;
background: #E29862 0% 0% no-repeat padding-box;
border-radius: 10px;
opacity: 1;

color: var(--unnamed-color-f8f8f8);
text-align: left;
font: normal normal 100 15px/20px Poppins;
letter-spacing: 0px;
color: #F8F8F8;
}

.textStyle{
  color: var(--unnamed-color-3e3e3e);
  text-align: left;
  padding: 5%;
  font: normal normal bold 30px/46px Poppins;
  letter-spacing: 0px;
  color: #3E3E3E;
  opacity: 1
}

.btnStyle2{
  width: 185px;
  height: 24px;
  border: 3px solid var(--unnamed-color-e29862);
  border: 3px solid #E29862;
  color: var(--unnamed-color-e29862);
  color: #E29862;
  border-radius: 10px;
  opacity: 1;
  text-align: left;
  font: normal normal 100 15px/20px Poppins;
  letter-spacing: 0px;
}
</style>