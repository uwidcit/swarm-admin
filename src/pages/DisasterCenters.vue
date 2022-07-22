<template>
        <q-page>
            <q-page-container style="padding-top: 50px;padding-left: 100px;">
              <div class="row">
             <div class="col-3 text-p textStyle"> 
                Relief Centres
             </div>
              <div class="col-3"> 
                <q-btn class ="btnStyle" @click="prompt = true" label="Create"> 
                </q-btn>
              </div>
              
              <div class="col-6">
                <q-input 
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search"
                  style="width: 350px; padding-bottom: 32px"
                 
                  > </q-input> 
                </div>
      </div>
                <q-table  :rows ="rows" :columns="columns" :filter="filter"> 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props">
                    <q-td key ="name" :props="props"> 
                      {{ props.row.name}}
                    </q-td>

                      <q-td key ="address" :props="props"> 
                        {{ props.row.address}}
                      </q-td>

                    <q-td key ="email" :props="props"> 
                      {{ props.row.email}}
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
                  <q-card style="min-width:830px; min-height: 520px">
                    <div class= "row">
                      <div class="col-11">
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Create Relief Centre </p>
                      </div>
                      <div class= "col-1 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                     <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent">
                            <q-form @submit="createReliefCentre"> 
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="FName" v-model="Name"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 1" v-model="addressLone"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 2" v-model="addressLtwo"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="City" v-model="city"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Longitude " v-model="longitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Latitude" v-model="latitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Phone Number" v-model="pNo"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Email Address" v-model="email" type="email" maxlength="60" autogrow   :dense="dense" />
                            </q-form>
                      </div>
                     </div>
                      <template v-slot:after>
                      
                      </template>
                      
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" type="submit" flat label="Save" v-close-popup />
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                       
                      </q-card-actions>
                  </q-card>
                </q-dialog>
            </q-page-container>

               <q-dialog v-model="promptEdit" full-widthpersistent @show="loadData(current_row)">
                  <q-card style="min-width:830px; min-height: 520px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Edit Topic </p>
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>

                     <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent">
                            <q-form @submit="createReliefCentre"> 
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="FName" v-model="Name"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 1" v-model="addressLone"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 2" v-model="addressLtwo"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="City" v-model="city"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Longitude " v-model="longitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Latitude" v-model="latitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Phone Number" v-model="pNo"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Email Address" v-model="email" type="email" maxlength="60" autogrow   :dense="dense" />
                            </q-form>
                      </div>
                     </div>                  
                      <template v-slot:after>
                      
                      </template>
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" type="submit" v-close-popup />
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
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Delete {{ current_row.name  }} </p>
                      </div>
                      <div class= "col-2 q-pa-md">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                      <div class= "text-p q-px-xl q-pt-lg q-pb-md"> 
                        Are you sure you want to delete this Relief Centre 
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

export default defineComponent({
  name: "Topics",

  props: ['data'],


  setup(props) {
    const value = Date.now()
    const topics = ref([])
    const data = ref(null)
    const columns = [{
        name:'name',
        label:'Name',
        field:'name',
        align: 'left',
    }, {
        name:'address',
        label:'Address',
        field:'address',
        align: 'left',
    } ,
       {
        name:'email',
        label:'Email Address',
        field:'email',
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
        name:'Port of Spain Relief Cen…',
        address: '123 Centre Street, Port of Spain',
        email:'kwasiedwards@gmail.com',

    }, {
        id:2,
        name:'Port of Spain Relief Cen…',
        address: '123 Centre Street, Port of Spain',
        email:'kwasiedwards@gmail.com',
    }]

    function getTopics(){
        let url = "https://swarmnet.sundaebytes.com/api/topics"
        api.get(url, {
          method: 'GET',
          headers: {
          'Access-Control-Allow-Origin': '*'
        }
        }).then((response) => {
            data.value =  response.data.topics
            console.log(data.value)
            for(let i of data.value){
              topics.value.push({ id: i.id,
                topic: i.text,
                createdby:'Kwasi Edwards',
                createddate:'07.22.22',
                seeAllPostByTopic:'100',
            })
        }})
    }


    function createTopic(newTopic){
      console.log(newTopic)
      
      let url = "https://swarmnet.sundaebytes.com/api/admin/topics"
      api.post(url, {
        text:newTopic,
        level: 1
      }, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        data.value = response.data.topic
        console.log(data.value)
        topics.value.push({
                id: data.value.id,
                topic: data.value.text,
                createdby:'Kwasi Edwards',
                createddate:'07.22.22',
                seeAllPostByTopic:'100',
        })
      })
    }

    function editTopic(newTopic,currentTopic){
  
      let url = "https://swarmnet.sundaebytes.com/api/admin/topic/"+currentTopic.id
      api.put(url, {
        text:newTopic,
        level: 1
      }, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        console.log(response)
        topics.value = ([])
        getTopics()
      })
    }

    function deleteTopic(currentTopic){
      let url = "https://swarmnet.sundaebytes.com/api/admin/topic/"+currentTopic.id
      api.delete(url, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
        }
      }).then((response) => {
        console.log(response)
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