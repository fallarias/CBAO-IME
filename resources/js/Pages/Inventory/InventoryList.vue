<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Product Inventory" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Product Inventory</h2>
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
                                Product Inventory

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
                                    text="Add Product"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add"
                                ></v-btn>
                            </v-card-title>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="products" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>
                                
                                <template v-slot:item.image="{ item }">
                                    <div class="my-2">
                                        <v-img
                                            :src="`/storage/uploads/products/${item.image}`"
                                            height="100" width="100"
                                            cover
                                        ></v-img>
                                    </div>
                                </template>

                                <template v-slot:item.quantity="{item}">
                                    <div>
                                        {{ item.quantity }}
                                        <v-chip label v-if="item.quantity <= 10" color="orange-darken-4" size="small" class="ms-2">Low stock!</v-chip>
                                    </div>
                                </template>

                                <template v-slot:item.product_status="{item}">
                                    <v-chip size="small" class="ma-2" :color="item.product_status == 'Available' ? 'green-darken-3' : 'red-darken-4'" label>{{ item.product_status }}</v-chip>
                                </template>

                                <template v-slot:item.sales="{item}">
                                    <div>
                                        <Link :href="route('inventory.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View Sales</Link>
                                    </div>
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
                title: 'Image',
                align: 'start',
                key: 'image',
                sortable: true,
            },
            {
                title: 'Product',
                align: 'start',
                key: 'product',
                sortable: true,
            },
            {
                title: 'Quantity',
                align: 'center',
                key: 'quantity',
                sortable: true,
            },
            {
                title: 'Price',
                align: 'center',
                key: 'price',
                sortable: true,
            },
            {
                title: 'Status',
                align: 'center',
                key: 'product_status',
                sortable: true,
            },
            {
                title: 'Last Modified',
                align: 'start',
                key: 'last_modified',
                sortable: true,
            },
            {
                title: 'Sales',
                align: 'start',
                key: 'sales',
                sortable: false,
            },
            {
                title: 'Actions',
                align: 'end',
                key: 'actions',
                sortable: false,
            },
        ],
        products: [
          {
            number: 1,
            id: 1,
            image: 'product_placeholder.jpg',
            product: 'ID Lace',
            quantity: 500,
            price: 100,
            product_status: 'Available',
            last_modified: '2025-06-13 8:24 PM'
          },
          {
            number: 2,
            id: 2,
            image: 'product_placeholder.jpg',
            product: 'PE Uniform',
            quantity: 10,
            price: 350,
            product_status: 'Not Available',
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
                active: true
            },
        ]
      }
    },
  }
</script>