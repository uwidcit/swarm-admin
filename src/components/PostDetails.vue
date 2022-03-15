<template>

<div class="q-pa-md" >
    <q-list bordered padding>

      <q-item >
        <q-item-section top avatar>
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/boy-avatar.png">
          </q-avatar>
        </q-item-section>

        <q-item-section>
          <q-item-label> <strong> {{title}} </strong></q-item-label>
          <br/>

           <div class=" q-gutter-md">
            <q-chip square color="purple-2" text-color="white" icon="sell" size="md"
                    v-for="tags in postTags" 
                    :key="tags.id">
              {{tags.text}}
            </q-chip>
           </div>

          <div class="row justify-between q-mt-sm">
                <q-btn flat round color="grey" icon="fas fa-comments" size="sm" />
                <q-btn flat round icon="far fa-eye" size="sm"/>
                <q-btn flat round icon="far fa-heart" size="sm" />
                
          </div> 
        </q-item-section>

        <q-item-section side top>
          <q-item-label caption>5 min ago</q-item-label>
        </q-item-section>
        
      </q-item>
    </q-list>
</div>

<div id="rcorners"><h5 class="text-italic">Comments</h5></div>

<div v-for="c in testdata" :key="c.id" style="margin-left: 40px">
  <comments  :label="c.text" :nodes="c.tags" :depth="0" ></comments>
</div>

</template>

<script>
import Comments from 'components/Comments.vue'
import { ref, defineComponent, watch } from 'vue'
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import { onMounted} from 'vue'
import { useRoute } from 'vue-router'

export default defineComponent({
    
     name: 'PostDetails',
     props: [ 'label', 'nodes', 'depth' ],

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
      const tree = ref({label: 'root',
                        nodes: [
                          {
                            label: 'item1',
                            nodes: [
                              {
                                label: 'item1.1'
                              },
                              {
                                label: 'item1.2',
                                nodes: [
                                  {
                                    label: 'item1.2.1'
                                  }
                                ]
                              }
                            ]
                          }, 
                          {
                            label: 'item2'  
                          }
                        ]})

      function loadPosts(){
         
         let url = "https://swarmnet-staging.herokuapp.com/posts/" + route.params.id
         
          api.get(url,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            posts.value.push(data.value) 
            
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
         
         let url = "https://swarmnet-staging.herokuapp.com/replies"
         
          api.get(url,{
          method: 'GET',
          
          headers: {
                  'Access-Control-Allow-Origin': '*'
                }
            })
          .then((response) => {
            data.value = response.data
            
            for (let i of data.value) {
             testdata.value.push(i)
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

         let url = "https://swarmnet-staging.herokuapp.com/replies"
         
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
      tree,
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
</style>