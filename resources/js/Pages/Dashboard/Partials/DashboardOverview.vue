<script setup>
import OverviewCard from '@/Components/OverviewCard.vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    monthly_sales: {
        type: Number,
        required: true
    },
    filteredMonth: {
        type: String,
        required: true
    }
});

const overview_data = [
    {
    total: props.monthly_sales,
    title: 'Monthly Sales',
    icon: 'mdi-cash-plus',
    color: 1,
    more_info: true,
    },
    {
    total: '7,234,000',
    title: 'Monthly Expenses',
    icon: 'mdi-cash-minus',
    color: 2,
    more_info: true,
    },
    {
    total: '234',
    title: 'Total IGEs',
    icon: 'mdi-domain',
    color: 3,
    more_info: true,
    },
    {
    total: '87',
    title: 'Total Products',
    icon: 'mdi-store',
    color: 4,
    more_info: true,
    },
]


</script>

<template>
    <v-row dense>

        {{ overview_data[0] }}
        <v-col cols="12" md="3">
            <Link :href="route('income.display')">
                <OverviewCard :data="overview_data[0]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link :href="route('expenses.display')">
                <OverviewCard :data="overview_data[1]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link :href="route('enterprises.display')">
                <OverviewCard :data="overview_data[2]"></OverviewCard>
            </Link>
        </v-col>
        <v-col cols="12" md="3">
            <Link :href="route('inventory.display')">
                <OverviewCard :data="overview_data[3]"></OverviewCard>
            </Link>
        </v-col>
    </v-row>
</template>

<script>
export default {
    data () {
        return {
            
        }
    }
}
</script>