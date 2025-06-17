<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Campuses" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Campuses</h2>
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
                                <v-icon icon="mdi-account-group"></v-icon> &nbsp;
                                Campuses

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
                            </v-card-title>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>
                            <v-data-table
                            v-model:search="search"
                            :filter-keys="['name']" :headers="header"
                            :items="campuses" hover
                            >
                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end">
                                        <v-btn variant="tonal" color="info" class="mr-2" icon="mdi-eye" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn>
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
    props: {
        campuses: {
            type: Array,
            required: true,
        },
    },
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
                title: 'Campus',
                align: 'center',
                key: 'campus',
                sortable: true,
            },
            {
                title: 'Actions',
                align: 'end',
                key: 'actions',
                sortable: false,
            },
        ],
        items: [
          {
            title: 'Malakas',
            code: '24-0001',
            quota: 100,
            status: true,
          },
          {
            title: 'Makisig',
            code: '23-0001',
            quota: 300,
            status: false,
          },
          {
            title: 'Malupit',
            code: '22-0001',
            quota: 150,
            status: true,
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Setup',
                active: false
            },
            {
                title: 'Campuses',
                active: true
            },
        ]
      }
    },
  }
</script>