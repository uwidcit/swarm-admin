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
          {
            type: "category",
            data: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
          }
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
          /*{
            name: "POST",
            type: "bar",
            data: [40, 45, 27, 50, 32, 50, 70, 30, 30, 40, 67, 29],
            color: "#546bfa"
          },
          {
            name: "FLOOD",
            type: "bar",
            data: [124, 100, 20, 120, 117, 70, 110, 90, 50, 90, 20, 50],
            color: "#3a9688"
          },
          {
            name: "HURRICANE",
            type: "bar",
            data: [17, 2, 0, 29, 20, 10, 23, 0, 8, 20, 11, 30],
            color: "#02a9f4"
          },
          {
            name: "EARTHQUAKE",
            type: "bar",
            data: [20, 99, 80, 14, 90, 86, 100, 70, 120, 50, 30, 90],
            color: "#f88c2b"
          },
          {
            name: "LANDSLIDES",
            type: "bar",
            data: [20, 15, 80, 14, 22, 86, 43, 70, 100, 50, 30, 60],
            color: "#109D9B"
          },
          {
            name: "CYCLONE",
            type: "bar",
            data: [50, 100, 80, 14, 47, 86, 100, 70, 72, 50, 90, 60],
            color: "#FCF50D"
          }*/
        ],
      },
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
            data: [3000, 2700, 900, 1400, 8700, 6000, 2000]
          },
          /*{
            name: 'FLOOD',
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
                color: 'rgba(0, 221, 255)'
              }, {
                offset: 1,
                color: 'rgba(77, 119, 255)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [120, 282, 111, 234, 220, 340, 310]
          },
          {
            name: 'FLOOD',
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
                color: 'rgba(0, 221, 255)'
              }, {
                offset: 1,
                color: 'rgba(77, 119, 255)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [120, 282, 111, 234, 220, 340, 310]
          },
          {
            name: 'HURRICANE',
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
                color: 'rgba(0, 221, 255)'
              }, {
                offset: 1,
                color: 'rgba(77, 119, 255)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [111, 232, 122, 234, 220, 121, 210]
          },
          
          {
            name: 'EARTHQUAKE',
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
                color: 'rgba(55, 162, 255)'
              }, {
                offset: 1,
                color: 'rgba(116, 21, 219)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [320, 132, 201, 334, 190, 130, 220]
          },
          {
            name: 'LANDSLIDES',
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
                color: 'rgba(255, 0, 135)'
              }, {
                offset: 1,
                color: 'rgba(135, 0, 157)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [220, 402, 231, 134, 190, 230, 120]
          },
          {
            name: 'CYCLONES',
            type: 'line',
            stack: 'Total',
            smooth: true,
            lineStyle: {
              width: 0
            },
            showSymbol: false,
            label: {
              show: true,
              position: 'top'
            },
            areaStyle: {
              opacity: 0.8,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(255, 191, 0)'
              }, {
                offset: 1,
                color: 'rgba(224, 62, 76)'
              }])
            },
            emphasis: {
              focus: 'series'
            },
            data: [220, 302, 181, 234, 210, 290, 150]
          }*/
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
    init() {
      let data = ref(null)
      let post = ref([])
     
      let salesChart = document.getElementById('saleschart');
      echarts.dispose(salesChart);
      this.sales_chart = echarts.init(salesChart, 'light');

      let lineChart = document.getElementById('lineChart');
      echarts.dispose(lineChart);
      let theme = this.model ? 'dark' : 'light';
      this.line_chart = echarts.init(lineChart, theme);

      //var x = localStorage.getItem("username");
      //console.log(x)

      let url = process.env.BASE_URL+"/api/admin/dashboard"
        api.get(url,{
        method: 'GET',
        headers: {
          Authorization:'Bearer '+ localStorage.getItem('token'),
          'Access-Control-Allow-Origin': '*'
        }
    })
    .then((response) => { 
      data.value = response.data   
     
    post=data.value.weekly_post_analytics
       //console.log(post)
      let data2={
        name: "POST",
            type: "bar",
            data: [3000, 2700, 900, 1400, 8700, 6000, 2000],
            color: "#546bfa"
      }
       this.sales_options.series.push(data2);
      //console.log(this.sales_options.series)
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
