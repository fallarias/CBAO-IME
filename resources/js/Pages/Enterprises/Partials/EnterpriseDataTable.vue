<template>
    <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg  border border-stone-200">
        <div class="p-6 text-gray-900">
            <v-card flat>
                <v-card-title class="d-flex align-center pe-2">
                    <v-icon icon="mdi-account-group"></v-icon> &nbsp;
                    Business Enterprises

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
                        text="Add IGE"
                        variant="flat"
                        color="green-darken-4"
                        @click="add"
                    ></v-btn>
                </v-card-title>

                <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                <v-data-table
                    v-model:search="search"
                    :filter-keys="['name']" :headers="header"
                    :items="enterprises" hover :loading="loading"
                >
                    <template v-slot:loading>
                        <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                    </template>

                    <template v-slot:item.number="{item}">
                        <div class="text-start">{{ item.number }}</div>
                    </template>

                    <template v-slot:item.enterprise="{item}">
                        <div>
                            <Link href="#" class="hover:text-blue-500 hover:font-bold hover:underline">
                                {{ item.enterprise }}
                                <br>
                                <!-- <span class="text-small text-gray-500 hidden hover:block">View Record</span> -->
                            </Link>
                        </div>
                    </template>

                    <template v-slot:item.type="{item}">
                        <v-chip class="ma-2" :color="item.type == 'Agri-based' ? 'green-darken-3' : 'lime-darken-4'" label>
                            <v-icon :icon="item.type == 'Agri-based' ? 'mdi-sprout' : 'mdi-book-open-variant-outline'" start></v-icon>
                            {{ item.type }}
                        </v-chip>
                    </template>

                    <template v-slot:item.account_ledgers="{item}">
                        <div class="text-center">
                            <Link :href="route('enterprises.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View Ledgers</Link>
                        </div>
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
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
</script>

<script>
export default {
    props: {
        enterprises: {
            type: Array,
            required: true,
        },
    },
    data(){
        return {
            search: '',
            loading: false,
            header: [
                {
                    title: '#',
                    align: 'start',
                    key: 'number',
                    sortable: false,
                },
                {
                    title: 'Business Enterprise',
                    align: 'start',
                    key: 'enterprise',
                    sortable: true,
                },
                {
                    title: 'Type',
                    align: 'center',
                    key: 'type',
                    sortable: true,
                },
                {
                    title: 'Account Ledgers',
                    align: 'center',
                    key: 'account_ledgers',
                    sortable: true,
                },
                {
                    title: 'Actions',
                    align: 'end',
                    key: 'actions',
                    sortable: false,
                },
            ]
        }
    },
    methods: {
        onClick() {
            this.loading = true
            setTimeout(() => {
                this.loading = false
            }, 1000)
        }
    }
}
</script>