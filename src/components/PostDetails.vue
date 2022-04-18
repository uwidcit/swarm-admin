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

           <div class=" q-gutter-md">
            <q-chip square color="purple-2" text-color="white" icon="sell" size="md"
                    v-for="tags in postTags" 
                    :key="tags.id">
              {{tags.text}}
            </q-chip>

           </div>

        </q-item-section>

        <q-item-section side top>
          <q-item-label caption>
            {{date}}</q-item-label>
        </q-item-section>
        
      </q-item>
    </q-list>
</div>


  <div  v-for="c in testdata" :key="c.id" style="margin-left: 40px; box-sizing: border-box; ">
      <comments :label="c.text" :nodes="c.replies" :depth="0"  :id="c.id" :topic="c.topicId" :date="c.created"></comments>
    </div>

 
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
    

     setup() {
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

      function showComments(id){
        this.comments.slice(0);

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
                if(i.originalPostId == id){
                  comm.value.push(i)
                  commTags.value.push(i.tags)
                }
            } 
          
           console.log( "Tags ")
          console.log(commTags.value)
          
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
        showComments,
        testdata,
      
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