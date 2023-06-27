<template>
  <q-layout>
    <q-page-container>
      <q-page class="flex bg-image flex-center">
        <div class="wrapper login">
        <div class="container">
            <div class="col-left">
                <div class="login-text">
                    <h2>SWARM NET</h2>
                    <p>Login.<br>Stay updated about diasters.</p>
                    <a href="/" class="btn" >Login</a>
                </div>
            </div>

            <div class="col-right">
                <div class="login-form">
                    <h2>Create Account</h2>
                    <form action="">
                         <p>
                            <label>Firstname<span>*</span></label>
                            <input v-model="fname" type="text" placeholder="Firstname" required>
                        </p>
                         <p>
                            <label>Lastname<span>*</span></label>
                            <input v-model="lname" type="text" placeholder="Lastname" required>
                        </p>
                        <p>
                            <label>Username or email address<span>*</span></label>
                            <input v-model="username" type="text" placeholder="Username or Email" required>
                        </p>
                        <p>
                            <label>Password<span>*</span></label>
                            <input v-model="password" type="password" placeholder="Password" required>
                        </p>
                        <p>
                            <q-input :loading="loading[0]" @click.prevent.self @click="simulateProgress(0,fname, lname, username,password)"   type="submit"  no-caps flat />
                        </p>
                        <p>
                            <a href="">Forget password?</a>
                        </p>

                    </form>
                </div>
            </div>

        </div>
    </div>
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
    function signup(fname, lname, username, password){
      console.log("enter", username, password)
    
      let urrl = process.env.BASE_URL+"/api/regisiter"
      api.post(urrl, {
        "firstname": fname,
        "lastname": lname,  
        "username": username,
        "password": password
      },
        {
            method: 'POST',
            
            headers: {
                    'Access-Control-Allow-Origin': '*',
                    }
        }
                
            ).then((response) => {
        if(response.status == 201){
          const redirectPath = route.query.redirect || '/'
          router.push(redirectPath)
        }     
    })
          .catch(() => {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: 'Error creating account',
              icon: 'report_problem'
            })
          }) 
  }
  
     function simulateProgress (number,fname, lname, username,password) {
        console.log("enter", fname, lname, username, password)
      // we set loading state
      loading.value[ number ] = true
      // simulate a delay
      setTimeout(() => {
        // we're done, we reset loading state
        loading.value[ number ] = false
        signup(fname, lname, username,password)
      }, 3000) 
    }
    return {
      signup,
      fname: ref(''),
      lname: ref(''),
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
/* General css */
*{
    box-sizing: border-box;
}
body{
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 16px;
    font-weight: 400;
    color: #666666;
    background: #eaeff4;
}
.wrapper{
    margin: 0 auto;
    width: 100%;
    max-width: 1140px;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
}
.container{
    position: relative;
    width: 100%;
    max-width: 600px;
    height: auto;
    display: flex;
    background: #ffffff;
    box-shadow: 0 0 5px #999999;
}
.login .col-left,
.login .col-right{
    padding: 30px;
    display: flex;
}
.login .col-left{
    width: 60%;
    clip-path: polygon(0 0, 0% 100%, 100% 0 );
    background: #44c7f5;
}
.login .col-right{
    padding: 60px 30px;
    width: 50%;
    margin-left: -10%;
}
@media(max-width: 575px){
    .login .container{
        flex-direction: column;
        box-shadow: none;
    }
    .login .col-left,
    .login .col-right{
     width: 100%;
     margin: 0;
     clip-path: none;
    }
    .login .col-right{
        padding: 30px;
    }
    
}
.login .login-text{
    position: relative;
    width: 100%;
    color: #ffffff;
}
.login .login-text h2{
    margin: 0 0 15px 0;
    font-size: 30px;
    font-weight: 700;
}
.login .login-text p{
    margin: 0 0 20px 0;
    font-size: 16px;
    font-weight: 500;
    line-height: 22px;
}
.login .login-text .btn{
    display: inline-block;
    padding: 7px 20px;
    font-size: 16px;
    letter-spacing: 1px;
    text-decoration: none;
    border-radius: 30px;
    color: #ffffff;
    outline: none;
    border: 1px solid #ffffff;
    box-shadow: inset 0 0 0 0 #ffffff;
    transition: .3s;
}
.login .login-text .btn:hover{
    color: #44c7f5;
    box-shadow: inset 150px 0 0 0  #ffffff;
}
.login .login-form{
    position: relative;
    width: 100%;
}
.login .login-form h2{
    margin: 0 0 15px 0;
    font-size: 22px;
    font-weight: 700;
}
.login .login-form p{
    margin: 0 0 10px 0;
    text-align: left;
    color: #666666;
    font-size: 15px;
}
.login .login-form p:last-child{
    margin: 0;
    padding-top: 3px;
}
.login .login-form p a{
    color: #44c7f5;
    font-size: 14px;
    text-decoration: none;
}
.login .login-form label {
    display: block;
    width: 100%;
    margin-bottom: 2px;
    letter-spacing: .5px;
}
.login .login-form p:last-child label{
    width: 60%;
    float: left;
}
.login .login-form label span{
    color: #ff574e;
    padding-left: 2px;
}
.login .login-form input{
    display: block;
    width: 100%;
    height: 35px;
    padding: 0 10px;
    outline: none;
    border: 1px solid #cccccc;
    border-radius: 30px;
}
.login .login-form input:focus{
    border-color: #ff574e;
}
.login .login-form button,
.login .login-form input[type=submit] {
    display: inline-block;
    width: 100%;
    margin-top: 5px;
    color: #44c7f5;
    font-size: 16px;
    letter-spacing: 1px;
    cursor: pointer;
    background: transparent;
    border: 1px solid #44c7f5;
    border-radius: 30px;
    box-shadow: inset 0 0 0 0 #44c7f5;
    transition: .3s;
}
.login .login-form button:hover,
.login .login-form input[type=submit]:hover{
    color: #ffffff;
    box-shadow: inset 250px 0 0 0 #44c7f5;
}
</style>
