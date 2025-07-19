<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Product Inventory" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">ID Lace Sales Record</h2>
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
                                ID Lace Sales Record

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
                                    text="Add Sales"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_sales_dialog = true"
                                ></v-btn>
                            </v-card-title>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="product_sales" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
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

                    <!-- dialogs here  -->
                    <div>
                        <!-- add sales  -->
                         <v-dialog v-model="add_sales_dialog" persistent max-width="800">
                            <v-card prepend-icon="mdi-package" title="Add Sales" class="pa-2">
                                <v-card-text>

                                    <v-row>
                                        <v-col>Product: ID Lace</v-col>
                                    </v-row>
                                    <v-row>
                                        <v-col>
                                            <v-number-input
                                                :reverse="false"
                                                controlVariant="default"
                                                label="Quantity"
                                                :hideInput="false"
                                                :inset="false"
                                                variant="outlined"
                                                v-model="add_product_sales.quantity"
                                            ></v-number-input>
                                        </v-col>
                                        <v-col>
                                            <v-number-input
                                                v-model="add_product_sales.total_sales"
                                                :reverse="false"
                                                controlVariant="default"
                                                label="Sales"
                                                :hideInput="false"
                                                :inset="false"
                                                variant="outlined"
                                                :precision="2"
                                                @click="compute_sales"
                                                readonly
                                            ></v-number-input>
                                        </v-col>
                                    </v-row>
                                </v-card-text>
                                <v-divider></v-divider>
                                <v-card-actions>
                                    <v-spacer></v-spacer>
                                    <v-btn
                                        text="Cancel"
                                        variant="plain"
                                        @click="add_sales_dialog = false"
                                    ></v-btn>

                                    <v-btn
                                        color="primary"
                                        text="Save"
                                        variant="tonal"
                                        @click="add_sales"
                                    ></v-btn>
                                </v-card-actions>
                            </v-card>
                         </v-dialog>
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
        add_sales_dialog: false,
        add_product_sales: {
            price: 100,
            quantity: null,
            total_sales: null
        },
        header: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'Date Added',
                align: 'start',
                key: 'date_added',
                sortable: true,
            },
            {
                title: 'Quantity',
                align: 'center',
                key: 'quantity',
                sortable: true,
            },
            {
                title: 'Total Sales',
                align: 'center',
                key: 'total_sales',
                sortable: true,
            },
            {
                title: 'Last Modified',
                align: 'start',
                key: 'last_modified',
                sortable: true,
            },
            {
                title: 'Actions',
                align: 'end',
                key: 'actions',
                sortable: false,
            },
        ],
        product_sales: [
          {
            number: 1,
            id: 1,
            date_added: '2025-06-13 8:24 PM',
            quantity: 25,
            total_sales: 100*25,
            last_modified: '2025-06-13 8:24 PM'
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Transaction',
                active: false
            },
            {
                title: 'Inventory',
                active: false
            },
            {
                title: 'ID Lace',
                active: true
            },
        ]
      }
    },
    methods: {
        compute_sales(){
            this.add_product_sales.total_sales = this.add_product_sales.quantity * this.add_product_sales.price;
        }
    }
  }
</script>