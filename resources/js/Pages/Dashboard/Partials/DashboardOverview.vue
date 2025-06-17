<script setup>
import OverviewCard from '@/Components/OverviewCard.vue';
import { Link } from '@inertiajs/vue3';

</script>

<template>
    <v-row dense>
        <v-col cols="12" md="3">
            <Link href="#">
                <OverviewCard :data="overview_data[0]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link href="#">
                <OverviewCard :data="overview_data[1]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link href="#">
                <OverviewCard :data="overview_data[2]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link href="#">
                <OverviewCard :data="overview_data[3]"></OverviewCard>
            </Link>
        </v-col>
    </v-row>
</template>

<script>
export default {
    data () {
        return {
            overview_data: [
                {
                    total: '12,234,000',
                    title: 'Monthly Sales',
                    icon: 'mdi-cash-plus',
                    color: 1,
                    more_info: true
                },
                {
                    total: '7,234,000',
                    title: 'Monthly Expenses',
                    icon: 'mdi-cash-minus',
                    color: 2,
                    more_info: true
                },
                {
                    total: '234',
                    title: 'Total IGEs',
                    icon: 'mdi-domain',
                    color: 3,
                    more_info: true
                },
                {
                    total: '87',
                    title: 'Total Products',
                    icon: 'mdi-store',
                    color: 4,
                    more_info: true
                }
            ]
        }
    }
}
</script>