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
    name: 'name',
    required: true,
    label: 'Dessert (100g serving)',
    align: 'left',
    field: row => row.name,
    format: val => `${val}`,
    sortable: true
  },
  { name: 'calories', align: 'center', label: 'Calories', field: 'calories', sortable: true },
  { name: 'fat', label: 'Fat (g)', field: 'fat', sortable: true },
  { name: 'carbs', label: 'Carbs (g)', field: 'carbs' },
  { name: 'protein', label: 'Protein (g)', field: 'protein' },
  { name: 'sodium', label: 'Sodium (mg)', field: 'sodium' },
  { name: 'calcium', label: 'Calcium (%)', field: 'calcium', sortable: true, sort: (a, b) => parseInt(a, 10) - parseInt(b, 10) },
  { name: 'iron', label: 'Iron (%)', field: 'iron', sortable: true, sort: (a, b) => parseInt(a, 10) - parseInt(b, 10) }
]

const rows = [
  {
    name: 'Frozen Yogurt',
    calories: 159,
    fat: 6.0,
    carbs: 24,
    protein: 4.0,
    sodium: 87,
    calcium: '14%',
    iron: '1%'
  },
  {
    name: 'Ice cream sandwich',
    calories: 237,
    fat: 9.0,
    carbs: 37,
    protein: 4.3,
    sodium: 129,
    calcium: '8%',
    iron: '1%'
  },
  {
    name: 'Eclair',
    calories: 262,
    fat: 16.0,
    carbs: 23,
    protein: 6.0,
    sodium: 337,
    calcium: '6%',
    iron: '7%'
  },
  {
    name: 'Cupcake',
    calories: 305,
    fat: 3.7,
    carbs: 67,
    protein: 4.3,
    sodium: 413,
    calcium: '3%',
    iron: '8%'
  },
  {
    name: 'Gingerbread',
    calories: 356,
    fat: 16.0,
    carbs: 49,
    protein: 3.9,
    sodium: 327,
    calcium: '7%',
    iron: '16%'
  },
  {
    name: 'Jelly bean',
    calories: 375,
    fat: 0.0,
    carbs: 94,
    protein: 0.0,
    sodium: 50,
    calcium: '0%',
    iron: '0%'
  },
  {
    name: 'Lollipop',
    calories: 392,
    fat: 0.2,
    carbs: 98,
    protein: 0,
    sodium: 38,
    calcium: '0%',
    iron: '2%'
  },
  {
    name: 'Honeycomb',
    calories: 408,
    fat: 3.2,
    carbs: 87,
    protein: 6.5,
    sodium: 562,
    calcium: '0%',
    iron: '45%'
  },
  {
    name: 'Donut',
    calories: 452,
    fat: 25.0,
    carbs: 51,
    protein: 4.9,
    sodium: 326,
    calcium: '2%',
    iron: '22%'
  },
  {
    name: 'KitKat',
    calories: 518,
    fat: 26.0,
    carbs: 65,
    protein: 7,
    sodium: 54,
    calcium: '12%',
    iron: '6%'
  }
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
     const columns = [
  {
    name: 'name',
    required: true,
    label: 'Dessert (100g serving)',
    align: 'left',
    style: 'width: 500px',
    field: row => row.name,
    format: val => `${val}`,
    sortable: true
  },
  { name: 'Title', align: 'center', label: 'Broadcast Title', field: 'Title', sortable: true },
  { name: 'Date', label: 'Date', field: 'Date', sortable: true },
  { name: 'carbs', label: 'Carbs (g)', field: 'carbs' },
  { name: 'protein', label: 'Protein (g)', field: 'protein' },
  { name: 'sodium', label: 'Sodium (mg)', field: 'sodium' },
  { name: 'calcium', label: 'Calcium (%)', field: 'calcium', sortable: true, sort: (a, b) => parseInt(a, 10) - parseInt(b, 10) },
  { name: 'iron', label: 'Iron (%)', field: 'iron', sortable: true, sort: (a, b) => parseInt(a, 10) - parseInt(b, 10) }
]

const rows = [
  {
    name: 'Frozen Yogurt',
    calories: 159,
    fat: 6.0,
    carbs: 24,
    protein: 4.0,
    sodium: 87,
    calcium: '14%',
    iron: '1%'
  },
  {
    name: 'Ice cream sandwich',
    calories: 237,
    fat: 9.0,
    carbs: 37,
    protein: 4.3,
    sodium: 129,
    calcium: '8%',
    iron: '1%'
  },
  {
    name: 'Eclair',
    calories: 262,
    fat: 16.0,
    carbs: 23,
    protein: 6.0,
    sodium: 337,
    calcium: '6%',
    iron: '7%'
  },
  {
    name: 'Cupcake',
    calories: 305,
    fat: 3.7,
    carbs: 67,
    protein: 4.3,
    sodium: 413,
    calcium: '3%',
    iron: '8%'
  },
  {
    name: 'Gingerbread',
    calories: 356,
    fat: 16.0,
    carbs: 49,
    protein: 3.9,
    sodium: 327,
    calcium: '7%',
    iron: '16%'
  },
  {
    name: 'Jelly bean',
    calories: 375,
    fat: 0.0,
    carbs: 94,
    protein: 0.0,
    sodium: 50,
    calcium: '0%',
    iron: '0%'
  },
  {
    name: 'Lollipop',
    calories: 392,
    fat: 0.2,
    carbs: 98,
    protein: 0,
    sodium: 38,
    calcium: '0%',
    iron: '2%'
  },
  {
    name: 'Honeycomb',
    calories: 408,
    fat: 3.2,
    carbs: 87,
    protein: 6.5,
    sodium: 562,
    calcium: '0%',
    iron: '45%'
  },
  {
    name: 'Donut',
    calories: 452,
    fat: 25.0,
    carbs: 51,
    protein: 4.9,
    sodium: 326,
    calcium: '2%',
    iron: '22%'
  },
  {
    name: 'KitKat',
    calories: 518,
    fat: 26.0,
    carbs: 65,
    protein: 7,
    sodium: 54,
    calcium: '12%',
    iron: '6%'
  }
]
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