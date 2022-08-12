<template>
  <div>
    
    <q-card>
      <q-card-section class="text-h6">
       Broadcast
       <div class="q-gutter-md row float-right items-start">
       <q-input  v-model="date1" filled type="date" hint="Start Date" />
       <q-input  v-model="date2" filled type="date" hint="End Date" />
        <q-btn color="orange" icon="fa fa-download" class="float-right" @click="SaveImage" flat dense>
          <q-tooltip>Download Chart</q-tooltip>
        </q-btn>
       </div>
      </q-card-section>
      <q-card-section>
        <card-broadcast icon_position="right"/>
        </q-card-section>
      <q-card-section>
         <canvas id="myChart" class="charts"></canvas>
      </q-card-section>
       
       <q-separator />
          
       <q-card-section>
          <div class="q-pa-md">
          <q-table
            title="Treats"
            :rows="rows"
            :columns="columns"
            row-key="name"
          />
        </div>
        </q-card-section>
    </q-card>
    <q-resize-observer @resize="onResize"/>
  </div>
</template>
 
<script>
import {defineComponent, defineAsyncComponent} from 'vue';
import {ref} from 'vue';
import { api } from 'boot/axios'
import {
  Chart,
  ArcElement,
  LineElement,
  BarElement,
  PointElement,
  BarController,
  BubbleController,
  DoughnutController,
  LineController,
  PieController,
  PolarAreaController,
  RadarController,
  ScatterController,
  CategoryScale,
  LinearScale,
  LogarithmicScale,
  RadialLinearScale,
  TimeScale,
  TimeSeriesScale,
  Decimation,
  Filler,
  Legend,
  Title,
  Tooltip,
  SubTitle
} from 'chart.js';
import axios from 'axios';
import { useQuasar } from 'quasar'
export default defineComponent({
  name: "BroadcastChart",
   components: {
    CardBroadcast: defineAsyncComponent(() => import("components/cards/CardBroadcast"))
  },
  
 
   
  
  mounted() {
    this.init();
  },
    watch: {
    '$q.dark.isActive': function () {
      this.init();
    }
  },
  setup ()  {
     const columns = [
  {
    name: 'Title',
    required: true,
    label: 'Broadcast Title',
    align: 'left',
    style: 'width: 200px',
    field: row => row.Title,
    format: val => `${val}`,
    sortable: true
  },
  { name: 'Date', label: 'Date', field: 'Date', sortable: true },
]

const rows = [
  {
    Title: 'Broadcast 1',
    Date: "15/9/2022",
  },
   {
    Title: 'Broadcast 2',
    Date: "15/9/2022",
  },
]
    
    function SaveImage() {
      const linkSource = this.line_chart.getDataURL();
      const downloadLink = document.createElement('a');
      document.body.appendChild(downloadLink);
      downloadLink.href = linkSource;
      downloadLink.target = '_self';
      downloadLink.download = 'EmergenciesReport.png';
      downloadLink.click();
    }
    
     function init() {
     let data = ref(null)

     Chart.register(
  ArcElement,
  LineElement,
  BarElement,
  PointElement,
  BarController,
  BubbleController,
  DoughnutController,
  LineController,
  PieController,
  PolarAreaController,
  RadarController,
  ScatterController,
  CategoryScale,
  LinearScale,
  LogarithmicScale,
  RadialLinearScale,
  TimeScale,
  TimeSeriesScale,
  Decimation,
  Filler,
  Legend,
  Title,
  Tooltip,
  SubTitle
);
     const ctx = document.getElementById('myChart');
     const DATA_COUNT = 5;
const NUMBER_CFG = {count: DATA_COUNT, min: 0, max: 100};

const stuff = {
  labels: ['Delivered', 'Not Delivered'],
  datasets: [
    {
      label: 'Dataset 1',
      data: [1,2],
      backgroundColor: [ 'grey','#7797D9'],
               
    }
  ]
};
    const myChart = new Chart(ctx, {
    type: 'pie',
  data: stuff,
  options: {
    responsive: false,
    plugins: {
      legend: {
        position: 'bottom',
      },
      title: {
        display: true,
        text: 'Broadcast Chart'
      }
    }
  },
});

     /* let pieChart = document.getElementById('pieChart');
      echarts.dispose(pieChart);
      let theme = this.model ? 'dark' : 'light';
      this.pie_chart = echarts.init(pieChart, theme);
      this.pie_chart.setOption(this.options)*/

      //var x = localStorage.getItem("username");
      //console.log(x)

      let url ="https://swarmnet.sundaebytes.com/api/admin/dashboard"
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
      
     

    })
    
  console.log(rows)
     }
    return {
      rows,columns,
      date1:ref(""),
      date2:ref(""),
      model: ref(false),
      init,SaveImage
    }
    },
     mounted() {
    this.init();
  },
    onResize() {
       if (this.pie_chart) {
        this.pie_chart.resize();
      }
    }
  
})
</script>

<style scoped>
.charts {
    width: 300px;
    height: 300px;
  }
</style>