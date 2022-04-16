<template>
  <div class="q-pa-md" >
    <div class="q-gutter-md row">
      <q-input
        v-model="search"
        debounce="500"
        filled
        placeholder="Search Post by Tags"
        style="width: 350px; padding-bottom: 32px"
        @keyup.enter="searchByTags(search)"
      >
        <template v-slot:prepend>
          <q-icon name="search" />
        </template>
        <template v-slot:append>
          <q-btn icon="fas fa-times" flat round @click="search='', getDetails(topicInfo)" />
        </template>
      </q-input>

      <q-space/>

      <div class="q-gutter-sm row items-center no-wrap ">
      
    <q-btn fab flat round icon="far fa-edit" color="accent" size="xs" fab-mini @click="fixed = true">
      <q-tooltip>
            Create Post
          </q-tooltip>
    </q-btn>

    
      <q-btn icon="event" flat round color="accent">
         <q-tooltip>
            Filter by Date
          </q-tooltip>
      <q-popup-proxy @before-show="updateProxy" cover transition-show="scale" transition-hide="scale">
        <q-date v-model="proxyDate">
          <div class="row items-center justify-end q-gutter-sm">
            <q-btn label="Cancel" color="primary" flat v-close-popup />
            <q-btn label="OK" color="primary" flat @click="save" v-close-popup />
          </div>
        </q-date>
      </q-popup-proxy>
    </q-btn>





      </div>    
    </div>

     <q-dialog v-model="fixed" no-refocus>
      <q-card style="width: 600px; height: 400px; background-color: powderblue;">
        <q-card-actions>
          <q-btn-dropdown color="primary" label="TOPICS" >
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
          <div class="text-h6">New Discusssion For {{ptabtext}} </div>
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
          <q-btn flat label="Post" color="primary" v-close-popup @click="postPost(text, modelMultiple); text = '';"/>
        </q-card-actions>

      </q-card>
    </q-dialog>
  
    <!--- 
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
                
                <q-btn @click.prevent flat round color="grey" icon="fas fa-comments" size="sm"
                      style= " position: absolute; right: 16px;"
                      @click="prompt = true" />
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
        
    </div>
    --->
    </div>
          
 <q-page class="q-pa-sm">
    <div class="row q-col-gutter-sm ">
      <div class="col-md-4 col-lg-4 col-sm-12 col-xs-12" v-for="(post, index) in pos" >
        <card-product :data="post"></card-product>
      </div>
    </div>
  </q-page>
</template>

<script>

import {defineComponent, ref, onMounted, onUpdated, watchEffect } from 'vue';
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import CardProduct from './cards/CardProduct.vue';
export default defineComponent({
  components: { CardProduct },
  name: 'PostBoard',
  props:['tabText'], 
  data() {
    return {
      isConnected: false,
      socketMessage: ''
  }
  },
  sockets: {
    connect() {
      // Fired when the socket connects.
      this.isConnected = true;
    },
    disconnect() {
      this.isConnected = false;
    },
  },
  setup (props) {
    const $q = useQuasar()
    const data = ref(null)
    const tops = ref([])
    const pos = ref([])
    const subbed = ref(false)
    const model = ref(null)
    const posTags = ref([])
    const tab = ref('flooding')
    const comments = ref([])
    const ptabtext = ref('')
    const ptopid = ref('')
    const search = ref('')
    const options = ref([])
    const topicInfo = ref('')
    /* gets topics to use for q-dialog */
    function loadData () {
    
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
      
      /* console.log( tops.value[0].text) */
       console.log(tops) 
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
    /* filters post to get only post about the selected topic */
    function getDetails(topic){
      
      pos.value.splice(0)
      if(topic == 0){
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
            pos.value.unshift(i)
            posTags.value.unshift(i.tags)
          for(let j of comments.value){ /*remove comments from array with top level post */
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
      }
    
    /* displays all post after user logins in */
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
              
            for (let i of data.value) {  /*add all replies to an array */
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
              data.value = response.data /* get all post */
              
            for (let i of data.value) {  /* filter post from replies */
                pos.value.unshift(i)  /*the unshift() function adds one or more items to the start of an array*/
                posTags.value.unshift(i.tags)
                 
              for(let j of comments.value){
                if(i.id == j.id){
                  pos.value.shift(i)  
                  posTags.value.shift(i.tags)
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
    
    /*get all top level post with a partciular tag*/
    function searchByTags(searchTag){
   
      let url = `https://swarmnet-prod.herokuapp.com/posts/${searchTag}`
      console.log(url)
            api.get(url,{
            method: 'GET',
            
            headers: {
                    'Access-Control-Allow-Origin': '*',
                  },
  
            })
            .then((response) => {
              
              data.value = response.data
              console.log(data.value)
              /* display search list */
              pos.value.splice(0)
              for (let i of data.value) { 
                  pos.value.unshift(i)
                  posTags.value.unshift(i.tags)
                for(let j of comments.value){
                  if(i.id == j.id ){
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
                message: 'No post with such tag found',
                icon: 'report_problem'
              })
            })
    }
    
    /* creates new post using q-dialog*/ 
    function postPost(text, tags){
      if(ptopid.value == ''){
        ptopid.value = props.tabText
      }
      let url = "https://swarmnet-prod.herokuapp.com/posts"
          
            api.post(url,{
              topic_id: ptopid.value,  
              text: text,
              tags: tags,
              composed: "2022-03-02T14:48:00Z"
              },
              {
                headers: {
                  Authorization:'JWT '+ localStorage.getItem('token'),
                  'Access-Control-Allow-Origin': '*'
                  
                }
              }
              )
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
  
  /* gets all post tags */
  function getPostTags(){
    api.get("https://swarmnet-prod.herokuapp.com/tags",{
        headers: {
          Authorization:'JWT '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*' 
        }}
      )
            .then((response) => {
              data.value = response.data
              for (let i of data.value) { 
                options.value.unshift(i.text)
              }
              console.log(options)
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
    console.log(props.tabText)
    topicInfo.value = props.tabText
    if(props.tabText == 0){
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
        data.value = response.data
        for (let i of data.value) { 
          if(i.topicId == parseInt(props.tabText)){
            
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
        console.log(props.tabText);
        displaySub()
       
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
     
      //  subsStatus(props.tabText);
   
  });
  onMounted(() => {
      loadData();
      displayAllPost();
      getPostTags();
    })
  
  onUpdated(()=> {
    props.tabText; 
  })
    return {
        prompt: ref(false),
        modelMultiple: ref(),
        topicInfo,
        search,
        searchByTags,
        data, 
        loadData,
        tops,
        pos,
        posTags,
        getDetails,
        ptabtext,
        postPost,
        ptopid,
        getPostTags,
        options,
       
        model,
        fixed: ref(false),
        text: ref(''),
        ph: ref(''),
        dense: ref(false),
        tab,
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
<style lang="sass" scoped>
.my-card
  width: 100%
  max-width: 300px
</style>