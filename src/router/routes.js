const routes = [
  {
    path: '/home',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Dashboard.vue'), props: true  },
      {path:'/Topics', component: () => import('pages/Topics.vue'), props:true},
      {path:'/Broadcast', component: () => import('pages/Broadcast.vue'), props:true},
      {path: '/Active', component: () => import('pages/AlertsMap.vue')},
      {path: '/Resolve', component: () => import('pages/ResolveAlerts.vue')},
      {path: '/False', component: () => import('pages/FalseAlerts.vue')},
      {path: '/Map', component: () => import('pages/Map.vue')},
      {path: '/MapMarker', component: () => import('pages/MapMarker.vue')},
      { path: '/PosttAnalytics', component: () => import('components/charts/BarChart.vue') },
      { path: '/UserAnalytics', component: () => import('components/charts/UsersAnalytics.vue') },
      { path: '/PostAnalytics', component: () => import('components/charts/PostAnalytics.vue') },
      { path: '/BroadcastAnalytics', component: () => import('components/charts/BroadcastAnalytics.vue') },
      { path: '/EmergenciesAnalytics', component: () => import('components/charts/EmergenciesAnalytics.vue') },
      {path: '/Users/AdminUsers', component: ()=> import('pages/Adminstrators.vue'),props:true},
      {path:'/Users/ExternalUsers', component: () => import('pages/ExternalUsers.vue'), props:true},
      {path:'/DisasterReliefCenters', component: () => import('pages/DisasterCenters.vue'), props:true},
      {path:'/Chat', component: () => import('pages/Chat.vue'), props:true},
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

