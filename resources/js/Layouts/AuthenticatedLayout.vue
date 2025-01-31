<script setup>
import { ref } from 'vue';
import NavLink from '@/Components/NavLink.vue';
import ProfileMenu from '@/Partials/ProfileMenu.vue';
import NotificationBar from '@/Partials/NotificationBar.vue';
  
const drawer = ref(null)
</script>

<template>
    <v-app id="inspire">
        <v-app-bar :elevation="1" color="green-darken-4" height="80">
            <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
            
            <v-app-bar-title>
                <div>
                    <p class="font-bold">5ID ROAMS</p>
                    <p class="text-xs">5th Infantry Division Recruitment Office - Application and Management System</p>
                </div>
            </v-app-bar-title>

            <div class="mr-5">
                <NotificationBar />
                <ProfileMenu :name="$page.props.auth.user.name" :email_address="$page.props.auth.user.email"/>
            </div>
        </v-app-bar>
        <v-navigation-drawer v-model="drawer">
          <v-list v-model:opened="open" nav>
              <NavLink :href="route('dashboard')" :active="route().current('dashboard')" :icon="`mdi-view-dashboard`">
                  <v-list-item-title class="navigation" role="link">Dashboard</v-list-item-title>
              </NavLink>
  
            <v-list-group value="Setup">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-cog" title="Setup"></v-list-item>
              </template>
  
              <NavLink :icon="`mdi-account-group`">
                  <v-list-item-title class="navigation" role="link">Users</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-home-group`">
                  <v-list-item-title class="navigation" role="link">Batches</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-shield-star`">
                  <v-list-item-title class="navigation" role="link">Ranks</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-office-building`">
                  <v-list-item-title class="navigation" role="link">Designation</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-wrench`">
                  <v-list-item-title class="navigation" role="link">Skills</v-list-item-title>
              </NavLink>
            </v-list-group>

            <v-list-group value="Transaction">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-handshake" title="Transaction"></v-list-item>
              </template>
  
              <NavLink :icon="`mdi-file-document-multiple`">
                  <v-list-item-title class="navigation" role="link">Submission</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-file-find`">
                  <v-list-item-title class="navigation" role="link">Initial Review</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-file-check`">
                  <v-list-item-title class="navigation" role="link">Validation</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-dumbbell`">
                  <v-list-item-title class="navigation" role="link">PFT Grade</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-medical-bag`">
                  <v-list-item-title class="navigation" role="link">Initial PME</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-tools`">
                  <v-list-item-title class="navigation" role="link">Trade Test</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-medical-bag`">
                  <v-list-item-title class="navigation" role="link">Final PME</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-thought-bubble`">
                  <v-list-item-title class="navigation" role="link">Board Interview</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-medal`">
                  <v-list-item-title class="navigation" role="link">Ranking</v-list-item-title>
              </NavLink>
            </v-list-group>
  
          </v-list>
        </v-navigation-drawer>
      <v-main>
        <!--  -->
      </v-main>
    </v-app>
  </template>
  
  <script>
    export default {
      data: () => ({ 
        drawer: null,
        open: ['Setup', 'Transaction'],
      }),
    }
  </script>

<style scoped>
.nav_subheader {
    font-size: 11px;
}
.navigation {
    font-size: 14px;
}
.main_container {
    background-color: #f5f5f5;
}
</style>