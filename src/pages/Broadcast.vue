<template>
    
        <q-page>
            <q-page-container style="padding-top: 50px;padding-left: 100px;">
              <div class="row">
              <div class="col-6"> 
                <q-btn class ="btnStyle" @click="prompt = true" label="Create Broadcast"> 
                </q-btn>
              </div>
              
              <div class="col-6">
                <q-input 
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search Broadcast"
                  style="width: 350px; padding-bottom: 32px"
                  > </q-input> 
                </div>
      </div>
                <q-table  :rows ="broadcast" :columns="columns" :filter="filter" dense> 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props"  @click="contentCard =true,  current_row = props.row">
                    <q-td key ="title" :props="props" > 
                      {{ props.row.title}}
                    </q-td>

                    <q-td key ="content" :props="props" > 
                      {{ props.row.content}}
                    </q-td>

                      <q-td key ="created_by" :props="props" > 
                        {{props.row.created_by }}
                      </q-td>

                    <q-td key ="created_date" :props="props"> 
                      {{ props.row.created_date}}
                    </q-td>
                  </q-tr>       
                  </template>
                  
                </q-table>

                <q-dialog v-model="contentCard" persistent>
                  <q-card style="min-width:945px; min-height: 530px">
                    <div class= "row">
                      <div class="col-11">
                      </div>
                      <div class= "col-1 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>

                      <div class="row">
                        <div class= "col-6 text-p q-pt-xl q-px-xl textStyle"> 
                           Title 
                        </div>

                        <div class= "col-6 text-p p q-pt-xl q-px-xl textStyle"> 
                           Send Date 
                        </div>
                      </div> 

                       <div class="row">
                        <div class= "col-6 text-p q-px-xl textContent"> 
                           {{ current_row.title }}  
                        </div>

                        <div class= "col-6 text-p q-px-xl textContent"> 
                          {{ current_row.created_date }} 
                        </div>
                      </div> 


                    <div class="row">
                        <div class= "col-12 text-p p q-pt-xl q-px-xl textStyle"> 
                           Content 
                        </div>
                      </div> 

                      <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent"> 
                           {{ current_row.content }}  
                        </div>
                      </div> 

            

                    <div class="row q-mt-lg">
                        <div class= "col-12 text-p p q-pt-xl q-px-xl  textStyle"> 
                           Metrics 
                        </div>
                      </div>

                    <div class="row">
                        <div class= "col-6 text-p q-px-xl textContent"> 
                          Target users: {{current_row.target_users}} 
                        </div>

                        <div class= "col-6 text-p q-px-xl textContent"> 
                          <p> Confirmed Deliveries : {{current_row.successful_users}} </p>
                          <p> Percentage Reached : {{current_row.percentage_reached}} %</p>
                          <br>

                        </div>
                      </div> 
                    
                      <template v-slot:after>
                      </template>

                      
                  </q-card>
                </q-dialog>

                
                <q-dialog v-model="prompt" persistent>
                  <q-card style="min-width:800px; min-height: 432px">
                    <div class= "row">
                      <div class="col-11 q-pa-xl text-p textStyle">
                        Create Broadcast 
                      </div>
                      <div class= "col-1 q-pa-md">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>

                      <div class="row">
                        <div class= "col-12 text-p q-pb-xs q-px-xl textStyle"> 
                           Title 
                        </div>
                      </div> 

                      <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent"> 
                           <q-input outlined v-model="title" style= "max-width : 90%" maxlength="60" />
                        </div>
                      </div>

                       <div class="row">
                        <div class= "col-12 text-p q-pt-lg q-px-xl textStyle"> 
                           Content 
                        </div>
                      </div> 

                      <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent"> 
                           <q-input outlined v-model="text" style= "max-width : 90%;" autogrow />
                        </div>
                      </div>
                      <template v-slot:after>
                      
                      </template>
                      
                 
                      <q-card-actions class="text-primary">
                  
                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" @click="sendBroadcast(title,text)" v-close-popup/>
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                                  
                      </q-card-actions>
                  </q-card>
                </q-dialog>
            </q-page-container>             
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
    const broadcast = ref([])
    const data = ref(null)
    const columns = [{
        name:'title',
        label:'Title',
        field:'title',
        align: 'left',
        sortable:true
    }, {
        name:'content',
        label:'Content',
        field:'content',
        align: 'left',
        sortable:true
    } ,
       {
        name:'created_by',
        label:'Created By',
        field:'created_by',
        align: 'left',
        sortable:true
       },
       {
        name:'created_date',
        label:'Created Date',
        field:'created_date',
        align: 'left',
        sortable:true
       }]

    const rows =[{
        title:'Rainy Seasons Begins',
        content:'Some long text that is the body of the push notification sent from disaster management…',
        created_by:'Kwasi Edwards',
        created_date:'07.22.22',

    }, {
        title:'Rainy Seasons Begins',
        content:'Some long text that is the body of the push notification sent from disaster management…',
        created_by:'Kwasi Edwards',
        created_date:'07.22.22',
    }]

    function getBroadcast(){
        let url = process.env.BASE_URL+"/api/admin/broadcast"
        api.get(url, {
          method: 'GET',
          headers: {
          Authorization:  'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
        }).then((response) => {
            data.value =  response.data.broadcasts
            console.log(data.value)
            for(let i of data.value){
              broadcast.value.push({ 
                id: i.id,
                title:i.title,
                content: i.text,
                created_date: new Date(i.created_on).toLocaleString(),
                created_by:i.created_by.first_name +" " +i.created_by.last_name,
                target_users:i.target_users,
                successful_users: i.successful_users,
                percentage_reached: i.successful_users/i.target_users * 100
            })
        }})
    }

    function sendBroadcast(title,content){
       let url = process.env.BASE_URL+"/api/admin/broadcast"
      api.post(url,{
        'title':title,
        'text':content
      },{
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        for(let i of data.value){
              broadcast.value.push({ 
                id: i.id,
                title:i.title,
                content: i.text,
                created_date:i.created_on,
                created_by:i.created_by.first_name +" " +i.created_by.last_name,
                target_users:i.target_users,
                successful_users: i.successful_users,
                percentage_reached: i.successful_users/i.target_users * 100
            })
        }
      })
    }

    function datePassed(convertDate) {
        let returnDate = new Date(convertDate)
        return returnDate.toLocaleString()
    }
  onMounted(() => {
    getBroadcast();
  })
    return{
      datePassed,
      data,
      title:ref(''),
      filter:ref(''),
      current_row:ref(''),
      contentCard:ref(false),
      prompt: ref(false),
      promptEdit: ref(false),
      promptDelete: ref(false),
      search:ref(''),
      getBroadcast,
      sendBroadcast,
      broadcast,
      columns,
      rows,
    }
  }
})
</script>

<style scoped>
.btnStyle{
width: 185px;
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

.textStyle{
  color: var(--unnamed-color-3e3e3e);
  text-align: left;
  font: normal normal bold 20px/36px Poppins;
  letter-spacing: 0px;
  color: #3E3E3E;
  opacity: 1
}

.textContent{
  color: var(--unnamed-color-3e3e3e);
  text-align: left;
  font: normal normal normal 18px/38px Poppins;
  letter-spacing: 0px;
  color: #3E3E3E;
  opacity: 1;
}
</style>