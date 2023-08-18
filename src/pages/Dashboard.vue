<template>
  <q-page class="q-pa-sm">
    <card-social icon_position="right"/>

    <q-card class="q-mt-sm">
      <q-card-section class="text-h6 q-pb-none">
        <q-item>
          <q-item-section avatar class="">
            <q-icon color="blue" name="fas fa-chart-line" size="44px"/>
          </q-item-section>

          <q-item-section>
            <div class="text-h6">Trends</div>
          </q-item-section>
        </q-item>
      </q-card-section>
      <q-card-section class="row">
        <div class="col-lg-7 col-sm-12 col-xs-12 col-md-7">
          <!--<div class="row">
            <div class="col-lg-3 col-md-3 col-xs-6 col-sm-6">
              <q-item>
                <q-item-section top avatar>
                  <q-avatar color="blue" text-color="white" icon="bluetooth"/>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-blue text-bold">4321</q-item-label>
                  <q-item-label caption>Fashions</q-item-label>
                </q-item-section>
              </q-item>
            </div>
            <div class="col-lg-3 col-md-3 col-xs-6 col-sm-6">
              <q-item>
                <q-item-section top avatar>
                  <q-avatar color="grey-8" text-color="white" icon="bluetooth"/>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-grey-8 text-bold">9876</q-item-label>
                  <q-item-label caption>Electronics</q-item-label>
                </q-item-section>
              </q-item>
            </div>
            <div class="col-lg-3 col-md-3 col-xs-6 col-sm-6">
              <q-item>
                <q-item-section top avatar>
                  <q-avatar color="green-6" text-color="white" icon="bluetooth"/>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-green-6 text-bold">345</q-item-label>
                  <q-item-label caption>Toys</q-item-label>
                </q-item-section>
              </q-item>
            </div>
            <div class="col-lg-3 col-md-3 col-xs-6 col-sm-6">
              <q-item>
                <q-item-section top avatar>
                  <q-avatar color="orange-8" text-color="white" icon="bluetooth"/>
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-h6 text-orange-8 text-bold">1021</q-item-label>
                  <q-item-label caption>Vouchers</q-item-label>
                </q-item-section>
              </q-item>
            </div>
          </div>-->
          <div>
            <q-item>
             <q-item-section>
              <div class="text-h6">BREAKDOWN OF POST BY TOPIC THIS WEEK</div>
            </q-item-section>
          </q-item>
            <div ref="saleschart" id="saleschart" class="charts" ></div>
                       <!--<IEcharts style="height: 250px" :option="getSalesOptions" :resizable="true" />-->
          </div>
        </div>
        <q-separator vertical />
        <div class="col-lg-5 col-sm-12 col-xs-12 col-md-5">
          
          <q-item>
            <!--<q-item-section avatar class="">
              <q-icon color="blue" name="fas fa-gift" class="q-pl-md" size="24px"/>
            </q-item-section>-->

            <q-item-section>
              <div class="text-h6">BREAKDOWN OF EMERGENCIES THIS WEEK</div>
            </q-item-section>
          </q-item>
          <div>
            <div ref="linechart" id="lineChart" class="charts"></div>
            <!--            <div ref="piechart" id="piechart" style="height: 250px;"></div>
              <IEcharts style="height: 250px" :option="getPieOptions" :resizable="true" />-->
          </div>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import {defineComponent, defineAsyncComponent, ref} from 'vue'
import { api } from 'boot/axios'

export default defineComponent({
  name: "Dashboard2",
  components: {
    CardSocial: defineAsyncComponent(() => import("components/cards/CardSocial"))
  },
  setup() {

    return {
      slide: 1,
      tab: ref("contact"),
      
      // START OF BAR GRAPH
      sales_options:{
        tooltip: {
          trigger: "axis",
          axisPointer: {
            // Coordinate axis indicator, coordinate axis trigger is valid
            type: "shadow" // The default is a straight line, optional:'line' |'shadow'
          }
        },
        grid: {
          left: "2%",
          right: "2%",
          top: "4%",
          bottom: "3%",
          containLabel: true
        },
        xAxis: [
          //DATA PUSHED IN VIA METHOD
        ],
        yAxis: [
          {
            type: "value",
            splitLine: {
              show: false
            }
          }
        ],
        series: [
          //DATA PUSHED IN VIA METHOD
        ],
      },



// START OF LINE GRAPH
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
          // bottom: 10,
          //  data: ['POSTS'],
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '20%',
          top: '5%',
          containLabel: true
        },
        xAxis: [
        //DATA PUSHED IN VIA METHOD
        ],
        yAxis: [
          {
            type: 'value'
          }
        ],
         series: [
          //DATA PUSHED IN VIA METHOD
        ]
      },
      sales_chart:null,
      line_chart: null,

      getColor(val) {
        if (val > 70 && val <= 100) {
          return "green";
        } else if (val > 50 && val <= 70) {
          return "blue";
        }
        return "red";
      },
      getChipColor(status) {
        if (status == "Canceled") {
          return "negative";
        } else if (status == "Sent") {
          return "positive";
        } else if (status == "Pending") {
          return "warning";
        } else if (status == "Paid") {
          return "info";
        } else {
          return "dark";
        }
      }
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      let data = ref(null)
      let post_analytics = ref([])
      let emergency_analytics = ref([])
      
     
      let salesChart = document.getElementById('saleschart');
      echarts.dispose(salesChart);
      this.sales_chart = echarts.init(salesChart, 'light');

      let lineChart = document.getElementById('lineChart');
      echarts.dispose(lineChart);
      let theme = this.model ? 'dark' : 'light';
      this.line_chart = echarts.init(lineChart, theme);

      let url = process.env.ADMIN_API_URL+"/dashboard"
        api.get(url,{
        method: 'GET',
        headers: {
          Authorization:'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
    })
    .then((response) => { 

      data.value = response.data   


      //LOADING BAR CHART DATA
      post_analytics=data.value.weekly_post_analytics

      let num_posts = Object.values(post_analytics)
      let topic_names = Object.keys(post_analytics)

      let topics_series = {
        name: "POSTS",
        type: "bar",
        data: num_posts,
        color: "#546bfa" 
      }
      let topics_xAxis = {
            type: 'category',
            data: topic_names
      }

      this.sales_options.series.push(topics_series);
      this.sales_options.xAxis.push(topics_xAxis);

      //LOADING LINE GRAPH DATA
      emergency_analytics=data.value.weekly_emergency_analytics

      let num_emergencies = Object.values(emergency_analytics)
      let emergency_names = Object.keys(emergency_analytics)
      
      let emergencies_xAxis = {
          type: 'category',
          boundaryGap: false,
          data: emergency_names
      }

      let emergencies_series = {
            name: 'ODPM',
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
            data: num_emergencies
      }

      this.options.xAxis.push(emergencies_xAxis);
      this.options.series.push(emergencies_series);

      this.sales_chart.setOption(this.sales_options);
      this.line_chart.setOption(this.options)
    })
  },

    onResize() {
      if (this.sales_chart) {
        this.sales_chart.resize();
      }
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
    height: 300px;
  }
  </style>
