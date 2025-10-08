<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, usePage } from '@inertiajs/vue3';
import EnterpriseOverview from './Partials/EnterpriseOverview.vue';
import EnterpriseDataTable from './Partials/EnterpriseDataTable.vue';
import { ref } from 'vue';
import SelectInput from '@/Components/SelectInput.vue';

const page = usePage();

const sort_category = ref("all");

// filtering
const filter = ref({
  campus: '',
})

const enterprises_list = ref(page.props.all_enterprises)
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
                 <!-- <div class="mb-12">
                    <p v-if="$page.props.auth.user.role == 'User'" class="font-bold text-xl mb-2">Overview</p>
                    <div v-else class="flex align-center justify-between">
                        <p class="font-bold text-xl">Overview</p>
                        <SelectInput class="max-w-sm min-w-[100px]" v-model="filter.campus">
                            <option disabled>
                                Filter by Campus
                            </option>
                            <option selected value="">All Campuses</option>
                            <option v-for="campus in $page.props.campuses" :value="campus.id" :key="campus.id">{{ campus.campus }}</option>
                        </SelectInput>
                    </div>

                    <div>
                        <v-row dense>
                            <v-col cols="12" md="4">
                                <v-card color="green-darken-1" variant="flat" class="px-6 py-8" @click="sort_category = 'all'">
                                    <v-row class="justify-center">
                                        <v-col>
                                            <p class="text-6xl font-bold">{{ $page.props.enterprises_total.overall_total }}</p>
                                            <p class="text-sm mt-2">Income-generating enterprises</p>
                                        </v-col>
                                        <v-col>
                                            <div class="text-4xl text-end">
                                                <v-icon icon="mdi-domain" class="border-2 rounded-full pa-10"></v-icon>
                                            </div>
                                        </v-col>
                                    </v-row>
                                </v-card>
                            </v-col>
                            <v-col cols="12" md="4">
                                <v-card color="green-darken-3" variant="flat" class="px-6 py-8" @click="sort_category = 'abe'">
                                    <v-row class="justify-center">
                                        <v-col>
                                            <p class="text-6xl font-bold">{{ $page.props.enterprises_total.agri_based_total }}</p>
                                            <p class="text-sm mt-2">Agri-based enterprises</p>
                                        </v-col>
                                        <v-col>
                                            <div class="text-4xl text-end">
                                                <v-icon icon="mdi-sprout-outline" class="border-2 rounded-full pa-10"></v-icon>
                                            </div>
                                        </v-col>
                                    </v-row>
                                </v-card>
                            </v-col>
                            <v-col cols="12" md="4">
                                <v-card color="green-darken-4" variant="flat" class="px-6 py-8" @click="sort_category = 'nabe'">
                                    <v-row class="justify-center">
                                        <v-col>
                                            <p class="text-6xl font-bold">{{ $page.props.enterprises_total.non_agri_based_total }}</p>
                                            <p class="text-sm mt-2">Non agri-based enterprises</p>
                                        </v-col>
                                        <v-col>
                                            <div class="text-4xl text-end">
                                                <v-icon icon="mdi-book-open-variant-outline" class="border-2 rounded-full pa-10"></v-icon>
                                            </div>
                                        </v-col>
                                    </v-row>
                                </v-card>
                            </v-col>
                        </v-row>
                    </div>
                 </div> -->


                 <!-- <v-skeleton-loader type="table" class="border-2"></v-skeleton-loader> -->

                 <!-- enterprise list  -->
                  <div>
                    <p class="font-bold text-xl mb-2">Data Table</p>
                    <EnterpriseDataTable :enterprises="enterprises" :sort_category="sort_category"></EnterpriseDataTable>
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
          // {
          //   number: 1,
          //   id: 1,
          //   enterprise: 'Carabao Stud Farm',
          //   type: 'Agri-based'
          // },
          // {
          //   number: 2,
          //   id: 2,
          //   enterprise: 'Fishpond Rental',
          //   type: 'Agri-based'
          // },
          // {
          //   number: 3,
          //   id: 3,
          //   enterprise: 'HVC CBAO',
          //   type: 'Agri-based'
          // },
          // {
          //   number: 4,
          //   id: 4,
          //   enterprise: 'ID Lanyard/Lace',
          //   type: 'Non agri-based'
          // },
          // {
          //   number: 5,
          //   id: 5,
          //   enterprise: 'PE Uniform',
          //   type: 'Non agri-based'
          // },
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