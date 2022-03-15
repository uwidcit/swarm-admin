<template>
    <post-details/>
</template>

<script>

import PostDetails from 'src/components/PostDetails.vue'

import {defineComponent,defineAsyncComponent} from 'vue'

export default defineComponent({
  name: 'Details',
  components: {
    PostDetails
  
}
})
</script>

<style>

</style>