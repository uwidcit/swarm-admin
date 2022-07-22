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
                  v-model="search"
                  debounce="500" 
                  placeholder="Search Topics"
                  style="width: 350px; padding-bottom: 32px"
                  @keyup.enter="searchByTags(search)"
                  > </q-input> 
                </div>
      </div>
                <q-table  :rows ="rows" :columns="columns" dense> 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props">
                    <q-td key ="title" :props="props"  @click="contentCard =true,  current_row = props.row"> 
                      {{ props.row.title}}
                    </q-td>

                    <q-td key ="content" :props="props"  @click="contentCard =true , current_row = props.row"> 
                      {{ props.row.content}}
                    </q-td>

                      <q-td key ="created_by" :props="props"  @click="contentCard =true ,current_row = props.row"> 
                        {{ props.row.created_by}}
                      </q-td>

                    <q-td key ="created_date" :props="props"  @click="contentCard =true , current_row = props.row"> 
                      {{ props.row.created_date}}
                    </q-td>
                    
                  <q-td key ="moreOptions" :props="props"> 
                      <q-btn-dropdown dropdown-icon="fas fa-ellipsis" flat round> 
                        <q-list>
                         <q-item clickable v-close-popup @click="promptEdit = true, current_row= props.row" >
                          <q-item-section>
                            <q-item-label>Edit</q-item-label>
                          </q-item-section>
                         </q-item>

                          <q-item clickable v-close-popup @click="promptDelete = true , current_row= props.row">
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
                           Target users : 1,300,000 
                        </div>

                        <div class= "col-6 text-p q-px-xl textContent"> 
                          Confirmed Deliveries : 650,000
                          Percentage Reached : 50% 
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
                           <q-input outlined v-model="text" style= "max-width : 90%" maxlength="60" />
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
                               <q-btn class= "btnStyle" flat label="Save" v-close-popup/>
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                                  
                      </q-card-actions>
                  </q-card>
                </q-dialog>
            </q-page-container>

          

          <q-dialog v-model="promptEdit" :props = "props" full-widthpersistent>
                  <q-card style="min-width:800px; min-height: 432px">
                    <div class= "row">
                      <div class="col-11 q-pa-xl">
                        <p class = "textStyle"> Edit Broadcast </p>
                      </div>
                      <div class= "col-1 q-pa-sm">
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
                           <q-input outlined v-model="text" style= "max-width : 90%" maxlength="60" />
                        </div>
                      </div>

                       <div class="row">
                        <div class= "col-12 text-p q-pt-lg q-px-xl textStyle"> 
                           Content 
                        </div>
                      </div> 

                      <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent"> 
                           <q-input outlined v-model="text" value='"Hello"' style= "max-width : 90%;" autogrow >  </q-input>
                        </div>
                      </div>

                      <template v-slot:after>
                      
                      </template>
                      
                      <q-card-actions align="right" class="text-primary">
                        <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" v-close-popup />
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
                      <div class="col-10 q-pa-xl text-p textStyle ">
                        Delete {{ current_row.topic }}
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                      <div class= "row q-px-xl text-p textContent">
                        Are you sure you want to delete this Broadcast 
                      </div>
                      <template v-slot:after>
                      
                      </template>
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Confirm" @click = "deleteBroadcast(current_row)" v-close-popup />
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
        name:'title',
        label:'Title',
        field:'topic',
        align: 'left',
    }, {
        name:'content',
        label:'Content',
        field:'content',
        align: 'left',
    } ,
       {
        name:'created_date',
        label:'Created Date',
        field:'created_date',
        align: 'left',
       }, 
       {
        name:'created_by',
        label:'Created By',
        field:'created_by',
        align: 'left',
       }, 
       {
        name:'moreOptions',
        label:'',
        field:'moreOptions',
        align: 'left',
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
                created_by:'Kwasi Edwards',
                createddate:'07.22.22',
                seeAllPostByTopic:'100',
            })
        }})
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
      current_row:ref(''),
      contentCard:ref(false),
      prompt: ref(false),
      promptEdit: ref(false),
      promptDelete: ref(false),
      search:ref(''),
      getTopics,
      topics,
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