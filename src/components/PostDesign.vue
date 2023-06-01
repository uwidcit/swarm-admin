<template>
  <q-card class="my-card background">
     <!--<a :href="`/Details/${data.id}`"> </a>-->
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
    <q-separator color="grey"/>
     <q-card-actions>
            <div class="col-4 q-px-xl">
                <q-icon name="fa-solid fa-message"></q-icon>
                <q-btn flat @click="toggleComments"> Comments 20 </q-btn>
            </div>
             <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-heart"> </q-icon>
              <q-btn flat> Likes: 210 </q-btn>
            </div>
             <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-share"></q-icon>
              <q-btn flat> Share</q-btn>
            </div>
    </q-card-actions>

  <div v-if="seeComments">
    <q-separator color="grey"/>
      <q-card class=" q-pa-md my-card background">
        <q-card-section square="true">
          <div class="row">
            <div class="col-1">
              <q-avatar icon="fa-solid fa-circle-user fa-2xl"/>
            </div>
            <div class="col-11">
              <p> John Doe </p>
              <p>This is a simulated reply only to be used for testing </p>
            </div>
          </div>
             <q-card-actions>
             <div class="col-4 q-px-xl">
                <q-icon name="fa-solid fa-message"></q-icon>
                <q-btn flat> Comments 20 </q-btn>
            </div>
             <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-heart"> </q-icon>
              <q-btn flat> Likes: 210 </q-btn>
            </div>
             <div class="col-4 q-px-xl">
              <q-icon name="fa-solid fa-share"></q-icon>
              <q-btn flat> Share</q-btn>
            </div>
          </q-card-actions>
        <q-separator color="grey"/>
      </q-card-section>    
</q-card></div>
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
    const seeComments = ref(false)
    function datePassed() {
    //  console.log(Date.parse(props.data.created))
    //  console.log(formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true }))
        let returnDate = new Date(Date.parse(props.data.created_date))
      return  returnDate.toLocaleString()
       // return formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true })
    }

    function toggleComments(){
      seeComments.value = !seeComments.value
    }

    return{
      datePassed,
      toggleComments,
      seeComments,
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
