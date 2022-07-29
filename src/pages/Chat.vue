<template>
    <q-page>
        <q-page-container style="padding-top:0px; padding-left:0px;">
            <div class="row">
                <div class = "col-4 q-px-lg q-py-lg q-gutter-lg chatStyle">
                <q-input 
                
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search"
                  style="width: 90%"> </q-input>

                
                <q-scroll-area style="height: 100%; width: 90%">
                        <q-card class="q-my-xs">
                         <q-card-section v-for="(conversation, index) in conversations" :key="index">
                            <div class="row items-center q-pl-md">
                                <div class="col-2">
                                   <i class="fa-solid fa-circle-user fa-2xl"></i>
                                </div>

                                <div class="col-9">
                                    <p> {{ conversation.name }} </p>
                                    <p> {{ conversation.last_message }} </p>
                                </div>

                        </div>
                        <q-separator/>
                    </q-card-section>
                </q-card>
            </q-scroll-area>
            
        </div> 
                    
                 

                <div class = "col-8 q-pl-xs">
                    <div class="row-2 banner">
                        <div class="row items-center">
                            <div class="col-2 q-pl-lg q-py-lg">
                                 <i class="fa-solid fa-circle-user fa-2xl "></i>
                            </div>
                            <div class="col-9 text-h5">
                                Kwasi Edwards
                            </div>
                         </div>
                        </div>
                
                    <div class="row-8 chatWindow" >
                        <div v-for="(m,index) in messages" :key="index">
                            <q-chat-message v-if="m.owner" :text="[m.message]" :name="m.name" :stamp="m.stamp" sent/>
                            <q-chat-message v-else :text="[m.message]" :name="m.name" :stamp="m.stamp" /> 
                        </div>
                        
                    </div>
                    <div class="row-2">
                    <div class="row items-center chatStyle">
                        <div class="col-1">
                            <label for="file-upload" class="uploadStyling q-focusable q-hoverable">
                                <i class="fa-solid fa-paperclip fa-2xl"></i> 
                            </label>
                            <input id="file-upload" type="file" />
                        </div>
                        
                         <div class="col-10">
                            <q-input outlined rounded style="max-width:100%; max-height:60%"/>
                        </div>

                         <div class="col-1">
                            <q-btn flat icon="fa-solid fa-paper-plane"/>
                        </div>
                    </div>
                    </div>
                </div>

            </div>
        </q-page-container>
    </q-page>
</template>

<script>
import {defineComponent, ref, onMounted} from 'vue'
import { api } from 'boot/axios'

export default defineComponent({
    name: "Chat",

    props: ['data'],

    setup(props){
        const messages = ref([
            {messageID:1,
            name:'Me',
            message: 'Hello',
            owner: true,
            stamp: '7 minutes ago'},

            {messageID:2,
            name:'Jane Doe',
            message: 'Who are you ',
            owner: false,
            stamp: '4 minutes ago'},

            {messageID:3,
            name:'Me',
            message: `It's a me Mario`,
            owner: true,
            stamp: '1 minutes ago'},

            {messageID:4,
            name:'Jane Doe',
            message: 'Sorry I think you have the wrong number',
            owner: false,
            stamp: 'just now'}

            ])
        const conversations = ref([
            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Hello',
            pro_pic: ''}
            ,
             {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Are you done with the chat',
            pro_pic: ''},

            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Does the virtual Scroll work',
            pro_pic: ''},

            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'12 dollars for a dozen eggs',
            pro_pic: ''},

            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Can you turn up the music',
            pro_pic: ''},

            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Did you forget to do your work',
            pro_pic: ''},
            {chatID: '100',
            name: 'Kwasi Edwards',
            last_message:'Black truck',
            pro_pic: ''}
            ])
        const conversationsSize = ref(2)
        onMounted(() => {

        })
        return{
            messages,
            from: ref(0),
            conversations,
            conversationsSize,
        }
    }
})

</script>


<style scoped>
.chatWindow{
}
.chatStyle{
    background: #FFFFFF 0% 0% no-repeat padding-box;
    opacity: 1;
}

input[type="file"] {
    display: none;
}
.uploadStyling:hover{
    align-items:center;
    box-sizing: content-box;
    display: flex;
    cursor: pointer;
}

.banner{
    top: 142px;
    left: 716px;
    height: 90px;

    background: var(--unnamed-color-a8dadc) 0% 0% no-repeat padding-box;
    background: #A8DADC 0% 0% no-repeat padding-box;
    opacity: 1;
}

</style>