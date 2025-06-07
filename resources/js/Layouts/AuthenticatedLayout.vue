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
                    <p class="font-bold">UBAO-IME</p>
                    <p class="text-xs">Inventory, Monitoring, and Evaluation of Business Enterprise's Income and Expenses</p>
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
  
              <NavLink :href="route('accounts.display')" :active="route().current('accounts.display')" :icon="`mdi-account-group`">
                  <v-list-item-title class="navigation" role="link">Accounts</v-list-item-title>
              </NavLink>
              <NavLink :href="route('batches.display')" :active="route().current('batches.display')" :icon="`mdi-school`">
                  <v-list-item-title class="navigation" role="link">Campuses</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-cash-multiple`">
                  <v-list-item-title class="navigation" role="link">Enterprises</v-list-item-title>
              </NavLink>
            </v-list-group>

            <v-list-group value="Transaction">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-handshake" title="Transaction"></v-list-item>
              </template>
  
              <NavLink :icon="`mdi-package`">
                  <v-list-item-title class="navigation" role="link">Inventory</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-cash-check`">
                  <v-list-item-title class="navigation" role="link">Income</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-cash-remove`">
                  <v-list-item-title class="navigation" role="link">Expenses</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-trending-up`">
                  <v-list-item-title class="navigation" role="link">Evaluation</v-list-item-title>
              </NavLink>
            </v-list-group>
  
          </v-list>
        </v-navigation-drawer>
      <v-main class="bg-stone-50">
        <div class="py-4">
            <slot/>
        </div>
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