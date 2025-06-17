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
                                Transaction History

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
                                    text="Add New"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add"
                                ></v-btn>
                            </v-card-title>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="transaction_history" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end">
                                        <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-pencil">Edit</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete">Delete</v-btn>
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
                title: 'Date',
                align: 'start',
                key: 'date',
                sortable: true,
            },
            {
                title: 'Particulars',
                align: 'start',
                key: 'particulars',
                sortable: false,
            },
            {
                title: 'Ref. No.',
                align: 'start', 
                key: 'reference_number',
                sortable: false,
            },
            {
                title: 'Debit',
                align: 'center', 
                key: 'debit',
                sortable: false,
            },
            {
                title: 'Credit',
                align: 'center', 
                key: 'credit',
                sortable: false,
            },
            {
                title: 'Balance',
                align: 'center', 
                key: 'balance',
                sortable: false,
            },
            {
                title: 'Actions',
                align: 'end', 
                key: 'actions',
                sortable: false,
            },
        ],
        transaction_history: [
          {
            number: 1,
            id: 1,
            date: '06/21/2025',
            particulars: 'Rice Scheme Wet Season',
            reference_number: 'OR# 211345',
            debit: 990,
            credit: 0,
            balance: 0
          },
          {
            number: 1,
            id: 2,
            date: '05/21/2025',
            particulars: 'Rice Scheme Dry Season',
            reference_number: 'OR# 211345',
            debit: 1188,
            credit: 0,
            balance: 0
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
                active: false
            },
            {
                title: 'Juan Dela Cruz',
                active: true
            },
        ]
      }
    },
  }
</script>