<template>
  <div >
    <div :style="indent" @click="toggleChildren" id="rcorners3">
      {{ label }}
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
      return { showChildren: false }
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
      }
    },

    setup(props) {
      console.log(props.nodes)
      
    }

  }
</script>
<style>
#rcorners3 {
  margin-bottom: 10px;
  width: fit-content;
  height: fit-content;
  border: 2px solid #ADD8E6;
  border-radius: 12px;
  padding: 5px;

}
</style>