<template>
  <q-card class="background">
    <q-card-section>
      <div class="row">
          <div class="col-9">
          </div>
         <div class="col text-subtitle1 text-justify q-mt-sm">
          {{datePassed()}}
        </div>
      </div>

      <div class="q-pa-md">
        <div class="row">
          <div class="col">
            <q-avatar>
              <img src="https://cdn.quasar.dev/img/boy-avatar.png">
            </q-avatar>
          </div>

          <div class="col-9 text-h6">
            <a :href="`/Details/${data.id}`">{{ data.text }}</a>
          </div>
        </div>
        </div>

         <div class="row">
          <div class="col">
          </div>
          <div class="col-9 text-h6">
            <span class="tag tag-blue"
                  v-for="(tag,index) in data.tags" :key="tag">             
                    {{tag.text}}
                
         </span>
          </div>
          </div>
         <!---
          <span class="text-h6 float-right">
              <q-btn label="Details" rounded color="secondary" outline :to="`/Details/${data.id}`"></q-btn>
            </span>   
        --->
   
    </q-card-section>
  </q-card>
</template>
<script>
import {defineComponent} from 'vue'
import { formatDistance} from 'date-fns'
export default defineComponent({
  name: "CardProduct",
  props: ['data'],
 
  setup(props) {
    const value = Date.now()
    function datePassed() {
    //  console.log(Date.parse(props.data.created))
    //  console.log(formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true }))
        return formatDistance(Date.parse(props.data.created), new Date(), { addSuffix: true })
    }
    return{
      datePassed,
    }
  }
})
</script>
<style scoped>
/* unvisited link */
a:link {
  color: rgb(10, 10, 10);
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
background-color: #fad0c4;
background-image: linear-gradient(315deg, #fad0c4 0%, #f1a7f1 74%);
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
  background: #56CCF2;
background: linear-gradient(to bottom, #2F80ED, #56CCF2);
  color: #fafafa;
}
.tag-brown {
  background: #D1913C;
background: linear-gradient(to bottom, #FFD194, #D1913C);
  color: #fafafa;
}
</style>