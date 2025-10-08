<script setup>
import { ref } from 'vue';
import NavLink from '@/Components/NavLink.vue';
import ProfileMenu from '@/Partials/ProfileMenu.vue';
import NotificationBar from '@/Partials/NotificationBar.vue';
import FlashMessage from '@/Components/FlashMessage.vue';
import { usePage } from '@inertiajs/vue3';
  
const drawer = ref(null)

const user_name = {
  last_name: usePage().props.auth.user.last_name,
  first_name: usePage().props.auth.user.first_name,
}
</script>

<template>
    <v-app id="inspire">
        <v-app-bar :elevation="1" color="green-darken-4" height="80">
            <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
            
            <v-app-bar-title>
                <div>
                    <p class="font-bold">URGM</p>
                    <p class="text-xs">Inventory, Monitoring, and Evaluation of Business Enterprise's Income and Expenses</p>
                </div>
            </v-app-bar-title>

            <div class="mr-5">
                <NotificationBar />
                <ProfileMenu :name="user_name" :email_address="$page.props.auth.user.email"/>
            </div>
        </v-app-bar>
        <v-navigation-drawer v-model="drawer">
          <v-list v-model:opened="open" nav>
              <NavLink :href="route('dashboard')" :active="route().current('dashboard')" :icon="`mdi-view-dashboard`">
                  <v-list-item-title class="navigation" role="link">Dashboard</v-list-item-title>
              </NavLink>

              <!-- <NavLink :icon="`mdi-account`">
                  <v-list-item-title class="navigation" role="link">Profile</v-list-item-title>
              </NavLink> -->
  
            <v-list-group value="Setup" v-if="$page.props.auth.user.role == 'Admin'">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-cog" title="Setup"></v-list-item>
              </template>
  
              <NavLink :href="route('accounts.display')" :active="route().current('accounts.display')" :icon="`mdi-account-group`">
                  <v-list-item-title class="navigation" role="link">Accounts</v-list-item-title>
              </NavLink>
              <NavLink :href="route('campuses.display')" :active="route().current('campuses.display')" :icon="`mdi-school`">
                  <v-list-item-title class="navigation" role="link">Campuses</v-list-item-title>
              </NavLink>
              <NavLink :href="route('categories.display')" :active="route().current('categories.display')" :icon="`mdi-label-multiple`">
                  <v-list-item-title class="navigation" role="link">Categories</v-list-item-title>
              </NavLink>
              <NavLink :href="route('years.display')" :active="route().current('years.display')" :icon="`mdi-label-multiple`">
                  <v-list-item-title class="navigation" role="link">Years</v-list-item-title>
              </NavLink>
              <NavLink :href="route('uacs.display')" :active="route().current('uacs.display')" :icon="`mdi-label-multiple`">
                  <v-list-item-title class="navigation" role="link">UACS Code</v-list-item-title>
              </NavLink>
              
            </v-list-group>

            <v-list-group value="Transaction">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-handshake" title="Transaction"></v-list-item> 
              </template>
  
              <NavLink :href="route('enterprises.display')" :active="route().current('enterprises.display') || route().current('enterprises.view') || route().current('enterprises.fetch')" :icon="`mdi-cash-multiple`">
                  <v-list-item-title class="navigation" role="link">Enterprises</v-list-item-title>
              </NavLink>
              <NavLink :href="route('inventory.display')" :active="route().current('inventory.display') || route().current('inventory.view')" :icon="`mdi-package`">
                  <v-list-item-title class="navigation" role="link">Inventory</v-list-item-title>
              </NavLink>
              <NavLink :href="route('income.display')" :active="route().current('income.display') || route().current('income.view')" :icon="`mdi-cash-check`">
                  <v-list-item-title class="navigation" role="link">Income</v-list-item-title>
              </NavLink>
              <NavLink :href="route('expenses.display')" :active="route().current('expenses.display') || route().current('expenses.view')" :icon="`mdi-cash-remove`">
                  <v-list-item-title class="navigation" role="link">Expenses</v-list-item-title>
              </NavLink>
              <NavLink :href="route('proposal.display')" :active="route().current('proposal.display') || route().current('proposal.view')" :icon="`mdi-file-document-alert-outline`">
                  <v-list-item-title class="navigation" role="link">Proposal</v-list-item-title>
              </NavLink>
              <!-- <NavLink :icon="`mdi-trending-up`">
                  <v-list-item-title class="navigation" role="link">Evaluation</v-list-item-title>
              </NavLink> -->
            </v-list-group>

            <!-- <v-list-group value="Reports">
              <template v-slot:activator="{ props }">
                  <v-list-item v-bind="props" prepend-icon="mdi-file-chart" title="Reports"></v-list-item>
              </template>
  
              <NavLink :href="route('inventory.display')" :active="route().current('inventory.display') || route().current('inventory.view')" :icon="`mdi-package`">
                  <v-list-item-title class="navigation" role="link">Inventory</v-list-item-title>
              </NavLink>
              <NavLink :href="route('income.display')" :active="route().current('income.display') || route().current('income.view')" :icon="`mdi-cash-check`">
                  <v-list-item-title class="navigation" role="link">Income</v-list-item-title>
              </NavLink>
              <NavLink :href="route('expenses.display')" :active="route().current('expenses.display') || route().current('expenses.view')" :icon="`mdi-cash-remove`">
                  <v-list-item-title class="navigation" role="link">Expenses</v-list-item-title>
              </NavLink>
              <NavLink :icon="`mdi-trending-up`">
                  <v-list-item-title class="navigation" role="link">Evaluation</v-list-item-title>
              </NavLink>
            </v-list-group> -->
  
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