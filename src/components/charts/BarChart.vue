<template>
  <div>
    <q-card>
      <q-card-section class="text-h6">
       BAR CHART SHOWING NUMBER OF POST UNDER EACH TOPIC
        <q-btn icon="fa fa-download" class="float-right" @click="SaveImage" flat dense>
          <q-tooltip>Download PNG</q-tooltip>
        </q-btn>
      </q-card-section>
      <q-card-section>
        <div ref="barchart" id="barChart" style="height: 300px;"></div>
      </q-card-section>
    </q-card>
    <q-resize-observer @resize="onResize"/>
  </div>
</template>

<script>
import {defineComponent} from 'vue';
import {ref} from 'vue';
import { api } from 'boot/axios'
import axios from 'axios';
import { useQuasar } from 'quasar'
export default defineComponent({
  name: "BarChart",
  
 
  setup() {
    return {
      model: ref(false),
      options: {
        legend: {
          bottom: 10,
        },
        tooltip: {},
        dataset: {
          source: [
           // ['tOPICS', '2015'],
           // ['Fire', 43.3],
           // ['Flood', 83.1],
           // ['Volcanic', 86.4],
           // ['Hurricane', 72.4]
          ]
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '5%',
          top: '5%',
          containLabel: true
        },
        xAxis: {type: 'category'},
        yAxis: {},
        // Declare several bar series, each will be mapped
        // to a column of dataset.source by default.
        series: [
          {type: 'bar'}
        ]
      },
      bar_chart: ref(null),
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    
    SaveImage() {
      const linkSource = this.bar_chart.getDataURL();
      const downloadLink = document.createElement('a');
      document.body.appendChild(downloadLink);
      downloadLink.href = linkSource;
      downloadLink.target = '_self';
      downloadLink.download = 'BarChart.png';
      downloadLink.click();
    },
    
     init() {
      let barChart = document.getElementById('barChart');
      this.bar_chart = echarts.init(barChart,'light');
       const topics = ref([])
       const data = ref(null)
       const posts = ref([])
         const posTags = ref([])
       var a= []
       var b
         api.get(process.env.ADMIN_API_URL+'/topics',{
  method: 'GET',
  
  headers: {
         
          'Access-Control-Allow-Origin': '*'
          
        }
    })
    .then((response) => { 
        data.value = response.data //topicscollected from api
        for (let i of data.value) { 
          topics.value.push(i) //add topic to topics object array
        }
var counter =[]
var a=0
 let url = process.env.ADMIN_API_URL+"/posts"
      api.get(url,{
      method: 'GET',
      headers: {
              'Access-Control-Allow-Origin': '*'
            }
        })
      .then((response) => {//Get post from API
        data.value = response.data
        var size2=0
        for (let j of data.value) { 
          posts.value.push(j)  
          size2++
          
        }
        let size=Object.keys(topics.value).length
        
        console.log(posts.value)
        for (let m=0;m<size;m++){
        var count=0
        
        for (let n=0;n<size2;n++){
            if(posts.value[n].topicId==topics.value[m].id){
              count++
            }
        }
        b=[topics.value[m].text,count]
        this.options.dataset.source.push(b);
        this.bar_chart.setOption(this.options)//add topic and post numberto bar chart
        }
      })
      .catch(() => {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: 'Loading failed',
          icon: 'report_problem'
        })
      })
   
      })
      .catch(() => {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: 'Loading failed',
          icon: 'report_problem'
        })
      })
    },
     mounted() {
   // this.init();
  },
    onResize() {
      if (this.bar_chart) {
        this.bar_chart.resize();
      }
    }
  }
})
</script>

<style scoped>
</style>