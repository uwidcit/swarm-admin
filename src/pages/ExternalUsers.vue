<template>
        <q-page>
            <q-page-container style="padding-top: 50px;padding-left: 100px;">
              <div class="row">
             <div class="col-6 text-p textStyle"> 
                External Users
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
                <q-table  :rows ="users" :columns="columns" :filter="filter"> 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props">
                    <q-td key ="first_name" :props="props"> 
                      {{ props.row.first_name}}
                    </q-td>

                      <q-td key ="last_name" :props="props"> 
                        {{ props.row.last_name}}
                      </q-td>

                    <q-td key ="email" :props="props"> 
                      {{ props.row.email}}
                    </q-td>


                    <q-td key ="last_seen" :props="props"> 
                       {{ props.row.last_seen}}
                    </q-td>
              
                  <q-td key ="moreOptions" :props="props"> 
                      <q-btn-dropdown dropdown-icon="fas fa-ellipsis" flat round> 
                        <q-list>
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
            </q-page-container>
              

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

export default defineComponent({
  name: "Topics",

  props: ['data'],


  setup(props) {
    const value = Date.now()
    const users = ref([])
    const data = ref(null)
    const columns = [{
        name:'first_name',
        label:'First Name',
        field:'first_name',
        align: 'left',
    }, {
        name:'last_name',
        label:'Last Name',
        field:'last_name',
        align: 'left',
    } ,
       {
        name:'email',
        label:'Email Address',
        field:'email',
        align: 'left',
       }, 
       {
        name:'last_seen',
        label:'Last Seen',
        field:'last_seen',
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
        last_seen:'Mon, 21st July 2022',
        first_name:'Kwasi',
        last_name: 'Edwards',
        email:'kwasiedwards@gmail.com',

    }, {
        id:2,
        last_seen:'Mon, 21st July 2022',
        first_name:'Kwasi',
        last_name: 'Edwards',
        email:'kwasiedwards@gmail.com',

    }]

    function getUsers(){
        let url = "https://swarmnet.sundaebytes.com/api/admin/users"
        api.get(url, {
          method: 'GET',
          headers: {
          'Access-Control-Allow-Origin': '*',
          Authorization:  'Bearer '+ localStorage.getItem('token') ,
        }
        }).then((response) => {
            data.value =  response.data.users
            console.log(data.value)
            for(let i of data.value){
              users.value.push({ 
                id: i.id,
                email: i.email,
                first_name: i.first_name,
                last_name: i.last_name,
                last_seen:'07.22.22',
            })
        }})
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
    getUsers();
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
      getUsers,
      editTopic,
      deleteTopic,
      users,
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