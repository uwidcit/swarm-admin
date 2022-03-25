<template>
  <div class="q-pa-md" >

    <div class="q-gutter-md row">
      <q-select
        filled
        :model-value="automodel"
        use-input
        hide-selected
        fill-input
        input-debounce="0"
        :options="options"
        @filter="filterFn"
        @input-value="setModel"
        style="width: 350px; padding-bottom: 32px"
        @click="searchByTags(options.values)"
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              No results
            </q-item-section>
          </q-item>
        </template>

        <template v-slot:prepend>           
          <q-icon name="search" />          
        </template>

      </q-select>
    

      <div class="q-pa-md" style="position: absolute; right: 0;">
        <q-btn fab flat round icon="far fa-edit" color="accent" size="0xs" fab-mini @click="fixed = true"/>
        
      <q-btn icon="event" flat round color="accent">
      <q-popup-proxy @before-show="updateProxy" cover transition-show="scale" transition-hide="scale">
        <q-date v-model="proxyDate">
          <div class="row items-center justify-end q-gutter-sm">
            <q-btn label="Cancel" color="primary" flat v-close-popup />
            <q-btn label="OK" color="primary" flat @click="save" v-close-popup />
          </div>
        </q-date>
      </q-popup-proxy>
    </q-btn>

       <q-radio keep-color v-model="shape" val="res" label="Restricted" color="teal" />
       <q-radio keep-color v-model="shape" val="line" label="Unrestricted" color="teal" />

       </div>
    </div>
  

     <q-dialog v-model="fixed" no-refocus>
      <q-card style="width: 600px; height: 400px; background-color: powderblue;">
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
          <div class="text-h6">New Discussion For {{ptabtext}} </div>
        </q-card-section>
        <q-separator />

        <q-card-section style="height: 120px" class="scroll" counter maxlength="260">
          <q-input placeholder="Enter Post Here!" type="textarea" v-model="text" counter maxlength="260"  autogrow>
          </q-input>
        </q-card-section>

        <q-separator/>

        <q-card-actions> 
          <div style="min-width: 250px; max-width: 300px">
            <q-select
              filled
              v-model="modelMultiple"
              multiple
              :options="options"
              use-chips
              stack-label
              label="Please select tags .."
            />
      </div>
        </q-card-actions>

        <q-separator />

        <q-card-actions align="right">
          <q-btn flat label="Discard" color="primary" @click="text = ''" v-close-popup />
          <q-btn flat label="Post" color="primary" v-close-popup @click="triggerPositive(); text = '';"/>
        </q-card-actions>

      </q-card>
    </q-dialog>
  </div>
      <div>
      <!--- <q-btn  flat round color="primary" icon="fas fa-sync-alt" /> --->
      </div>  
    
    <div class="q-pa-md" id= "clear" >
    <q-list bordered padding separator >
    
      <q-item 
        v-for="(post, index) in pos" 
        :key="post.id" 
        :to="`/Details/${post.id}`" 
        active-class="q-item-no-link-highlighting">
      
        <q-item-section top avatar> 
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/boy-avatar.png">
          </q-avatar>
        </q-item-section>

        <q-item-section>
          <q-item-label> <strong> {{post.text}} </strong></q-item-label>

          <div class=" q-gutter-md">
            
            <q-chip  v-for="tag in posTags[index]" :key="tag"
                     square color="purple-2" text-color="white" icon="sell" size="md">     
                {{tag.text}}
            </q-chip>
            
           </div>

          <div class="row justify-between q-mt-sm">
                <q-btn @click.prevent flat round color="grey" icon="fas fa-comments" size="sm" @click="prompt = true" />
                <q-btn @click.prevent flat round icon="far fa-eye" size="sm" />

          </div> 
        </q-item-section>

        <q-item-section side top>
          <q-item-label caption> {{post.created}} </q-item-label>
        </q-item-section>
        
      
      </q-item>
      
    </q-list>
    
        <q-dialog v-model="prompt" persistent>
          <q-card style="min-width: 350px">
            <q-input  placeholder="Add comment..." v-model="text" counter maxlength="260" autogrow :dense="dense">
              <template v-slot:after>
                <q-btn round dense flat icon="send" />
              </template>
            </q-input>
            <q-card-actions align="right" class="text-primary">
              <q-btn flat label="Cancel" v-close-popup />
            </q-card-actions>
          </q-card>
        </q-dialog>


    <br>
    </div>
  <!--
  <p>
    Message to grand child: {{ message }}
  </p>
  -->
</template>



<script>
import {defineComponent, defineAsyncComponent, ref} from 'vue';
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import { onMounted, onUpdated, watchEffect, inject} from 'vue'
import { useRoute } from 'vue-router'

export default defineComponent({
  name: 'PostBoard',

  props:['tabText'],

  data(){
        return {
          topic: this.$route.params.tabText,
          }
        
     },
  

  setup (props) {
    const $q = useQuasar()
    const route = useRoute()
    const data = ref(null)
    const tops = ref([])
    const pos = ref([])
    const  subbed = ref(true)
    const model = ref(null)
    const posTags = ref([])
    const tab = ref('flooding')
    const comments = ref([])
    const ptabtext = ref('')
    const searchtags = ref([])
    const automodel = ref(null)
    const options = ref(searchtags)
    const ptopid = ref('')
    const message = inject('message')
    //sid.value = props.tabText


  function getDetails(topic){
      pos.value.splice(0)

      let url = "https://swarmnet-prod.herokuapp.com/posts"
      api.get(url,{
      method: 'GET',
      headers: {
              'Access-Control-Allow-Origin': '*'
            }
        })
      .then((response) => {
        data.value = response.data

        for (let i of data.value) { 
          if(i.topicId == parseInt(topic)){
            pos.value.push(i)
            posTags.value.push(i.tags)
          for(let j of comments.value){
            if(i.id == j.id ){
              pos.value.pop()
              posTags.value.pop()
            }
            }
          }
        }

        for(let j of tops.value){
          if(j.id == parseInt(props.tabText)){
            ptabtext.value = j.text
          }     
        }    
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

      function searchByTags(topicName){
      console.log("function called")
      console.log(topicName)
    }

  function displayAllPost(){
        let curl = "https://swarmnet-prod.herokuapp.com/replies"
          api.get(curl,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            
           for (let i of data.value) { 
               comments.value.push(i)
            }
           })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Loading failed',
              icon: 'report_problem'
            })
          })

    
         let url = "https://swarmnet-prod.herokuapp.com/posts"
         
          api.get(url,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            
           for (let i of data.value) { 
             for(let k of i.tags){
              if(searchtags.value.indexOf(k.text) == -1){
                searchtags.value.push(k.text)
                console.log(k.text)
              }
          }
             pos.value.push(i)
             posTags.value.push(i.tags)
             for(let j of comments.value){
               if(i.id == j.id){
                 pos.value.pop()
                 posTags.value.pop()
               }  
             }
            }
            console.log(posTags.value)
           
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
  
  function  showNotif () {
         if (subbed.value == true){
           $q.notify({
          message: 'SUBSCRIBED',
          color: 'primary',
          avatar: 'https://cdn.quasar.dev/img/boy-avatar.png',
          actions: [
            { label: 'Dismiss', color: 'white', handler: () => { /* ... */ } }
          ]
        })
         }   
       }

  function postPost(){
    let url = "https://swarmnet-prod.herokuapp.com/posts"
         
          api.get(url,{
          method: 'POST',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            if(response.data == "Created"){
              triggerPositive ();
              setTimeout(() => {
                displayAllPost();    
        }, 3000) 
            }
 
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
  
   watchEffect(()=>{
    console.log("hi")
    console.log(message.value)


    if(message.value == 0){
      pos.value.splice(0)
      
      let url = "https://swarmnet-prod.herokuapp.com/posts"
          
            api.get(url,{
            method: 'GET',
            
            headers: {
                    'Access-Control-Allow-Origin': '*'
                  }
              })
            .then((response) => {
              data.value = response.data

              for (let i of data.value) { 
               
            
                pos.value.unshift(i)
                 posTags.value.unshift(i.tags)
              for (let j of comments.value){
              if(i.id == j.id){
                pos.value.shift()
                 posTags.value.shift()
              }
            }
            }
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
    else{
      pos.value.splice(0)
      let url = "https://swarmnet-prod.herokuapp.com/posts"
      api.get(url,{
      method: 'GET',
      headers: {
              'Access-Control-Allow-Origin': '*'
            }
        })
      .then((response) => {
        console.log("request sent")
        data.value = response.data

        for (let i of data.value) { 
          console.log("loop entered")
          if(i.topicId == parseInt(message.value)){
            
            pos.value.unshift(i)
            posTags.value.unshift(i.tags)
          for(let j of comments.value){
            if(i.id == j.id ){
              pos.value.shift()
              posTags.value.shift()
            }
            }
          }
        }

        console.log(pos.value)

        for(let j of tops.value){
          if(j.id == parseInt(props.tabText)){
            ptabtext.value = j.text
          }     
        }  
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
   
  });


  onMounted(() => {
      displayAllPost(); 
    })
  

    return {
      message,
      shape: ref('line'),
      modelMultiple: ref(),
      automodel,
      options,
      searchtags,

      filterFn (val, update, abort) {
        update(() => {
          const needle = val.toLocaleLowerCase()
          options.value = searchtags.value.filter(v => v.toLocaleLowerCase().indexOf(needle) > -1)
        })
      },

      setModel (val) {
        automodel.value = val
      },
        data, 
        displayAllPost,
        tops,
        pos,
        posTags,
        getDetails,
        ptabtext,
        
        model,
        subbed,
        fixed: ref(false),
        prompt: ref(false),
        text: ref(''),
        ph: ref(''),
        dense: ref(false),
        tab,
    
       showNotif,


      triggerPositive () {
        $q.notify({
          type: 'positive',
          message: 'DISCUSSION POSTED'
        })
        // simulate delay
        setTimeout(() => {
          notif({
            type: 'positive',
            message: 'Found the results that you were looking for',
            timeout: 1000
          })
        }, 4000)
      }
      
    }
  }
})
</script>

