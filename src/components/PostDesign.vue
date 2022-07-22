<template>
  <q-card class="my-card background">
     <a :href="`/Details/${data.id}`">
    <q-card-section square=true>
      <div class="row q-gutter-none q-pa-md q-ma-xs">
        <div class="col-4 text-p postTitle">{{data.title}}</div>
      <div class="col-4 text-p dateStyle">
            <p> {{datePassed()}} </p>
      </div>
         <!--<div class="col text-subtitle1 text-justify q-mt-sm">
          {{datePassed()}}
        </div>-->
         <div class="col-4 text-p">
            <span class="tag tag-blue"
                  v-for="(tag,index) in data.tags" :key="tag">             
                    {{tag.tag_text}}    
         </span>
          </div>
      </div>
    <div class="q-pa-md">
         <div class="row">
         <!-- <div class="col">
            <q-avatar>
              <img src="https://cdn.quasar.dev/img/boy-avatar.png">
            </q-avatar>
          </div> -->

          <div class="col-9 text-p">
           {{ data.text }}
          </div>

         
        </div>
        
        </div>

         <div class="row">
          <div class="col">
            <q-carousel
                animated
                v-model="slide"
                arrows
                navigation
                infinite
                >
                  <q-carousel-slide :name="1" img-src="https://cdn.quasar.dev/img/mountains.jpg" />
                  <q-carousel-slide :name="2" img-src="https://cdn.quasar.dev/img/parallax1.jpg" />
                  <q-carousel-slide :name="3" img-src="https://cdn.quasar.dev/img/parallax2.jpg" />
                  <q-carousel-slide :name="4" img-src="https://cdn.quasar.dev/img/quasar.jpg" />
              </q-carousel>
          </div>
         
          </div>

    </q-card-section>
     <q-card-actions>
           <q-btn flat> Likes 496 </q-btn>
            <q-btn flat> Comments: 210 </q-btn>
            <q-btn flat> Share</q-btn>
          </q-card-actions>
    </a>
  </q-card>
</template>

<script>
import {defineComponent, ref} from 'vue'
import { formatDistance} from 'date-fns'

export default defineComponent({
  name: "PostDesign",

  props: ['data'],

 
  setup(props) {
    const value = Date.now()
    function datePassed() {
    //  console.log(Date.parse(props.data.created))
    //  console.log(formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true }))
        let returnDate = new Date(Date.parse(props.data.created_date))
      return  returnDate.toLocaleString()
       // return formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true })
    }

    return{
      datePassed,
      slide:ref(1),
    }
  }
})
</script>

<style scoped>

/* unvisited link */
a:link {
  color: rgb(10, 10, 10);
  text-decoration: none;
}

/* visited link */
a:visited {
  color: black;
}

/* mouse over link */
a:hover {
  color: black;
}

/* selected link */
a:active {
  color: black;
}

.background{
background-color: #626262;
background-image: linear-gradient(315deg, #ffffff 0%, #ffffff 74%);

}

.postTitle{
  text-align: left;
  font: normal normal 600 30px/46px Poppins;
  letter-spacing: 0px;
  color: #4D4D4D;
  opacity: 1;
}
.dateStyle{
  text-align: left;
  font: normal normal 300 20px/30px Poppins;
  letter-spacing: 0px;
  color: #4D4D4D;
  opacity: 1;
}

.tag {
  align-self: flex-start;
  padding: .25em .75em;
  border-radius: 1em;
  
}

.tag + .tag {
  margin-left: .5em;
}

.tag-blue {
  background: var(--unnamed-color-f1faee) 0% 0% no-repeat padding-box;
  background: #F1FAEE 0% 0% no-repeat padding-box;
  border-radius: 24px;
  opacity: 1;
}

</style>
