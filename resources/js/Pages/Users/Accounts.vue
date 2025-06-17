<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Accounts" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">User Accounts</h2>
        </template>

        <div>
            <div class="mx-auto sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items"/>
                </div>
                <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg  border border-stone-200">
                    <div class="p-6 text-gray-900">
                        <v-card flat>
                            <v-card-title class="d-flex align-center pe-2">
                                <v-icon icon="mdi-account-group"></v-icon> &nbsp;
                                Accounts

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
                            :items="items" hover
                            >
                                <template v-slot:header.stock>
                                    <div class="text-end">Stock</div>
                                </template>

                                <template v-slot:item.name="{ item }">
                                    <div class="d-flex align-center">
                                        <v-avatar class="mr-4">
                                            <v-img
                                                :src="`/storage/uploads/avatar/default_avatar.jpg`"
                                                height="64"
                                                cover
                                            ></v-img>
                                        </v-avatar>
                                        <div>
                                            <p class="font-bold">{{ item.name }}</p>
                                            <p class="text-sm text-disabled">user@email.com</p>
                                        </div>
                                    </div>
                                </template>

                                <template v-slot:item.role="{ item }">
                                    <v-chip size="small" label :color="item.role == 'Admin' ? 'green' : 'purple'">{{ item.role }}</v-chip>
                                </template>

                                <template v-slot:item.permission="{ item }">

                                    <div class="d-flex align-center">
                                        <v-chip size="small" color="info" label class="mr-2">{{ item.permission[0] }}</v-chip>
                                        <div v-if="(item.permission).length > 1">
                                            <v-chip size="small" color="info" label class="mr-2" prepend-icon="mdi-plus">{{ item.permission.length - 1}} more</v-chip>
                                        </div>
                                    </div>
                                </template>

                                <template v-slot:item.status="{ item }">
                                    <div class="text-start">
                                    <v-chip
                                        :color="item.status ? 'green' : 'red'"
                                        :text="item.status ? 'Active' : 'Locked'"
                                        class="text-uppercase"
                                        size="small"
                                        label
                                    ></v-chip>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <v-btn variant="tonal" color="info" class="mr-2" icon="mdi-eye" size="x-small"></v-btn>
                                    <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                    <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn>
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
    data () {
      return {
        search: '',
        header: [
            {
                title: 'User',
                align: 'start',
                key: 'name',
                sortable: true,
            },
            {
                title: 'Campus',
                align: 'start',
                key: 'campus',
                sortable: true,
            },
            {
                title: 'Designation/Position',
                align: 'start',
                key: 'designation',
                sortable: true,
            },
            {
                title: 'Role',
                align: 'start',
                key: 'role',
                sortable: true,
            },
            {
                title: 'Permission',
                align: 'start',
                key: 'permission',
                sortable: false,
            },
            {
                title: 'Account Status',
                align: 'start',
                key: 'status',
                sortable: false,
            },
            {
                title: 'Date Created',
                align: 'start',
                key: 'status',
                sortable: false,
            },
            {
                title: 'Action',
                align: 'start',
                key: 'actions',
                sortable: false,
            },
        ],
        items: [
          {
            name: 'John Doe',
            image: '1.png',
            campus: 'Echague',
            designation: 'CBAO Director',
            role: 'Admin',
            permission: ['FULL_ACCESS'],
            status: true,
          },
          {
            name: 'Galaxy RTX 3080',
            image: '2.png',
            campus: 'Ilagan',
            designation: 'CBAO Director',
            role: 'User',
            permission: ['ENTER_PFT_GRADE', 'ENTER_IPME_GRADE', 'ENTER_FPME_GRADE'],
            status: false,
          },
          {
            name: 'Orion RX 6800 XT',
            image: '3.png',
            campus: 'San Mariano',
            designation: 'Information Officer',
            role: 'User',
            permission: ['VALIDATE_DOCUMENT'],
            status: true,
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Setup',
                active: false
            },
            {
                title: 'Accounts',
                active: true
            },
        ]
      }
    },
  }
</script>