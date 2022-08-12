<template>
  <div>
    <q-card>
      <q-card-section class="text-h6">
        <!--<q-date v-model="rangeDate" range landscape color="orange" />-->
      Active Users
      <div class="q-gutter-md row float-right items-start">
       <q-input  v-model="date1" filled type="date" hint="Start Date" />
       <q-input  v-model="date2" filled type="date" hint="End Date" />
         <q-btn style = "color:orange " icon="fa fa-download" class="float-right" @click="SaveImage" flat dense>
          <q-tooltip>Download Chart</q-tooltip>
        </q-btn>
      </div>
      </q-card-section>
     <q-separator vertical />
      <q-card-section>
        <div ref="linechart" id="lineChart" class="charts"></div>
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
  name: "ActiveUser",
  
 
  setup() {
    return {
       //rangeDate: ref(""),
       date2: ref(''),
       date1: ref(''),
      model: ref(false),
      options: {
        color: ['#80FFA5', '#00DDFF', '#37A2FF', '#FF0087', '#FFBF00'],
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#6a7985'
            }
          }
        },
        legend: {
         // data: ['ODPM', 'FLOOD', 'HURRICANE', 'EARTHQUAKE', 'LANDSLIDES','CYCLONES'],
          bottom: 10,
           data: ['POST'],
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '20%',
          top: '5%',
          containLabel: true
        },
        xAxis: [
          {
            type: 'category',
            boundaryGap: false,
            data: ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
          }
        ],
        yAxis: [
          {
            type: 'value'
          }
        ],
         series: [
          {
            name: 'Active Users',
            type: 'line',
            stack: 'Total',
            smooth: true,
            lineStyle: {
              width: 0
            },
            showSymbol: false,
            areaStyle: {
              opacity: 0.8,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(128, 255, 165)'
              }, {
                offset: 1,
                color: 'rgba(1, 191, 236)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [3000, 2700, 900, 1400, 8700, 6000, 2000]
          },
        ]
      },
      line_chart: null,
    }
  },
  mounted() {
    this.init();
  }, 
  methods: {
    
    SaveImage() {
      const linkSource = this.line_chart.getDataURL();
      const downloadLink = document.createElement('a');
      document.body.appendChild(downloadLink);
      downloadLink.href = linkSource;
      downloadLink.target = '_self';
      downloadLink.download = 'ActiveUsersGraph.png';
      downloadLink.click();
    },
    
     init() {
     let data = ref(null)
      let post = ref([])
     
    

      let lineChart = document.getElementById('lineChart');
      echarts.dispose(lineChart);
      let theme = this.model ? 'dark' : 'light';
      this.line_chart = echarts.init(lineChart, theme);

      //var x = localStorage.getItem("username");
      //console.log(x)

      let url =process.env.ADMIN_API_URL+"/dashboard"
        api.get(url,{
        method: 'GET',
        headers: {
          Authorization:'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
    })
    .then((response) => { 
      data.value = response.data 
     // console.log(response.data)
    post=data.value.weekly_post_analytics
      
      this.line_chart.setOption(this.options)

    })
    },
     mounted() {
   // this.init();
  },
    onResize() {
       if (this.line_chart) {
        this.line_chart.resize();
      }
    }
  }
})
</script>

<style scoped>
.charts {
    width: 1000px;
    height: 500px;
  }
</style>