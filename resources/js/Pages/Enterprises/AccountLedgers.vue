<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Account Ledgers" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Account Ledgers</h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items"/>
                </div>

                <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg  border border-stone-200">
                    <div class="p-6 text-gray-900">
                        <v-card flat>
                            <v-card-title class="d-flex align-center pe-2">
                                <v-icon icon="mdi-package"></v-icon> &nbsp;
                                Name of Business Enterprise Here (Ledgers)

                                <v-spacer></v-spacer>

                                <v-text-field
                                    v-model="search"
                                    density="compact"
                                    label="Search"
                                    prepend-inner-icon="mdi-magnify"
                                    variant="solo-filled"
                                    flat
                                    hide-details
                                    single-line
                                ></v-text-field>

                                <v-btn
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-refresh"
                                    rounded="l"
                                    text="Refresh"
                                    border
                                    variant="tonal"
                                    color="green-darken-4"
                                    @click="onClick"
                                ></v-btn>

                                <v-btn
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-plus"
                                    rounded="l"
                                    text="Add Client"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add"
                                ></v-btn>
                            </v-card-title>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="clients" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.image="{ item }">
                                    <div>
                                        <v-avatar class="mr-4">
                                            <v-img
                                                :src="`/storage/uploads/avatar/default_avatar.jpg`"
                                                height="64"
                                                cover
                                            ></v-img>
                                        </v-avatar>
                                    </div>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <template v-slot:item.transaction_history="{item}">
                                    <div class="text-center">
                                        <Link :href="route('enterprises.fetch', [1, 1])" class="text-blue-darken-3 hover:font-bold hover:underline">View History</Link>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end">
                                        <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-pencil">Edit</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete">Remove</v-btn>
                                        <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>
                </div>
                
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
  export default {
    // from the database
    // props: {
    //     enterprises: {
    //         type: Array,
    //         required: true,
    //     },
    // },
    data () {
      return {
        search: '',
        header: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'Image',
                align: 'start',
                key: 'image',
                sortable: true,
            },
            {
                title: 'Name',
                align: 'start',
                key: 'name',
                sortable: false,
            },
            {
                title: 'Address',
                align: 'start', 
                key: 'address',
                sortable: false,
            },
            {
                title: 'Contact Number',
                align: 'center', 
                key: 'contact_number',
                sortable: false,
            },
            {
                title: 'Contract Period',
                align: 'center', 
                key: 'contract_period',
                sortable: false,
            },
            {
                title: 'Transaction History',
                align: 'center', 
                key: 'transaction_history',
                sortable: false,
            },
            {
                title: 'Actions',
                align: 'end', 
                key: 'actions',
                sortable: false,
            },
        ],
        clients: [
          {
            number: 1,
            id: 1,
            image: 'default_avatar.jpg',
            name: 'Juan Dela Cruz',
            address: 'San Mateo, Isabela',
            contact_number: '09123456789',
            contract_period: '01/01/2025 - 01/01/2026'
          },
          {
            number: 2,
            id: 2,
            image: 'default_avatar.jpg',
            name: 'Stacy Gomez',
            address: 'Echague, Isabela',
            contact_number: '09123456789',
            contract_period: '02/01/2025 - 07/01/2025'
          },
        ],
        breadcrumbs_items: [
            {
                title: 'Transaction',
                active: false
            },
            {
                title: 'Enterprises',
                active: false
            },
            {
                title: 'Account Ledgers',
                active: true
            },
        ]
      }
    },
  }
</script>