<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import DashboardOverview from './Dashboard/Partials/DashboardOverview.vue';
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
            </div>
        </div>
    </AuthenticatedLayout>
</template>
