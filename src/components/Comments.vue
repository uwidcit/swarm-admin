<template>
  <div >
    <div class="q-mr-sm " :style="indent" @click="toggleChildren" id="rcorners3">
      
      <span>
        <q-avatar>
              <img src="https://cdn.quasar.dev/img/boy-avatar.png">
            </q-avatar>
            {{ label }}
      </span>
      
          <span style="postiton: right">
            <q-btn @click.prevent flat round color="grey" icon="fas fa-comments" size="sm"/>
            <q-btn @click.prevent.stop flat round icon="fas fa-plus-circle"   @click="toggleReplies(), createNewComment()" />
          </span>
      </div>

      <div v-if="createReply" id="newreply" :style="indent" :depth="depth + 1">
        <q-input  placeholder="Add comment..." v-model="text" counter maxlength="260" autogrow :dense="dense">
        <template v-slot:after>
          <q-btn round dense flat icon="send" />
        </template>
        </q-input>
      </div>


    <comments
      v-if="showChildren"
      v-for="(node, index) in nodes" 
      :key="index"
      :nodes="node.nodes" 
      :label="node.text"
      :depth="depth + 1"
    >
    </comments>
  </div>
</template>


<script>

  export default { 

    props: [ 'label', 'nodes', 'depth' ],
   
    data() {
      return { 
        showChildren: false,
        createReply: false
       }
    },
    name: 'comments',
    computed: {
      indent() {
        return { transform: `translate(${this.depth * 50}px)` }
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
      
      function createNewComment(){
        console.log("creating new comment")
        
      }

    return{
      createNewComment,
    }

  }
  }
</script>
<style>
#rcorners3 {
  margin-bottom: 10px;
  width: 90%;
  height: fit-content;
 background-color:#ADD8E6;
  border-radius: 12px;
  margin-right: 10px;

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