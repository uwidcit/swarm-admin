<template>

<div class="q-pa-md" >
    <q-list bordered padding >

      <q-item >
        <q-item-section top avatar>
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/boy-avatar.png">
          </q-avatar>
        </q-item-section>

        <q-item-section>
          <q-item-label> <strong> {{title}} </strong></q-item-label>

          <div class="row no-wrap items-center bg-grey-3 rounded-borders">
            <q-chip square color="purple-2" text-color="white" icon="sell" size="md"
                          v-for="tags in postTags" 
                          :key="tags.id">
                    {{tags.text}}
                  </q-chip>
            <q-space />
            <div>
              <q-btn round dense flat icon="textsms" @click="fixed=true" />    
            </div>
          </div>
           
        </q-item-section>

        <q-item-section side top>
          <q-item-label caption>
            {{date}}</q-item-label>
        </q-item-section>
        
      </q-item>
    </q-list>
</div>

  <div v-if="testdata.length == 0" class="text-weight-medium text-center text-italic">
      This post contains no replies. Be the first to reply?
      <q-btn round dense flat icon="textsms" @click="fixed=true" />
   </div>
   
  <div  v-for="c in testdata" :key="c.id" style="margin-left: 40px; box-sizing: border-box; ">
      <comments :label="c.text" :nodes="c.replies" :depth="0"  :id="c.id" :topic="c.topicId" :date="c.created"></comments>
    </div>

    <q-dialog v-model="fixed" no-refocus>
      <q-card style="width: 600px; height: 250px; background-color: powderblue;">

        <q-card-section>
          <div class="text-h6"> Create a reply </div>
        </q-card-section>
        <q-separator />

        <q-card-section style="height: 120px" class="scroll" counter maxlength="260">
          <q-input placeholder="Enter Comment Here!" type="textarea" v-model="text" counter maxlength="260"  autogrow>
          </q-input>
        </q-card-section>

        <q-separator />

        <q-card-actions align="right">
          <q-btn flat label="Discard" color="primary" @click="text = ''" v-close-popup />
          <q-btn flat label="Post" color="primary" v-close-popup @click="createNewComment(text); text = '';"/>
        </q-card-actions>

      </q-card>
    </q-dialog>
  

</template>

<script>
import Comments from 'components/Comments.vue'
import { ref, defineComponent, provide } from 'vue'
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import { onMounted} from 'vue'
import { useRoute } from 'vue-router'
import { formatDistance} from 'date-fns'

export default defineComponent({
    
     name: 'PostDetails',
     props: [ 'label', 'nodes', 'depth', 'id', 'topic', 'date' ],

     components: {
      Comments
    },

     data(){
        return {PostId: this.$route.params.id}
     },
    

     setup(props) {
      const route = useRoute()
      const $q = useQuasar()
      const data = ref(null)
      const posts = ref([])
      const title = ref("")
      const comm = ref([])
      const postTags = ref([])
      const commTags = ref([])
      const testdata = ref([])
      const date = ref("")
      const text = ref('')
      const tId = ref(0) /* topic id number */

      function datePassed(time) {
      console.log(Date.parse(time))
      console.log(formatDistance(Date.parse(time), new Date(), { addSuffix: true }))
        return formatDistance(Date.parse(time), new Date(), { addSuffix: true })
    }

      function loadPosts(){
         
         let url = "https://swarmnet-prod.herokuapp.com/posts/" + route.params.id
         
          api.get(url,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            tId.value = data.value.topicId
            posts.value.push(data.value) 
            date.value = datePassed(posts.value[0].created)
            title.value = posts.value[0].text
            postTags.value = posts.value[0].tags
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

      function loadComments(){
         let url = "https://swarmnet-prod.herokuapp.com/replies"
         
          api.get(url,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            
            for (let i of data.value) {
              
              if(i.originalPostId == route.params.id){
                 testdata.value.push(i)
              }
              console.log('hi')
              console.log(i.topicId)
            }

            for (let i of data.value) { 
                if(i.originalPostId == route.params.id){
                  comm.value.push(i)
                  commTags.value.push(i.tags)
                }
            } 
          console.log(testdata.value)
          
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


      function createNewComment(message){
        console.log("creating new comment")
        console.log(message, tId.value, route.params.id)

      api.post("https://swarmnet-prod.herokuapp.com/replies", {
          "topic_id": tId.value,
          "text": message,
          "replyTo": route.params.id,
          "tags": [],
          "composed": "2011-10-10T14:48:00Z"
        },{
          headers: {
            Authorization:'JWT '+ localStorage.getItem('token'),
            'Access-Control-Allow-Origin': '*'   
          }
          }).then((response) => {
            if(response.status == 201){

              // notify user 
              $q.notify({
              type: 'positive',
              message: 'COMMENT POSTED'
            })
              loadComments()

            }
    })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Reply could not be posted',
              icon: 'report_problem'
            })
          })
       
      
           
      }



  onMounted(() => {
      loadPosts();
      loadComments();
    })

    return {
        datePassed,
        date,
        data, 
        loadPosts,
        posts,
        title,
        comm,
        postTags,
        commTags,
       
        testdata,
        text,
        createNewComment,
        tId,
        fixed: ref(false)
      
    }
        
    },
})
</script>

<style>
#rcorners {
  margin-left: 3%;
  width: fit-content;
  height: fit-content;
  outline-style: double;
}

/**
 * Lineas / Detalles
 -----------------------*/
.comments-list:before {
	content: '';
	width: 2px;
	height: 100%;
	background: #c7cacb;
	position: absolute;
	left: 32px;
	top: 0;
}

.comments-list:after {
	content: '';
	position: absolute;
	background: #c7cacb;
	bottom: 0;
	left: 27px;
	width: 7px;
	height: 7px;
	border: 3px solid #dee1e3;
	-webkit-border-radius: 50%;
	-moz-border-radius: 50%;
	border-radius: 50%;
}

.reply-list:before, .reply-list:after {display: none;}
.reply-list li:before {
	content: '';
	width: 60px;
	height: 2px;
	background: #c7cacb;
	position: absolute;
	top: 25px;
	left: -55px;
}


.comments-list li {
	margin-bottom: 15px;
	display: block;
	position: relative;
}

.comments-list li:after {
	content: '';
	display: block;
	clear: both;
	height: 0;
	width: 0;
}

.reply-list {
	padding-left: 88px;
	clear: both;
	margin-top: 15px;
}

</style>