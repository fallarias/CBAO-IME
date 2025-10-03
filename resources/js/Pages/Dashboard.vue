<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import DashboardOverview from './Dashboard/Partials/DashboardOverview.vue';
import IncomeOverview from './Dashboard/Partials/IncomeOverview.vue';
import ExpensesOverview from './Dashboard/Partials/ExpensesOverview.vue';
import AdminIncomeOverview from './Dashboard/Partials/Admin/AdminIncomeOverview.vue';
</script>

<template>
    <Head title="Dashboard" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Enterprises</h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <!-- data overview  -->
                 <div class="mb-12">
                    <p class="font-bold text-xl mb-2">Overview</p>
                    <DashboardOverview></DashboardOverview>
                 </div>

                 <div class="mb-12">

                    <div v-if="$page.props.auth.user.role == 'Admin'">
                        <div class="d-flex justify-between align-center">
                            <p class="font-bold text-xl mb-2">Income</p>
                            <div>
                                <select id="small" class="block w-full p-2 mb-6 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500">
                                    <option disabled>Select campus</option>
                                    <option selected value="all">All Campuses</option>
                                    <option v-for="c in $page.props.campuses" :key="c.id" :value="c.id">{{ c.campus }}</option>
                                </select>
                            </div>
                        </div>
                        <AdminIncomeOverview :campuses="$page.props.campuses"></AdminIncomeOverview>
                    </div>

                    <div v-else>
                        <p class="font-bold text-xl mb-2">Income</p>
                        <!-- <div class="d-flex justify-between align-center">
                            <p class="font-bold text-xl mb-2">Income</p>
                            <div>
                                <select id="small" class="block w-full p-2 mb-6 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500">
                                    <option selected>Choose a country</option>
                                    <option value="US">United States</option>
                                    <option value="CA">Canada</option>
                                    <option value="FR">France</option>
                                    <option value="DE">Germany</option>
                                </select>
                            </div>
                        </div> -->
                        <IncomeOverview></IncomeOverview>
                    </div>
                    
                 </div>

                 <div class="mb-12">
                    <p class="font-bold text-xl mb-2">Expenses</p>
                    <ExpensesOverview></ExpensesOverview>
                 </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
