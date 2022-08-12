<template>
        <q-page>
            <q-page-container style="padding-top: 50px;padding-left: 100px;">
              <div class="row">
             <div class="col-3 text-p textStyle"> 
                Relief Centres
             </div>
              <div class="col-3"> 
                <q-btn class ="btnStyle" @click="prompt = true" label="Create"> 
                </q-btn>
              </div>
              
              <div class="col-6">
                <q-input 
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search"
                  style="width: 350px; padding-bottom: 32px"
                 
                  > </q-input> 
                </div>
      </div>
                <q-table  :rows ="centers" :columns="columns" :filter="filter"> 
                  <template v-slot:body="props"> 
                    
                    <q-tr :props="props">
                    <q-td key ="name" :props="props"> 
                      {{ props.row.name}}
                    </q-td>

                      <q-td key ="address" :props="props"> 
                        {{ props.row.line_1 + ' ' + props.row.line_2}}
                      </q-td>

                    <q-td key ="email" :props="props"> 
                      {{ props.row.email}}
                    </q-td>

                  
                  <q-td key ="moreOptions" :props="props"> 
                      <q-btn-dropdown dropdown-icon="fas fa-ellipsis" flat round> 
                        <q-list>
                        <q-item clickable v-close-popup @click="promptEdit = true, current_row= props.row" >
                          <q-item-section>
                            <q-item-label>Edit</q-item-label>
                          </q-item-section>
                         </q-item>

                          <q-item clickable v-close-popup @click="promptDelete = true , current_row= props.row ">
                          <q-item-section>
                            <q-item-label>Delete</q-item-label>
                          </q-item-section>
                         </q-item>
                       </q-list>
                      </q-btn-dropdown>
                       
                  </q-td>

                  </q-tr>       
                  </template>
                  
                </q-table>

                <q-dialog v-model="prompt" persistent>
                  <q-card style="min-width:830px; min-height: 520px">
                    <div class= "row">
                      <div class="col-11">
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Create Relief Centre </p>
                      </div>
                      <div class= "col-1 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                     <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent">
                            <q-form> 
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="FName" v-model="fName"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 1" v-model="line_1"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 2" v-model="line_2"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="City" v-model="city"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Longitude " v-model="longitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Latitude" v-model="latitude"  maxlength="60" autogrow  :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Phone Number" v-model="pNo"  maxlength="60" autogrow   :dense="dense" />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Email Address" v-model="email" type="email" maxlength="60" autogrow   :dense="dense" />
                            </q-form>
                      </div>
                     </div>
                      <template v-slot:after>
                      
                      </template>
                      
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" type="submit"  @click="createCenter(fName, line_1, line_2,city, latitude, longitude, pNo,email)" label="Save" v-close-popup />
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                       
                      </q-card-actions>
                  </q-card>
                </q-dialog>
            </q-page-container>

               <q-dialog v-model="promptEdit" full-widthpersistent @show="loadData(current_row)">
                  <q-card style="min-width:830px; min-height: 520px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Edit Topic </p>
                      </div>
                      <div class= "col-2 q-pa-sm">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup @click ="clearData"/>
                      </div>
                    </div>

                     <div class="row">
                        <div class= "col-12 text-p q-px-xl textContent">
                            <q-form> 
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="FName" v-model="fName"  maxlength="60" autogrow :v-text="current_row.city"  />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 1" v-model="line_1"  maxlength="60" autogrow  />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Address Line 2" v-model="line_2"  maxlength="60" autogrow   />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="City" v-model="city"  maxlength="60" autogrow   />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Longitude " v-model="longitude"  maxlength="60" autogrow  />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Latitude" v-model="latitude"  maxlength="60" autogrow   />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Phone Number" v-model="pNo"  maxlength="60" autogrow    />
                              <q-input class="q-py-sm" outlined style="max-width : 90%" placeholder="Email Address" v-model="email" type="email" maxlength="60" autogrow    />
                            </q-form>
                      </div>
                     </div>                  
                      <template v-slot:after>
                      
                      </template>
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Save" type="submit" @click ="editCenter(current_row.id, fName, line_1, line_2,city, latitude, longitude, pNo,email)" v-close-popup />
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" @click ="clearData" v-close-popup />
                          </div>
                      </q-card-actions>
                  </q-card>
                </q-dialog>

               <q-dialog v-model="promptDelete" full-widthpersistent>
                  <q-card style="min-width:418px; min-height: 171px">
                    <div class= "row">
                      <div class="col-10">
                        <p class = "q-px-xl q-pt-lg q-pb-md textStyle"> Delete {{ current_row.name  }} </p>
                      </div>
                      <div class= "col-2 q-pa-md">
                        <q-btn flat icon="fa-solid fa-x" v-close-popup />
                      </div>
                    </div>
                      <div class= "text-p q-px-xl q-pt-lg q-pb-md"> 
                        Are you sure you want to delete this Relief Centre 
                    </div>
                      <template v-slot:after>
                      
                      </template>
                      
                      <q-card-actions align="right" class="text-primary">
                         <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center"> 
                               <q-btn class= "btnStyle" flat label="Confirm" @click = "deleteCenter(current_row.id)" v-close-popup/>
                          </div>

                          <div class="col-6 q-px-xl q-pt-lg q-pb-md items-center">
                              <q-btn class= "btnStyle2" flat label="Cancel" v-close-popup />
                          </div>
                      </q-card-actions>
                  </q-card>
                </q-dialog>


        </q-page>
</template>

<script>
import {defineComponent, ref, onMounted} from 'vue'
import { formatDistance} from 'date-fns'
import { api } from 'boot/axios'

export default defineComponent({
  name: "Topics",

  props: ['data'],


  setup(props) {

    const fName = ref('')
    const city = ref('')
    const line_1 = ref('')
    const line_2 = ref('')
    const latitude = ref('')
    const longitude = ref('')
    const pNo = ref('')
    const email = ref('')

    const centers = ref([])
    const data = ref(null)
    const columns = [{
        name:'name',
        label:'Name',
        field:'name',
        align: 'left',
    }, {
        name:'address',
        label:'Address',
        field:'address',
        align: 'left',
    } ,
       {
        name:'email',
        label:'Email Address',
        field:'email',
        align: 'left',
       },  
       {
        name:'moreOptions',
        label:'',
        field:'moreOptions',
        align: 'left',
       }]

    const rows =[{
        id:1,
        name:'Port of Spain Relief Cen…',
        address: '123 Centre Street, Port of Spain',
        email:'kwasiedwards@gmail.com',

    }, {
        id:2,
        name:'Port of Spain Relief Cen…',
        address: '123 Centre Street, Port of Spain',
        email:'kwasiedwards@gmail.com',
    }]

    function getReliefCenter(){
        let url = process.env.COMMON_API_URL+'/relief_center'
        api.get(url, {
          method: 'GET',
          headers: {
          'Access-Control-Allow-Origin': '*',
          Authorization:  'Bearer '+ localStorage.getItem('token'),
          }
        }).then((response) => {
            data.value =  response.data.centers
            for(let i of data.value){
              centers.value.push({ 
                id:i.id,
                name: i.first_name,
                city: i.city,
                email:i.email,
                latitude:i.latitude,
                longitude:i.longitude,
                phone:i.phone,
                profile_image: i.profile_image,
                subscriptions:i.subscriptions,
                line_1: i.line_1,
                line_2: i.line_2,
            })
        }})
    }


    function createCenter(fname, line_1, line_2,city, lat, lon, pNo,email){
      console.log('Hello there')
      let url = process.env.ADMIN_API_URL+'/users/relief_center'
      api.post(url, {
        name:fname,
        line_1:line_1,
        line_2:line_2,
        city:city,
        longitude:lon,
        latitude:lat,
        phone:pNo,
        email:email
      }, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        data.value = response.data.center
        centers.value.push({
                 id:data.id,
                name: data.value.first_name,
                city: data.value.city,
                email:data.value.email,
                latitude:data.value.longitude,
                phone:data.value.phone,
                profile_image: data.value.profile_image,
                subscriptions:data.value.subscriptions,
                line_1: data.value.line_1,
                line_2: data.value.line_2,
        })
      })
    }

    function editCenter(id,fname, line_1, line_2,city, lat, lon, pNo,email){
      let url = process.env.ADMIN_API_URL+'/users/relief_center'+id
      api.put(url, {
       name:fname,
        line_1:line_1,
        line_2:line_2,
        city:city,
        longitude:lon,
        latitude:lat,
        phone:pNo,
        email:email
      }, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        }
      }).then((response) => {
        console.log(response)
        centers.value = ([])
        getReliefCenter()
      })
    }

    function deleteCenter(id){
      let url = process.env.ADMIN_API_URL+'/users/relief_center'+id
      api.delete(url, {
        headers: {
           Authorization:  'Bearer '+ localStorage.getItem('token') ,
          'Access-Control-Allow-Origin': '*',
        }
      }).then((response) => {
        console.log(response)
        centers.value = ([])
        getReliefCenter()
      })
    }

  onMounted(() => {
    getReliefCenter();
  })
    return{
      fName,
      city,
      line_1,
      line_2,
      latitude,
      longitude,
      pNo,
      email,
      data,
      dense:ref(false),
      prompt: ref(false),
      filter: ref(''),
      promptEdit: ref(false),
      promptDelete: ref(false),
      current_row:ref(''),
      search:ref(''),
      getReliefCenter,
      editCenter,
      createCenter,
      deleteCenter,
      centers,
      columns,
      rows,
      loadData(current_row) {
        fName.value = current_row.name,
        city.value = current_row.city,
        line_1.value = current_row.line_1,
        line_2.value = current_row.line_2,
        latitude.value = current_row.latitude,
        longitude.value = current_row.longitude,
        pNo.value = current_row.phone,
        email.value = current_row.email
      },
      clearData(){
        fName.value = '',
        city.value = '',
        line_1.value = '',
        line_2.value = '',
        latitude.value = '',
        longitude.value = '',
        pNo.value = '',
        email.value = ''
      },
    }
  }
})
</script>

<style scoped>
.btnStyle{
width: 175px;
height: 24px;
background: var(--unnamed-color-e29862) 0% 0% no-repeat padding-box;
background: #E29862 0% 0% no-repeat padding-box;
border-radius: 10px;
opacity: 1;

color: var(--unnamed-color-f8f8f8);
text-align: left;
font: normal normal 100 15px/20px Poppins;
letter-spacing: 0px;
color: #F8F8F8;
}

.textStyle{
  color: var(--unnamed-color-3e3e3e);
  text-align: left;
  font: normal normal bold 30px/46px Poppins;
  letter-spacing: 0px;
  color: #3E3E3E;
  opacity: 1
}

.btnStyle2{
  width: 185px;
  height: 24px;
  border: 3px solid var(--unnamed-color-e29862);
  border: 3px solid #E29862;
  color: var(--unnamed-color-e29862);
  color: #E29862;
  border-radius: 10px;
  opacity: 1;
  text-align: left;
  font: normal normal 100 15px/20px Poppins;
  letter-spacing: 0px;
}
</style>