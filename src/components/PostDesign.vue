<template>
  <q-card class="my-card background">
     <!--<a :href="`/Details/${data.id}`"> </a>-->

    <!-- <div v-if="dataLoaded()"><p>LOADING</p></div>
    <div v-else><p>DONE</p></div> -->


<!-- HEADING -->
    <q-card-section square=true>
      <div class="row q-gutter-none q-pa-md q-ma-xs">
        <div class="col-4 text-p postTitle">{{data.title}}</div>
        <div class="col-4 text-p">
        </div>
        <div class="col-4 text-p dateStyle">
              <p> {{datePassed()}} </p>
              <p>{{ full_name }}</p>
        </div>
      </div>


               <!-- <div class="col text-subtitle1 text-justify q-mt-sm">
          {{datePassed()}}
        </div> -->


                <!-- <span class="tag tag-blue" v-for="(tag) in data.tags" :key="tag">              -->
                    <!-- {{tag.tag_text}}     -->
          <!-- </span> -->
<!-- CONTENT -->

    <div class="q-pa-md">
      <div class="row">
        <div class="col-9 text-p">
          {{ data.text }}
        </div>         
      </div>
    </div>

<!-- MEDIA -->

  <!-- <div v-if=" hasMedia()"><p>LOADING</p></div> -->

    <div class="row" v-if="data.media.length > 0"> 
      <div class="col">
        <q-carousel animated v-model="slide" arrows navigation infinite >
            <q-carousel-slide v-for="(media) in data.media" :key="getMediaURL(media)" :name="getMediaURL(media)" :img-src="getMediaURL(media)" />
            <!-- <q-carousel-slide :name="2" img-src="https://cdn.quasar.dev/img/parallax1.jpg" />
            <q-carousel-slide :name="3" img-src="https://cdn.quasar.dev/img/parallax2.jpg" />
            <q-carousel-slide :name="4" img-src="https://cdn.quasar.dev/img/quasar.jpg" /> -->
        </q-carousel>
          <!-- <q-img :src="img"/> -->
      </div>
    </div>

<!-- BUTTONS -->
    
    </q-card-section>
    <q-separator color="grey"/>
     <q-card-actions>
            <div class="col-4 q-px-xl">
                <q-icon name="fa-solid fa-message"></q-icon>
                <q-btn flat @click="toggleComments"> Comments </q-btn>
            </div>
             <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-heart"> </q-icon>
              <q-btn flat> Likes: {{ data.likes }} </q-btn>
            </div>
             <!-- <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-share"></q-icon>
              <q-btn flat> Share</q-btn>
            </div> -->
    </q-card-actions>

<!-- COMMENTS -->

<!-- <div v-if="seeComments">
  <q-separator color="grey" />
  <q-card class="q-pa-md my-card background">
    <q-card-section square="true">
      <CommentCard
        v-for="(nestedReply) in data.replies"
        :key="getReplyKey(nestedReply, replyDepth + 1)"
        :reply="nestedReply"
        :replyDepth="replyDepth + 1"
      />
    </q-card-section>
  </q-card>
</div> -->


    <div v-if="seeComments">
        <q-separator color="grey"/>
          <q-card class=" q-pa-md my-card background">
            <q-card-section square="true" >
              <comments
                :nodes="data.replies" 
                :label="node.text"
                :depth="depth + 1"
                :id="node.id"
                :topic="node.topicId" 
                :date="node.created"
              ></comments>
              
              <!-- <div v-if="data.replies.length > 0">
                <div v-for="reply in data.replies" :reply="reply.replies" :key="getReplyKey(reply)">
                  <p> {{ reply.first_name }} {{ reply.last_name }} </p>
                  <p>{{ reply.text }} </p> -->
                    
                  <!-- <div v-for="nestedReply in reply.replies" :nestedReply="nestedReply.replies" :key="getReplyKey(nestedReply)">
                    <p> {{ nestedReply.first_name }} {{ nestedReply.last_name }} </p>
                    <p>{{ nestedReply.text }} </p>
                  </div> -->

                  <!-- <nested-comment v-for="nestedReply in reply.replies" :reply="nestedReply.replies" :key="getReplyKey(nestedReply)"></nested-comment>
                </div> -->
                


                

                <!-- <div class="row">
                  <div class="col-1">
                    <q-avatar icon="fa-solid fa-circle-user fa-2xl"/>
                  </div>
                  <div class="col-11">
                    <p> {{ reply.first_name }} {{ reply.last_name }} </p>
                    <p>{{ reply.text }} </p>
                  </div>
                </div> -->
              <!-- </div> -->

                <q-card-actions>
                <div class="col-4 q-px-xl">
                    <q-icon name="fa-solid fa-message"></q-icon>
                    <q-btn flat @click="toggleComments"> Comments  </q-btn>
                </div>
                <div class="col-4 q-px-xl">
                  <q-icon name="fa-solid fa-heart"> </q-icon>
                  <q-btn flat> Likes:  </q-btn>
                </div>
                <div class="col-4 q-px-xl">
                  <q-icon name="fa-solid fa-share"></q-icon>
                  <q-btn flat> Share</q-btn>
                </div>
              </q-card-actions>
            <q-separator color="grey"/>
          </q-card-section>    
        </q-card>
    </div>

    <!-- <div v-if="seeComments">
      <q-separator color="grey"/>
        <q-card class=" q-pa-md my-card background">
          <q-card-section square="true" v-for="(reply) in data.replies" :key="getReplyKey(reply)">
            <div class="row">
              <div class="col-1">
                <q-avatar icon="fa-solid fa-circle-user fa-2xl"/>
              </div>
              <div class="col-11">
                <p> {{ reply.first_name }} {{ reply.last_name }} </p>
                <p>{{ reply.text }} </p>
              </div>
            </div>
              <q-card-actions>
              <div class="col-4 q-px-xl">
                  <q-icon name="fa-solid fa-message"></q-icon>
                  <q-btn flat @click="toggleComments"> Comments  </q-btn>
              </div>
              <div class="col-4 q-px-xl">
                <q-icon name="fa-solid fa-heart"> </q-icon>
                <q-btn flat> Likes:  </q-btn>
              </div>
              <div class="col-4 q-px-xl">
                <q-icon name="fa-solid fa-share"></q-icon>
                <q-btn flat> Share</q-btn>
              </div>
            </q-card-actions>
          <q-separator color="grey"/>
        </q-card-section>    
      </q-card>
    </div> -->
  </q-card>
</template>

<script>



// Vue.component('nested-comment', {
//     props: ['reply'],
//     template: `
//     <div>
//       <div class="row" v-if="reply.replies.length > 0">
//         <div class="col-1">
//           <q-avatar icon="fa-solid fa-circle-user fa-2xl"/>
//         </div>
//         <div class="col-11">
//           <p> {{ reply.first_name }} {{ reply.last_name }} </p>
//           <p>{{ reply.text }} </p>
//         </div>
//       </div>
//       <nested-comment v-for="nestedReply in reply.replies" :reply="nestedReply" :key="getReplyKey(nestedReply)"></nested-comment>
//     </div>
//     `
//   });


import {defineComponent, ref} from 'vue'
import { formatDistance} from 'date-fns'

// const NestedComment = defineComponent({
//   props: ['reply'],
//   template: `
//     <div>
//       <div class="row" v-if="reply.replies.length > 0">
//         <div class="col-1">
//           <q-avatar icon="fa-solid fa-circle-user fa-2xl"/>
//         </div>
//         <div class="col-11">
//           <p> {{ reply.first_name }} {{ reply.last_name }} </p>
//           <p>{{ reply.text }} </p>
//         </div>
//       </div>
//       <nested-comment v-for="nestedReply in reply.replies" :reply="nestedReply" :key="getReplyKey(nestedReply)"></nested-comment>
//     </div>
//     `

// });



export default defineComponent({
  name: "PostDesign",
  props: ['data'],
 
  setup(props) {

    console.log(props.data)


    function getReplyKey(reply, replyDepth) {
      return reply && reply.id + '_' + replyDepth
    }

    let full_name = ""
    function load_name() {
    try {
      const user = props.data.user;
      if (user && typeof user.first_name === 'string' && typeof user.last_name === 'string') {
        full_name = user.first_name + ' ' + user.last_name;
      } else {
        full_name = '';
      }
    } 
    catch (err) {
      full_name = '';
    }
}

    const value = Date.now()
    const seeComments = ref(false)
    const num_replies = 0
    function datePassed() {
    //  console.log(Date.parse(props.data.created))
    //  console.log(formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true }))
        let returnDate = new Date(Date.parse(props.data.created_date))
      return  returnDate.toLocaleString()
       // return formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true })
    }

    function toggleComments(){
      seeComments.value = !seeComments.value

    }

    const replies = ref(props.data.replies || [])


    // Function to get the reply key
    function getReplyKey(reply) {
      return reply && reply.id
    }

    function getMediaURL(media){
      console.log(media.url)
      return media.url
    }

    return{
      getMediaURL,
      full_name,
      getReplyKey,
      datePassed,
      toggleComments,
      seeComments,
      slide:ref(1),
    }
  }
})
</script>



<style scoped>

/* unvisited link */
a:link {
  color: rgb(10, 10, 10);
  text-decoration: none;
}

/* visited link */
a:visited {
  color: black;
}

/* mouse over link */
a:hover {
  color: black;
}

/* selected link */
a:active {
  color: black;
}

.background{
background-color: #626262;
background-image: linear-gradient(315deg, #ffffff 0%, #ffffff 74%);

}

.postTitle{
  text-align: left;
  font: normal normal 600 30px/30px Poppins;
  letter-spacing: 0px;
  color: #4D4D4D;
  opacity: 1;
}
.dateStyle{
  text-align: right;
  font: normal normal 100 14px/9px Poppins;
  letter-spacing: 0px;
  color: #4D4D4D;
  opacity: 1;
}

.tag {
  align-self: flex-start;
  padding: .25em .75em;
  border-radius: 1em;
  
}

.tag + .tag {
  margin-left: .5em;
}

.tag-blue {
  background: var(--unnamed-color-f1faee) 0% 0% no-repeat padding-box;
  background: #F1FAEE 0% 0% no-repeat padding-box;
  border-radius: 24px;
  opacity: 1;
}

</style>
