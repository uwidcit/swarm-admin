<template >
  <div  class="bg-grey-3">
    <q-layout view="hHh lpR fFf" >
      <q-header class="background text-white"  >
         <q-toolbar class="glossy">

      <div class="row items-start">
      <div class="col">
        <q-btn round dense flat to="/home"  icon = "fas fa-arrow-circle-left" active-class="q-item-no-link-highlighting">
          </q-btn>
      </div>
      <div class="col">
        <q-btn flat @click="inception = true"  icon = "far fa-edit" active-class="q-item-no-link-highlighting">
          </q-btn>
        </div>
      </div>
       
       <q-space/>

        <div class="q-gutter-sm row items-center no-wrap ">

            <q-btn round dense flat color="white" icon="notifications">
              <q-badge color="red" text-color="white" floating>
                5
              </q-badge>
              <q-menu
              >
                <q-list style="min-width: 100px">
                  <messages></messages>
                  <q-card class="text-center no-shadow no-border">
                    <q-btn label="View All" style="max-width: 120px !important;" flat dense
                           class="text-indigo-8"></q-btn>
                  </q-card>
                </q-list>
              </q-menu>
            </q-btn>
            <q-btn round flat>
              <q-avatar size="26px">
                <img src="https://cdn.quasar.dev/img/boy-avatar.png">
              </q-avatar>
            </q-btn>
          </div>

          <q-dialog v-model="inception">
            <q-card style="width: 600px; height: 400px; background-color: powderblue;">
          <q-card-section>
            <div class="text-h6">CREATE SUBTOPIC</div>
          </q-card-section>
    
          <q-card-section>
          <q-input filled  v-model="ph" placeholder="Enter Subtopic"  />
          </q-card-section>
    
          <q-separator />
    
          <q-card-section style="height: 200px" class="scroll" counter maxlength="260">
            <q-input type="textarea" v-model="text" counter maxlength="260"  autogrow>
            </q-input>
          </q-card-section>
          <q-separator />
          <q-card-actions align="right">
            <q-btn flat label="Discard" color="primary" @click="text = ''" v-close-popup />
            <q-btn flat label="Post" color="primary" v-close-popup @click="triggerPositive(); text = '';"/>
          </q-card-actions>
        </q-card>
          </q-dialog>

        </q-toolbar>
      </q-header>

      <q-page-container >
        <router-view />
      </q-page-container>
    </q-layout>
  </div>
</template>

<script>
import { ref } from 'vue'
import { useQuasar } from 'quasar'

export default {
  name: 'PostDetailsLayout',
  setup () {
    const leftDrawerOpen = ref(false)
    const $q = useQuasar()

    return {
      leftDrawerOpen,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },
      inception: ref(false),

      triggerPositive () {
        $q.notify({
          type: 'positive',
          message: 'SUBTOPIC CREATED'
        })
        // simulate delay
        setTimeout(() => {
          notif({
            type: 'positive',
            message: 'Found the results that you were looking for',
            timeout: 1000
          })
        }, 4000)
      }
    }
  }
}
</script>

<style scoped>
.background{
background-color: #abe9cd;
background-image: linear-gradient(315deg, #abe9cd 0%, #3eadcf 74%);

}
</style>