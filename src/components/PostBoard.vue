<template>
   <!--<div class="q-pa-md" >
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
          <q-btn icon="fas fa-times" flat round @click="search='', getDetails(message)" />
        </template>
      </q-input>
-->
      <q-space/>

     <!-- <div class="q-gutter-sm row items-center no-wrap ">
    
    <q-btn fab flat round icon="far fa-edit" color="accent" size="xs" fab-mini @click="fixed = true">
      <q-tooltip>
            Create Post
          </q-tooltip>
    </q-btn> -->

    <!--
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
    </div>-->

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
    
    </div>--->
    <div class="row">
        <div class= "postHeader q-ma-lg" style="color: #4D4D4D;"> All Posts </div>
    </div> 
  <q-page class="row-12 q-col-gutter-lg" > 
   
    <div class="row q-col-gutter-lg">
      <div class= "col-lg-10 col-md-8 q-col-gutter-lg">
        <div v-if="loading = true">
          <div class="col-md-12 col-lg-12 col-sm-12 col-xs-12" v-for="(post) in pos" :key ="post.id">
            <div>
              <post-design :data="post"></post-design>
            </div>
          </div>
        </div>
        <v-progress-circular v-else/>

    </div>



    <div class= "col-lg-2 col-md-4 col-sm-1 col-xs-1  q-col-gutter-lg">
    
      <q-select sqaure filled v-model= "selectModel" :options="['Most Recent', 'Oldest', 'Trending']" :display-value="'Most Recent'" ></q-select>
      <q-item-label class="text-h6"> Filter By: </q-item-label>  
      
      <q-form @submit="searchByTags(selectModel)">
      <q-option-group v-model= "selectModel" type="radio" :options= "options">
      </q-option-group>
      <div>
        <q-btn label="Submit" type="submit" color="primary"/>
      </div>
      </q-form>
    </div>
    </div>
  </q-page>

</template>
<script>
import {defineComponent, ref, onMounted, onUpdated, watchEffect, inject } from 'vue';
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import PostDesign from './PostDesign.vue';

let url = process.env.ADMIN_API_URL + '/posts';
let post_url = process.env.ADMIN_API_URL + '/posts';
let topics_url = process.env.ADMIN_API_URL + '/topics'

export default defineComponent({
  components: { PostDesign },
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
    const loading = true
    const $q = useQuasar()
    const post_data = ref(null)
    const post_tops = ref([])

    const data = ref(null)
    const tops = ref([])
    const pos = ref([])
    const subbed = ref(false)
    const model = ref(null)
    const selectModel = ref(null)
    const posTags = ref([])
    const tab = ref('flooding')
    const comments = ref([])
    const ptabtext = ref('')
    const ptopid = ref('')
    const search = ref('')
    const options = ref([])
    const topicInfo = ref('')
    const message = inject('message')

    /* gets topics to use for q-dialog */
    //LOADING IN TOPICS
    function loadData () {
      api.get(topics_url, {
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
        })
        .catch(() => {
          $q.notify({
            color: 'negative',
            position: 'top',
            message: 'Loading of topics failed',
            icon: 'report_problem'
          })
        })


      //LOADING IN POSTS
      api.get(post_url, {
        method: 'GET',
        headers: {
          Authorization: 'Bearer ' + localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
      })
        .then((response) => {
          post_data.value = response.data.posts
          for (let i of post_data.value) {
            let o = JSON.parse(JSON.stringify(i))
            pos.value.unshift(o)
            posTags.value.unshift(o.tags)
            for (let j of comments.value) {
              if (i.id == j.id) {
                let o = JSON.parse(JSON.stringify(i))
                pos.value.shift(o)
                posTags.value.shift(o.tags)
              }
            }
          }
          loading = false
        })
        .catch(() => {
          $q.notify({
            color: 'negative',
            position: 'top',
            message: 'Loading of post failed (1)',
            icon: 'report_problem'
          })
        })
  }

        /* displays all post after user logins in */
    function displayAllPost(){
          pos.value.unshift({
            id: -1,
            title: '',
            text:'',
            created_date: '',
            media: [],
            tags:{
              id:'',
              tag:''
            },
            user: {
                email: "",
                first_name: "",
                last_name: "",
                profile_image: null
            }
          })
        } 

  
    /* filters post to get only post about the selected topic */
    function getDetails(topic){
      
      pos.value.splice(0)
      console.log("get details")
      if(topic == 0){

        pos.value.splice(0)
      
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
    

    
    /*get all top level post with a partciular tag*/
    function searchByTags(searchTag){
   
      let search_url = url+`/${searchTag}`
      //console.log(url)
            api.get(search_url,{
            method: 'GET',
            headers: {
                    'Access-Control-Allow-Origin': '*',
                  },
  
            })
            .then((response) => {
              
              data.value = response.data
             // console.log(data.value)

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
      // let url = "https://swarmnet-prod.herokuapp.com/posts"
          
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
    api.get(process.env.COMMON_API_URL+"/tag",{
        headers: {
          Authorization:  'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*' 
        }}
      )
            .then((response) => {
              data.value = response.data.tags
              for (let i of data.value) { 

                options.value.push({
                  value:i.id,
                  label:i.text,
                  created:i.created})
              }
             // console.log(options.value)
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

  onMounted(() => {
      loadData();
      displayAllPost();
      getPostTags();
    })

  watchEffect(()=>{
    if(message.value == 0){
      pos.value.splice(0)
      
      let url = "https://swarmnet.sundaebytes.com/api/admin/posts"
          
            api.get(url,{
            method: 'GET',
            
            headers: {
                    Authorization: 'Bearer '+ localStorage.getItem('token'),
                    'Access-Control-Allow-Origin': '*'
                  }
              })
            .then((response) => {
              console.log("done")
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
                message: 'Loading failed (2)',
                icon: 'report_problem'
              })
            })
    }
    else{
      console.log("else")
      pos.value.splice(0)
      // let url = "https://swarmnet-prod.herokuapp.com/posts"
      api.get(url,{
      method: 'GET',
      headers: {
              'Access-Control-Allow-Origin': '*'
            }
        })
      .then((response) => {
        data.value = response.data

        for (let i of data.value) { 
          if(i.topicId == message.value){
            
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

        //console.log(pos.value)

        for(let j of tops.value){
          if(j.id == message.value){
            ptabtext.value = j.text
          }     
        }  

       // console.log(props.tabText);

           })
      .catch(() => {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: 'Loading failed (3)',
          icon: 'report_problem'
        })
      })
    }
     
      //  subsStatus(props.tabText);
   
  });
  onUpdated(()=> {
    props.tabText; 
  })
    return {
        loading,
        prompt: ref(false),
        modelMultiple: ref(),
        topicInfo,
        search,
        searchByTags,
        selectModel,
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
        message,
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
  height: 100%
  max-width: 1440px
  background: #FFFFFF 0% 0% no-repeat padding-box
  border-radius: 20px
  opacity: 1

.postHeader
  text-align: left
  font: normal normal bold 40px/60px Poppins
  letter-spacing: 0px
  color: #4D4D4D
  opacity: 1

.col-lg-12
  padding: 20px 30px 30px
</style>