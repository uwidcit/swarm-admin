<template>
  <q-card class="background">
     <a :href="`/Details/${data.id}`">
    <q-card-section>
      <div class="row">
          <div class="col-6">
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
           {{ data.text }}
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

    </q-card-section>
    </a>
  </q-card>
</template>

<script>
import {defineComponent} from 'vue'
import { formatDistance} from 'date-fns'

export default defineComponent({
  name: "PostDesign",

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
background-color: #abe9cd;
background-image: linear-gradient(315deg, #abe9cd 0%, #3eadcf 74%);

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
  background-color: #fad0c4;
background-image: linear-gradient(315deg, #fad0c4 0%, #f1a7f1 74%);

}

</style>
