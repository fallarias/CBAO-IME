<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
import EnterpriseOverview from './Partials/EnterpriseOverview.vue';
import EnterpriseDataTable from './Partials/EnterpriseDataTable.vue';
</script>

<template>
    <Head title="Enterprises" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Enterprises</h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items"/>
                </div>

                <!-- enterprise overview  -->
                 <div class="mb-12">
                    <p class="font-bold text-xl mb-2">Overview</p>
                    <EnterpriseOverview></EnterpriseOverview>
                 </div>


                 <!-- <v-skeleton-loader type="table" class="border-2"></v-skeleton-loader> -->

                 <!-- enterprise list  -->
                  <div>
                    <p class="font-bold text-xl mb-2">Data Table</p>
                    <EnterpriseDataTable :enterprises="enterprises"></EnterpriseDataTable>
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
        enterprises: [
          {
            number: 1,
            id: 1,
            enterprise: 'Carabao Stud Farm',
            type: 'Agri-based'
          },
          {
            number: 2,
            id: 2,
            enterprise: 'Fishpond Rental',
            type: 'Agri-based'
          },
          {
            number: 3,
            id: 3,
            enterprise: 'HVC CBAO',
            type: 'Agri-based'
          },
          {
            number: 4,
            id: 4,
            enterprise: 'ID Lanyard/Lace',
            type: 'Non agri-based'
          },
          {
            number: 5,
            id: 5,
            enterprise: 'PE Uniform',
            type: 'Non agri-based'
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Transaction',
                active: false
            },
            {
                title: 'Enterprises',
                active: true
            },
        ]
      }
    },
  }
</script>