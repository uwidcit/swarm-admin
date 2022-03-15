<template>
  <q-page class="q-pa-sm">

    <post-board/>

    <card-social icon_position="left"/>

    <card-charts/>

    <div class="row q-col-gutter-sm  q-py-sm">
      <tab-social/>
      <card-with-image/>
    </div>

    <div class="row q-col-gutter-sm  q-pb-sm">
      <todo-list/>

      <card-time-line/>
    </div>

    <table-visits/>
  </q-page>
</template>

<script>
import {defineComponent,defineAsyncComponent} from 'vue'

export default defineComponent({
  name: 'PageIndex',
  components: {

    PostBoard: defineAsyncComponent(() => import('components/PostBoard')),
   
  },
  setup() {
    return {
      mode: 'list',
      
    }
  },

})
</script>
