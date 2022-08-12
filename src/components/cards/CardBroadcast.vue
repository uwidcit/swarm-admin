<template>
  <q-card class="bg-transparent no-shadow no-border">
    <q-card-section class="q-pa-none">
      <div class="row q-col-gutter-sm ">
        <div v-for="item in items" :key="item.title" class="col-md-4 col-sm-12 col-xs-12">
          <q-item :style="`background-color: ${item.color1}`" class="q-pa-none">
            <q-item-section class=" q-pa-md q-ml-none  text-white">
              <q-item-label class="text-white text-h6 text-weight-bolder">{{ item.value }}</q-item-label>
              <q-item-label>{{ item.title }}</q-item-label>
            </q-item-section>
            <q-item-section  side class="q-mr-md text-white">
              <q-icon :name="item.icon" color="white" size="44px"></q-icon>
            </q-item-section>
          </q-item>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import {defineComponent, ref, onMounted} from 'vue'
import { api } from 'boot/axios'
import { useQuasar,Notify } from 'quasar'

export default defineComponent({
  name: "CardBroadcast",
  props: {
    icon_position: {
      required: false,
      default: "left"
    }
  },
  
   
   setup(){
    let post = ref([])
    let message = ref([])
    let emergency = ref([])
    const $q = useQuasar()
    let data = ref(null)
    const items = ref([])
    
    function init(){
      
      let url ="https://swarmnet.sundaebytes.com/api/admin/dashboard"
       api.get(url,{
  method: 'GET',
  headers: {
          Authorization:'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
    })
    .then((response) => { 
      
      data.value = response.data //data collected from api
      post=response.data.post_analytics
      emergency=response.data.emergency_analytics
      message=response.data.message_analytics

     items.value = ([
      {
            title: "Broadcast",
            icon: "fa-solid fa-podcast",
            value: post.number,
            color1: "#546bfa",
            color2: "#3e51b5",
          },
     ])
    
     console.log(items)
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
     onMounted (() =>{
      init();
   }) 
     return{
      post,init,items,emergency,message
    }
   },
})
</script>
