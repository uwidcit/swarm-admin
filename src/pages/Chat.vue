<template>
            <div class="row">

                <div class = "col-4">
                <q-input 
                  rounded
                  outlined
                  v-model="filter"
                  debounce="500" 
                  placeholder="Search"
                  style="width: 280px; padding-bottom: 32px"> </q-input>

                  <q-card>
                    <q-card-section>
                    <div class="row">
                        <div class="col-4">
                            <q-icon name="fa-solid fa-circle-user" style="height:65px; width:65px;"></q-icon>
                        </div>

                         <div class="col-8">
                            <p> Kwasi Edwards</p>
                            <p> Last Sent Message </p>
                        </div>
                        
                    </div>
                    </q-card-section>
                    <q-separator color="grey" />
                    <q-card-section>

                    <div class="row">
                        <div class="col-4">
                            <q-icon name="fa-solid fa-circle-user" style="height:65px; width:65px;"></q-icon>
                        </div>

                         <div class="col-8">
                            <p> Kwasi Edwards</p>
                            <p> Last Sent Message </p>
                        </div>
                        
                    </div>
                    </q-card-section>
                    <q-separator color="grey"/>
                  </q-card>
                
                </div> 
                    
                 

                <div class = "col-8">
                    <div class="banner">
                        <div class="row">
                            <div class="col-3">
                                insert icon png here
                            </div>
                            <div class="col-9">
                                Kwasi Edwards
                            </div>
                            
                        </div>
                    </div>
                    <div class="messageBubbles"> 
                        Some message
                        Date/Time
                    </div>
                    <div>
                        <q-btn/>
                        <q-input style="max-width:75%"/>
                        <q-btn/>
                    </div>
                </div>

            </div>
</template>

<style scoped>

.banner{
    top: 142px;
    left: 716px;
    width: 1204px;
    height: 90px;

    background: var(--unnamed-color-a8dadc) 0% 0% no-repeat padding-box;
    background: #A8DADC 0% 0% no-repeat padding-box;
    opacity: 1;
}

</style>