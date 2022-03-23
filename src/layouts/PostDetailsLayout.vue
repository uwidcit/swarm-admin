<template>
  <q-layout view="lHh Lpr lFf">

    <q-header elevatedclass="bg-primary text-white">
       <q-toolbar class="glossy">

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
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above class="bg-primary text-white">
      <!-- drawer content -->

    <q-item to="/" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="menu"/>
          </q-item-section>
          <q-item-section>
            <q-item-label><strong>SWARMNET</strong></q-item-label>
          </q-item-section>
        </q-item>

        <q-separator color="orange" inset />
        
        <q-list>
         <q-item to="/" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="fas fa-arrow-circle-left" />
          </q-item-section>
          <q-item-section>
            <q-item-label><strong>MAIN FEED</strong></q-item-label>
          </q-item-section>
        </q-item>

        <!--
        <q-btn flat @click="inception = true" active-class="q-item-no-link-highlighting">
          <q-item-section avatar>
            <q-icon name="far fa-edit" />
          </q-item-section>
          <q-item-section>
            <q-item-label><strong>Create Subtopic</strong></q-item-label>
          </q-item-section>
        </q-btn>
        -->

        
        </q-list>

    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>

  </q-layout>
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