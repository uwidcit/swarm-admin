<template>
  <q-layout>
    <q-page-container>
      <q-page class="flex bg-image flex-center">
        <q-card v-bind:style="$q.screen.lt.sm?{'width': '80%'}:{'width':'30%'}">
          <q-card-section>
            <q-avatar size="103px" class="absolute-center shadow-10">
              <img src="profile.svg">
            </q-avatar>
          </q-card-section>
          <q-card-section>
            <div class="text-center q-pt-lg">
              <div class="col text-h6 ellipsis">
                Log in
              </div>
            </div>
          </q-card-section>
          <q-card-section>
            <q-form
              class="q-gutter-md"
            >
              <q-input
                filled
                v-model="username"
                label="Username"
                lazy-rules
              />

              <q-input
                type="password"
                filled
                v-model="password"
                label="Password"
                lazy-rules

              />

              <div class="center" >
                <q-btn  :loading="loading[0]" @click="simulateProgress(0,username,password)" label="Login"  type="button" color="primary"/>
              </div>
            </q-form>
          </q-card-section>
        </q-card>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script>
import {defineComponent} from 'vue'
import {ref} from 'vue'
import { api } from 'boot/axios'
import { useQuasar } from 'quasar'
import { onMounted, onUpdated} from 'vue'
import { useRouter, useRoute } from 'vue-router'


export default defineComponent({
  setup() {
     const $q = useQuasar()
     const router = useRouter()
    const route = useRoute()
     const loading = ref([false])

    function login(username, password){
      console.log("enter")
    
      let urrl = "https://swarmnet-prod.herokuapp.com/auth"
      api.post(urrl, {
        "username": username,
        "password": password
      }).then((response) => {

        if(response.status == 200){
          localStorage.setItem('token', response.data.access_token)
          const redirectPath = route.query.redirect || '/home'
          router.push(redirectPath)

        }     
    })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Incorrect e-mail or password!',
              icon: 'report_problem'
            })
          })
  }
  
     function simulateProgress (number,username,password) {
      // we set loading state
      loading.value[ number ] = true

      // simulate a delay
      setTimeout(() => {
        // we're done, we reset loading state
        loading.value[ number ] = false
        login(username,password)
      }, 3000)
    }

    return {
      login,
      username: ref(''),
      password: ref(''),
      loading,
      simulateProgress
    }
  },
})
</script>

<style>

.bg-image {
  background-image: linear-gradient(135deg, #7028e4 0%, #e5b2ca 100%);
}

.center {
  margin: auto;
  width: 25%;
  padding: 10px;
}
</style>
