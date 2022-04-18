<template>
  <div >
    <div class="q-mr-sm box_comment" :style="indent" @click="toggleChildren" id="rcorners3" >
      <div class="row justify-center">
      <div class="col">
         <q-avatar >
              <img src="https://cdn.quasar.dev/img/boy-avatar.png">
            </q-avatar>
       {{ label }}
      </div>
      
      <div class="col-1">
      
    </div>

     <div class="col-2">
        {{datePassed(date)}}
        <q-btn @click.prevent flat round color="grey" icon="more_vert" size="sm" />
          <q-menu>
            <q-list style="min-width: 100px">
            <q-item clickable v-close-popup>
              <q-btn @click.prevent flat round color="grey" icon="fas fa-comments" size="sm" label="View More Comments" />
            </q-item>
            <q-item clickable v-close-popup>
              <q-btn @click.prevent.stop flat round icon="fas fa-plus-circle"   @click="toggleReplies()" label="Add A Reply"/>
            </q-item>
            </q-list>
          </q-menu>
      </div>
    </div> 
  </div>

      <div  class="q-pa-sm" v-if="createReply" id="newreply" :style="indent" :depth="depth + 1" style="min-width: 250px; max-width: 900px">
        <q-input  placeholder="Add comment..." v-model="text" counter maxlength="260" autogrow :dense="dense">
        <template v-slot:after>
          <q-btn round dense flat icon="send" @click="createNewComment(text)" />
          <q-btn round dense flat icon="cancel" @click="text='', createReply=false" />
        </template>
        </q-input>

      </div>


    <comments
      v-if="showChildren"
      v-for="(node, index) in nodes" 
      :key="index"
      :nodes="node.replies" 
      :label="node.text"
      :depth="depth + 1"
      :id="node.id"
      :topic="node.topicId" 
      :date="node.created"
    >
    </comments>
  </div>
</template>


<script>
import {ref, inject} from 'vue';
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import { formatDistance} from 'date-fns'

  export default { 

    props: [ 'label', 'nodes', 'depth', 'id', 'topic', 'date' ],
   
    data() {
      return { 
        showChildren: false,
        createReply: false
       }
    },
    name: 'comments',
    computed: {
      indent() {
        return { transform: `translate(${this.depth * 30}px)` }
      }
    },
    methods: {
      toggleChildren() {
        this.showChildren = !this.showChildren;
        console.log(this.showChildren.valueOf(this.showChildren))
      },
      toggleReplies() {
        this.createReply = !this.createReply;
        console.log(this.createReply.valueOf(this.createReply))
      }
    },

    setup(props) {
      const text = ref('')
      const $q = useQuasar()

      function datePassed(time) {
      console.log(Date.parse(time))
      console.log(formatDistance(Date.parse(time), new Date(), { addSuffix: true }))
        return formatDistance(Date.parse(time), new Date(), { addSuffix: true })
    }
      
      function createNewComment(message){
        console.log("creating new comment")
        console.log(message)

      api.post("https://swarmnet-prod.herokuapp.com/replies", {
          "topic_id": props.topic,
          "text": message,
          "replyTo": props.id,
          "tags": [],
          "composed": "2011-10-10T14:48:00Z"
        },{
          headers: {
            Authorization:'JWT '+ localStorage.getItem('token'),
            'Access-Control-Allow-Origin': '*'   
          }
          }).then((response) => {
            if(response.status == 200){
              showChildren = true

              // notify user 
              $q.notify({
              type: 'positive',
              message: 'COMMENT POSTED'
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
     
    })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Incorrect e-mail or password!',
              icon: 'report_problem'
            })
          })
       
      
           
      }

    return{
      createNewComment,
      text,
      datePassed
    }

  }
  }
</script>
<style>
.box_comment{
	display: block;
    position: relative;
    line-height: 1.358;
    word-break: break-word;
    border: 1px solid #d3d6db;
    word-wrap: break-word;
    background: #fff;
    box-sizing: border-box;
    cursor: text;
    font-family: Helvetica, Arial, sans-serif;
    font-size: 16px;
	  padding: 0;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
}


#rcorners3 {


  display:block;
  position: relative; 
 
  padding:0;
  border-width:0;
  border: 2px solid Gainsboro;
  border-radius: 12px;
  box-sizing: border-box;
  width: calc(100% - 5%);


}
#newreply {
  background-color: Gainsboro;
  margin-bottom: 10px;
  height: fit-content;
  border: 2px solid Gainsboro;
  border-radius: 12px;
  padding: 5px;
  position: relative;
  left: 40px;
}

</style>
