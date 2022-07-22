const routes = [
  {
    path: '/home',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Dashboard.vue'), props: true  },
      {path:'/Topics', component: () => import('pages/Topics.vue'), props:true},
      {path:'/Broadcast', component: () => import('pages/Broadcast.vue'), props:true},
      {path: '/Alerts', component: () => import('pages/AlertsMap.vue')},
      {path: '/Map', component: () => import('pages/Map.vue')},
      {path: '/MapMarker', component: () => import('pages/MapMarker.vue')},
      { path: '/PostAnalytics', component: () => import('components/charts/BarChart.vue') },
      {path: '/Users/AdminUsers', component: ()=> import('pages/Adminstrators.vue'),props:true},
      {path:'/Users/ExternalUsers', component: () => import('pages/ExternalUsers.vue'), props:true},
      
    ]
  },
  
  
  {
    path: '/',
    component: () => import('pages/Login.vue')
  },

  {
    path: '/createaccount',
    component: () => import('pages/CreateAccount.vue')
  },
  


  {
    path: '/Details',
    component: () => import('layouts/PostDetailsLayout.vue'),
    children: [
      {
        path: '/Details/:id',component: () => import('pages/Details.vue')
        
      },
    ]
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/Error404.vue')
  },
 
]

export default routes

