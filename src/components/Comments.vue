<template>
  <div v-cloak >
    <div class="q-mr-sm box_comment" :style="indent" id="rcorners3" >
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
      </div> 
    </div>
     <span  class="q-ml-xl" v-if="nodes.length != 0 && showChildren==false">
         <a @click="toggleChildren" > View {{nodes.length}} more reply </a>
      </span>
      <span  class="q-ml-xl" v-if="nodes.length != 0 && showChildren==true" style="position=right">
         <a @click="toggleChildren" > View less replies </a>
      </span>
  </div>

    <div class="row">
      <div class="col">  
    </div>
    <div class="col-1">
      <a  @click="toggleReplies()" > Reply </a>  
    </div>
    </div>

      <div  v-if="createReply" id="newreply" :style="indent" :depth="depth + 1" >
        <q-input  placeholder="Add comment..." v-model="text" counter maxlength="260" autogrow :dense="dense">
        <template v-slot:after>
          <q-btn round dense flat icon="send" @click="createNewComment(text)" />
          <q-btn round dense flat icon="cancel" @click="text='', createReply=false" />
        </template>
        </q-input>

      </div>

    <div v-if="showChildren">
      <comments
        v-for="(node, index) in nodes" 
        :key="index"
        :nodes="node.replies" 
        :label="node.text"
        :depth="depth + 1"
        :id="node.id"
        :topic="1" 
        :date="node.created_date"
      >
      </comments>
    </div>
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
        showChildren: ref(false),
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
      // console.log(Date.parse(time))
      // console.log(formatDistance(Date.parse(time), new Date(), { addSuffix: true }))
        return formatDistance(Date.parse(time), new Date(), { addSuffix: true })
    }
      
      function createNewComment(message){
        console.log("creating new comment")
        console.log(message)
        api.post(process.env.BASE_URL+"/replies", {
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
            if(response.status == 201){
              
              // notify user 
              $q.notify({
                colour:'purple',
                type: 'positive',
                message: 'REPLY POSTED'
            })
            }
  
    })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Could not create reply',
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

  border: 2px solid Gainsboro;
  border-radius: 12px;
  padding: 5px;
  position: relative;
  left: 40px;
  width: calc(100% - 10%);
}

</style>