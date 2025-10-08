<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, usePage } from '@inertiajs/vue3';
import DashboardOverview from './Dashboard/Partials/DashboardOverview.vue';
import IncomeOverview from './Dashboard/Partials/IncomeOverview.vue';
import ExpensesOverview from './Dashboard/Partials/ExpensesOverview.vue';
import AdminIncomeOverview from './Dashboard/Partials/Admin/AdminIncomeOverview.vue';
import SelectInput from '@/Components/SelectInput.vue';
import useListFilter from '@/Utils/useListFilter';

const page = usePage()
import { computed, ref } from 'vue'
import OverviewCard from '@/Components/OverviewCard.vue';
import { all } from 'axios';

const overview_data = ref(page.props.incomes)

const filter = ref({
  campus: Number(page.props.auth.user.campus.id) ?? "",
  month: new Date().toLocaleString("en-US", { month: "long" }).toLowerCase(),
  year: new Date().getFullYear(), // e.g., 2025
})

const filteredList = computed(() => {
  console.log("Filtering with:", filter.value)

  // ✅ get data for the selected year (backend key is like 2025, 2024, etc.)
  const yearData = overview_data.value[filter.value.year] || []

  console.log("Data for year", filter.value.year, yearData)

  // ✅ filter by campus (and optionally month, if applicable)
  const result = yearData.filter((income) => {
    console.log({
      incomeCampusId: income.campus_id,
      filterCampus: filter.value.campus,
      match: income.campus_id === Number(filter.value.campus),
    })

    const campusMatch =
      !filter.value.campus || income.campus_id === Number(filter.value.campus)

      // ✅ Month match — checks if the month key exists and has a value
    const monthMatch =
      !filter.value.month ||
      (income[filter.value.month] !== undefined &&
       income[filter.value.month] !== null)

    const yearMatch =
      !filter.value.year ||
      overview_data.value[filter.value.year] !== undefined

    return campusMatch && monthMatch && yearMatch
    
  })

  return result
})

function formatCurrency(value) {
  if (value === null || value === undefined || value === "") return "";
  return Number(value).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}



const overviewData = computed(() => {
    const firstRecord = filteredList.value[0] || {}
    const monthValue = firstRecord?.[filter.value.month] ?? 0
  
    return [
      {
        total: '₱' + formatCurrency(monthValue),
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
        total: firstRecord?.enterprises_total,
        title: 'Total IGEs',
        icon: 'mdi-domain',
        color: 3,
        more_info: true,
      },
      {
        total: firstRecord?.inventories_total,
        title: 'Total Inventory',
        icon: 'mdi-store',
        color: 4,
        more_info: true,
      },
    ]
  })

  const income_filter = ref({
  campus: "",
  month: new Date().toLocaleString("en-US", { month: "long" }).toLowerCase(),
  year: new Date().getFullYear(), // e.g., 2025
})


const labels = ref([])
if (page.props.campuses && Array.isArray(page.props.campuses)) {
    labels.value = page.props.campuses.map(c => c.campus)
} else {
    labels.value = ['Echague', 'Cauayan', 'Cabagan', 'Ilagan', 'Roxas', 'Angadanan', 'Jones']
}


const filteredIncomeData = computed(() => {
    console.log("Filtering with:", income_filter.value)
  
    // ✅ get data for the selected year (backend key is like 2025, 2024, etc.)
    const yearData = overview_data.value[income_filter.value.year] || []
  
    console.log("Data for year", income_filter.value.year, yearData)
  
    // ✅ filter by campus (and optionally month, if applicable)
    const result = yearData.filter((income) => {
      console.log({
        incomeCampusId: income.campus_id,
        filterCampus: income_filter.value.campus,
        match: income.campus_id === Number(filter.value.campus),
      })
  
      const campusMatch =
        !income_filter.value.campus || income.campus_id === Number(income_filter.value.campus)
  
        // ✅ Month match — checks if the month key exists and has a value
      const monthMatch =
        !filter.value.month ||
        (income[income_filter.value.month] !== undefined &&
         income[income_filter.value.month] !== null)
  
      const yearMatch =
        !income_filter.value.year ||
        overview_data.value[income_filter.value.year] !== undefined
  
      return campusMatch && monthMatch && yearMatch
      
    })
  
    return result
  })

const incomeOverviewData = computed(() => {
    const all_data = ref([])
    
    // top five
    const selected_campus_labels_tf = ref([])
    const selected_campus_data_top_five = ref([])
    const firstRecordTF = filteredIncomeData.value[0].top_five || {}
    const monthValueTF = firstRecordTF?.[income_filter.value.month] ?? 0

    // lowest five
    const selected_campus_labels_lf = ref([])
    const selected_campus_data_lowest_five = ref([])
    const firstRecordLF = filteredIncomeData.value[0].lowest_five || {}
    const monthValueLF = firstRecordLF?.[income_filter.value.month] ?? 0

    // Make sure filteredList has data
    if (filteredIncomeData.value.length > 0) {
        for (let i = 0; i <= filteredIncomeData.value.length - 1; i++) {
            const campus = filteredIncomeData.value[i];
            const campusIncome = campus?.[income_filter.value.month] || 0;
            all_data.value.push(campusIncome);
        }

        for (let y = 0; y < monthValueTF.length; y++){
            selected_campus_labels_tf.value.push(monthValueTF[y].enterprise);
            selected_campus_data_top_five.value.push(monthValueTF[y].amount);
            
        }
        for (let y = 0; y < monthValueLF.length; y++){
            selected_campus_labels_lf.value.push(monthValueLF[y].enterprise);
            selected_campus_data_lowest_five.value.push(monthValueLF[y].amount);
        }
    }


    return [
        {
            label: labels,
            data: all_data,
            color: ['#f87979', '#42a5f5', '#66bb6a', '#ffeb3b', '#ff7043', '#8e24aa', '#26c6da', '#795548', '#9C27B0'],
        },
        {
            label: selected_campus_labels_tf,
            data: selected_campus_data_top_five,
            color: ['#4DB6AC', '#26A69A', '#00897B', '#00796B', '#00695C'],
        },
        {
            label: selected_campus_labels_lf,
            data: selected_campus_data_lowest_five,
            color: ['#E57373', '#EF5350', '#E53935', '#D32F2F', '#C62828'],
        },
    ]
})
// 🧩 Define any number of filters you want
// const { list, filter, filteredList } = useListFilter(overview_data.value, {
//   campus: page.props.auth.user.campus.id ?? "",
//   quarter: "",
//   month: new Date().toLocaleString('en-US', { month: 'long' }).toLowerCase(),
//   year: new Date().getFullYear(),
// })

// const handle_change = () => {
//     console.log(filteredList.value)
// }

const months = [
    { value: 'january', label: 'January' },
    { value: 'february', label: 'February' },
    { value: 'march', label: 'March' },
    { value: 'april', label: 'April' },
    { value: 'may', label: 'May' },
    { value: 'june', label: 'June' },
    { value: 'july', label: 'July' },
    { value: 'august', label: 'August' },
    { value: 'september', label: 'September' },
    { value: 'october', label: 'October' },
    { value: 'november', label: 'November' },
    { value: 'december', label: 'December' },
];
</script>

<template>
    <Head title="Dashboard" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Enterprises</h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <!-- {{ incomeOverviewData }} -->
                <!-- data overview  -->
                 <div class="mb-12">
                    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4 gap-4">
                        <p class="font-bold text-xl">Overview</p>

                        <div class="flex flex-col sm:flex-row sm:gap-4 w-full sm:w-auto">
                            <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="filter.campus">
                                <option disabled>Select campus</option>
                                <option v-for="c in $page.props.campuses" :key="c.id" :value="Number(c.id)">{{ c.campus }}</option>
                            </SelectInput>

                            <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="filter.year">
                                <option disabled>Select year</option>
                                <option v-for="y in $page.props.years" :key="y.id" :value="y.id">{{ y.year }}</option>
                            </SelectInput>

                            <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="filter.month">
                                <option disabled>Select month</option>
                                <option v-for="m in months" :key="m.value" :value="m.value">{{ m.label }}</option>
                            </SelectInput>
                        </div>
                    </div>
                    
                    <!-- dashboard overview cards  -->
                    <div>
                        <v-row dense>
                            <v-col cols="12" md="3">
                                <Link :href="route('income.display')">
                                    <OverviewCard :data="overviewData[0]"></OverviewCard>
                                </Link>
                            </v-col>
                            <v-col cols="12" md="3">
                                <Link :href="route('expenses.display')">
                                    <OverviewCard :data="overviewData[1]"></OverviewCard>
                                </Link>
                            </v-col>
                            <v-col cols="12" md="3">
                                <Link :href="route('enterprises.display')">
                                    <OverviewCard :data="overviewData[2]"></OverviewCard>
                                </Link>
                            </v-col>
                            <v-col cols="12" md="3">
                                <Link :href="route('inventory.display')">
                                    <OverviewCard :data="overviewData[3]"></OverviewCard>
                                </Link>
                            </v-col>
                        </v-row>
                    </div>

                    <!-- <DashboardOverview :monthly_sales="formatCurrency(filteredList[0][filter.month])" :filteredMonth="filter.month"></DashboardOverview> -->
                 </div>

                 <div class="mb-12">

                    <div v-if="$page.props.auth.user.role == 'Admin'">
                        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4 gap-4">
                            <p class="font-bold text-xl">Income</p>

                            <div class="flex flex-col sm:flex-row sm:gap-4 w-full sm:w-auto">
                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_filter.campus">
                                    <option disabled>Select campus</option>
                                    <option value="">All Campuses</option>
                                    <option v-for="c in $page.props.campuses" :key="c.id" :value="Number(c.id)">{{ c.campus }}</option>
                                </SelectInput>

                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_filter.year">
                                    <option disabled>Select year</option>
                                    <option v-for="y in $page.props.years" :key="y.id" :value="y.id">{{ y.year }}</option>
                                </SelectInput>

                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_filter.month">
                                    <option disabled>Select month</option>
                                    <option v-for="m in months" :key="m.value" :value="m.value">{{ m.label }}</option>
                                </SelectInput>
                            </div>
                        </div>
                        <AdminIncomeOverview v-if="income_filter.campus == ''" :chartLabels="incomeOverviewData[0].label" :chartData="incomeOverviewData[0].data" chartTitle="Monthly Income" :chartColor="incomeOverviewData[0].color"></AdminIncomeOverview>

                        <div v-else>
                            <div class="mb-4">
                                <p class="font-bold mb-2 text-gray-600">Top 5 Income-Generating Enterprises</p>
                                <AdminIncomeOverview :chartLabels="incomeOverviewData[1].label" :chartData="incomeOverviewData[1].data" chartTitle="Top 5 IGEs" :chartColor="incomeOverviewData[1].color"></AdminIncomeOverview>
                            </div>
                            <div>
                                <p class="font-bold mb-2 text-gray-600">Lowest 5 Income-Generating Enterprises</p>
                                <AdminIncomeOverview :chartLabels="incomeOverviewData[2].label" :chartData="incomeOverviewData[2].data" chartTitle="Lowest 5 IGEs" :chartColor="incomeOverviewData[2].color"></AdminIncomeOverview>
                            </div>
                        </div>
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
