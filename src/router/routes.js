const routes = [
  {
    path: '/home',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Dashboard.vue'), props: true  },
      {path: '/Alerts', component: () => import('pages/AlertsMap.vue')},
     // { path: '/Note', component: () => import('pages/Notification.vue') },
      //{ path: '/PostAnalytics', component: () => import('pages/Charts.vue') },
      { path: '/PostAnalytics', component: () => import('components/charts/BarChart.vue') },

    ]
  },
  
  //
  {
    path: '/',
    component: () => import('pages/Login.vue')
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
