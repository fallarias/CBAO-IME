<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, usePage } from '@inertiajs/vue3';
import DashboardOverview from './Dashboard/Partials/DashboardOverview.vue';
import IncomeOverview from './Dashboard/Partials/IncomeOverview.vue';
import ExpensesOverview from './Dashboard/Partials/ExpensesOverView.vue';
import AdminIncomeOverview from './Dashboard/Partials/Admin/AdminIncomeOverview.vue';
import SelectInput from '@/Components/SelectInput.vue';
import useListFilter from '@/Utils/useListFilter';

const page = usePage()
import { computed, ref, watch, onMounted } from 'vue'
import OverviewCard from '@/Components/OverviewCard.vue';
import { all } from 'axios';
import SampleChart from '@/Components/SampleChart.vue';
import LineChart from '@/Components/Charts/LineChart.vue';
import BarChart from '@/Components/Charts/BarChart.vue';
import AreaChart from '@/Components/Charts/AreaChart.vue';
import ColumnChart from '@/Components/Charts/ColumnChart.vue';
import PieChart from '@/Components/Charts/PieChart.vue';

const overview_data = ref(page.props.incomes)
const expenses_overview_data = ref(page.props.expenses)

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
        total: '₱0.00',
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

const income_and_expenses_comp = ref({
    campus: Number(page.props.auth.user.campus.id) ?? "",
    months: 0,
    year: new Date().getFullYear(), // e.g., 2025
})

const filterIncomeExpenseComparison = computed(() => {
  
    const campus = Number(income_and_expenses_comp.value.campus);
    const months = Number(income_and_expenses_comp.value.months); // ✅ cast to number
    const year = income_and_expenses_comp.value.year;
  
    const incomeData = overview_data.value[year] || [];
    const expenseData = page.props.expenses?.[year] || [];
  
    // ✅ Filter by campus
    const filteredIncome = incomeData.filter(
      (record) => !campus || record.campus_id === campus
    );
    const filteredExpense = expenseData.filter(
      (record) => !campus || record.campus_id === campus
    );
  
    const monthsFull = [
      "january", "february", "march", "april", "may", "june",
      "july", "august", "september", "october", "november", "december",
    ];
    const monthsShort = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
  
    // ✅ Determine biannual range
    const start = months === 0 ? 0 : 6;
    const end = months === 0 ? 6 : 12;
  
    const selectedMonthsFull = monthsFull.slice(start, end);
    const selectedMonthsShort = monthsShort.slice(start, end);
  
    // ✅ Compute monthly totals for the selected months
    const incomeTotals = Array(selectedMonthsFull.length).fill(0);
    const expenseTotals = Array(selectedMonthsFull.length).fill(0);
  
    filteredIncome.forEach((record) => {
      selectedMonthsFull.forEach((month, i) => {
        incomeTotals[i] += Number(record[month]) || 0;
      });
    });
  
    filteredExpense.forEach((record) => {
      selectedMonthsFull.forEach((month, i) => {
        expenseTotals[i] += Number(record[month]) || 0;
      });
    });
  
    // ✅ Compute overall totals for the ENTIRE year (not limited to 6 months)
    let totalIncomeYear = 0;
    let totalExpenseYear = 0;
  
    filteredIncome.forEach((record) => {
      monthsFull.forEach((month) => {
        totalIncomeYear += Number(record[month]) || 0;
      });
    });
  
    filteredExpense.forEach((record) => {
      monthsFull.forEach((month) => {
        totalExpenseYear += Number(record[month]) || 0;
      });
    });
  
    // ✅ Determine campus name
    let campusName = "All Campuses";
    const selectedCampusId = campus;
    const campusesArray = Array.isArray(page.props.campuses)
      ? page.props.campuses
      : Array.isArray(page.props.campus)
      ? page.props.campus
      : null;
  
    if (campusesArray) {
      const selectedCampus = campusesArray.find(c => Number(c.id) === selectedCampusId);
      if (selectedCampus) {
        campusName = selectedCampus.campus ?? selectedCampus.name ?? "Unknown Campus";
      }
    }
  
    const result = {
      campusName,
      categories: selectedMonthsShort,
      incomes: incomeTotals,
      expenses: expenseTotals,
      overallIncomeTotal: totalIncomeYear,      // ✅ now full year total
      overallExpensesTotal: totalExpenseYear,   // ✅ now full year total
    };
  
    return result;
  });
 
let income_and_expenses_comp_category = [];

watch(
  () => income_and_expenses_comp.value.months,
  (newValue) => {
    if (newValue === 0) {
      income_and_expenses_comp_category = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      ];
    } else {
      income_and_expenses_comp_category = [
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
      ];
    }
  },
  { immediate: true }
);


// expenses chart
const expenses_chart_filter = ref({
    campus: 0,
    months: 0,
    year: new Date().getFullYear(), // e.g., 2025
})

// Overall income overview (for "All Campuses" view)
const expenses_default_data = ref([
  {
    label: [
      "Echague",
      "Cabagan",
      "Cauayan",
      "Ilagan",
      "Roxas",
      "Angadanan",
      "Jones",
      "San Mateo",
      "San Mariano",
    ],
    data: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  },
]);

const filterExpensesData = computed(() => {
  const campus = Number(expenses_chart_filter.value.campus);
  const year = expenses_chart_filter.value.year;

  const monthsFull = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
  ];

  const monthLabels = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  const overview = expenses_overview_data.value[year] || [];

  // === Fixed colors for charts ===
  const campusColors = [
    "#fecaca",
    "#fca5a5",
    "#f87171",
    "#ef4444",
    "#dc2626",
    "#b91c1c",
    "#991b1b",
    "#7f1d1d",
    "#450a0a",
  ];

  const monthColors = [
    "#1A56DB",
    "#16BDCA",
    "#7E3BF2",
    "#F05252",
    "#F59E0B",
    "#10B981",
    "#6366F1",
    "#EC4899",
    "#84CC16",
    "#E11D48",
    "#06B6D4",
    "#8B5CF6",
  ];

  // === CASE 1: campus == 0 → Show total per campus overview ===

  const all_campus_overall_income = ref([])
  
  if (campus === 0) {
    const expenses_data = Array.isArray(overview) ? overview : [];

    // ✅ Create the data points
    const dataPoints = expenses_data.map((record, i) => {
      const total = monthsFull.reduce((sum, month) => {
        return sum + Number(record?.[month] || 0);
      }, 0);

      return {
        x: record?.campus_name ?? `Campus ${i + 1}`,
        y: total,
        fillColor: campusColors[i] ?? "#ccc",
      };
    });

    return {
      campusName: "All",
      series: [
        {
          name: "All Campuses",
          data: dataPoints,
        },
      ],
    };
  }

  // === CASE 2: campus != 0 → Show monthly breakdown ===
  const filtered_expenses = overview.filter((record) => record.campus_id === campus);
  let total_expenses_year = 0;
  const expenses_total = Array(monthsFull.length).fill(0);
  filtered_expenses.forEach((record) => {
    monthsFull.forEach((month, i) => {
      expenses_total[i] += Number(record[month]) || 0;
      total_expenses_year += Number(record[month]) || 0;
    });
  });

  const selectedCampus = filtered_expenses[0]?.campus_name || "Unknown Campus";

  const dataPoints = monthLabels.map((month, i) => ({
    x: month,
    y: expenses_total[i],
    fillColor: monthColors[i] ?? "#ccc",
  }));

  return {
    campusName: selectedCampus,
    total_income: total_expenses_year,
    series: [
      {
        name: selectedCampus,
        data: dataPoints,
      },
    ],
  };
});
// end of income filtering


// income filtering
const income_chart_filter = ref({
    campus: 0,
    months: 0,
    year: new Date().getFullYear(), // e.g., 2025
})

// Overall income overview (for "All Campuses" view)
const income_default_data = ref([
  {
    label: [
      "Echague",
      "Cabagan",
      "Cauayan",
      "Ilagan",
      "Roxas",
      "Angadanan",
      "Jones",
      "San Mateo",
      "San Mariano",
    ],
    data: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  },
]);

const filterIncomeData = computed(() => {
  const campus = Number(income_chart_filter.value.campus);
  const year = income_chart_filter.value.year;

  const monthsFull = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
  ];

  const monthLabels = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  const overview = overview_data.value[year] || [];

  // === Fixed colors for charts ===
  const campusColors = [
    "#a7f3d0",
    "#6ee7b7",
    "#34d399",
    "#10b981",
    "#059669",
    "#047857",
    "#065f46",
    "#064e3b",
    "#022c22",
  ];

  const monthColors = [
    "#1A56DB",
    "#16BDCA",
    "#7E3BF2",
    "#F05252",
    "#F59E0B",
    "#10B981",
    "#6366F1",
    "#EC4899",
    "#84CC16",
    "#E11D48",
    "#06B6D4",
    "#8B5CF6",
  ];

  // === CASE 1: campus == 0 → Show total per campus overview ===
  if (campus === 0) {
    const income_data = Array.isArray(overview) ? overview : [];

    // ✅ Create the data points
    const dataPoints = income_data.map((record, i) => {
      const total = monthsFull.reduce((sum, month) => {
        return sum + Number(record?.[month] || 0);
      }, 0);

      return {
        x: record?.campus_name ?? `Campus ${i + 1}`,
        y: total,
        fillColor: campusColors[i] ?? "#ccc",
      };
    });

    return {
      campusName: "All",
      series: [
        {
          name: "All Campuses",
          data: dataPoints,
        },
      ],
    };
  }

  // === CASE 2: campus != 0 → Show monthly breakdown ===
  const filteredIncome = overview.filter((record) => record.campus_id === campus);
  let totalIncomeYear = 0;
  const incomeTotals = Array(monthsFull.length).fill(0);
  filteredIncome.forEach((record) => {
    monthsFull.forEach((month, i) => {
      incomeTotals[i] += Number(record[month]) || 0;
      totalIncomeYear += Number(record[month]) || 0;
    });
  });

  const selectedCampus = filteredIncome[0]?.campus_name || "Unknown Campus";
  // Extract top five enterprises
  const top_five_data = filteredIncome[0]?.top_five?.overall || [];
  const lowest_five_data = filteredIncome[0]?.lowest_five?.overall || [];

  // Generate random pastel colors
  const getRandomColor = () =>
  `#${Math.floor(Math.random() * 16777215).toString(16).padStart(6, "0")}`;

  // Build the pie chart data structure
  const top_five = [
    {
      series: top_five_data.map((item) => Number(item.amount) || 0),
      colors: top_five_data.map(() => getRandomColor()),
      labels: top_five_data.map((item) => item.enterprise),
    },
  ];

  const lowest_five = [
    {
      series: lowest_five_data.map((item) => Number(item.amount) || 0),
      colors: lowest_five_data.map(() => getRandomColor()),
      labels: lowest_five_data.map((item) => item.enterprise),
    },
  ];

  const dataPoints = monthLabels.map((month, i) => ({
    x: month,
    y: incomeTotals[i],
    fillColor: monthColors[i] ?? "#ccc",
  }));

  return {
    campusName: selectedCampus,
    total_income: totalIncomeYear,
    top_five: top_five[0] ?? [],
    lowest_five: lowest_five[0] ?? [],
    series: [
      {
        name: selectedCampus,
        data: dataPoints,
      },
    ],
  };
});
// end of income filtering

const selectedCampus = computed(() => Number(income_chart_filter.value.campus));

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

                 <!-- <div class="mb-12">

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
                        <IncomeOverview></IncomeOverview>
                    </div>
                    
                 </div> -->

                 <!-- <div class="mb-12">
                    <p class="font-bold text-xl mb-2">Expenses</p>
                    <ExpensesOverview></ExpensesOverview>
                 </div> -->

                 <div class="mb-12">
                    <div>
                      {{ filterIncomeData.top_five }}
                        <p class="font-bold text-xl mb-2">Income</p>
                        <v-divider></v-divider>
                        <div class="flex justify-between align-center">
                            <div>
                                <p class="text-xl font-bold text-gray-700">{{ filterIncomeData.campusName }} Campus</p>
                                <p v-if="filterIncomeData.total_income" class="text-disabled">Current: <span :class="[(filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) > 0 ? 'text-teal-700 font-bold' : (filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) < 0
                                    ? 'text-red-700 font-bold'
                                    : 'text-gray-700 font-bold'
                                ]"
                                >₱{{ formatCurrency(filterIncomeData.total_income) }}</span></p>
                            </div>
                            <div class="flex flex-col sm:flex-row sm:gap-4 w-full sm:w-auto">
                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_chart_filter.campus">
                                    <option disabled>Select campus</option>
                                    <option :value="0">All Campus</option>
                                    <option v-for="c in $page.props.campuses" :key="c.id" :value="Number(c.id)">{{ c.campus }}</option>
                                </SelectInput>
                                <!-- <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_chart_filter.months">
                                    <option disabled>Select months</option>
                                    <option :value="0">January - June</option>
                                    <option :value="1">July - December</option>
                                </SelectInput> -->
                            </div>
                        </div>
                        <v-card elevation="0" class="border border-gray-500 px-8 py-8 mt-4">
                            <!-- <AreaChart></AreaChart> -->
                             <ColumnChart :series="filterIncomeData.series"></ColumnChart>
                        </v-card>
                    </div>

                    <div v-if="selectedCampus !== 0" class="mt-6">
                      <div class="grid grid-cols-2 gap-6 w-full">
                        <!-- First Chart -->
                        <div class="p-4 bg-white rounded-2xl shadow flex flex-col items-center">
                          <p class="font-semibold mb-4 text-gray-700 text-center">Top 5</p>
                          <div class="w-full max-w-[350px]">
                            <PieChart :data="filterIncomeData.top_five"/>
                          </div>
                        </div>

                        <!-- First Chart -->
                        <div class="p-4 bg-white rounded-2xl shadow flex flex-col items-center">
                          <p class="font-semibold mb-4 text-gray-700 text-center">Lowest 5</p>
                          <div class="w-full max-w-[350px]">
                            <PieChart :data="filterIncomeData.lowest_five"/>
                          </div>
                        </div>
                      </div>
                    </div>
                 </div>

                 <div class="mb-12">
                    <div>
                        <p class="font-bold text-xl mb-2">Expenses</p>
                        <v-divider></v-divider>
                        <div class="flex justify-between align-center">
                            <div>
                                <p class="text-xl font-bold text-gray-700">{{ filterExpensesData.campusName }} Campus</p>
                                <p v-if="filterExpensesData.total_income" class="text-disabled">Current: <span :class="[(filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) > 0 ? 'text-teal-700 font-bold' : (filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) < 0
                                    ? 'text-red-700 font-bold'
                                    : 'text-gray-700 font-bold'
                                ]"
                                >₱{{ formatCurrency(filterExpensesData.total_income) }}</span></p>
                            </div>
                            <div class="flex flex-col sm:flex-row sm:gap-4 w-full sm:w-auto">
                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="expenses_chart_filter.campus">
                                    <option disabled>Select campus</option>
                                    <option :value="0">All Campus</option>
                                    <option v-for="c in $page.props.campuses" :key="c.id" :value="Number(c.id)">{{ c.campus }}</option>
                                </SelectInput>
                                <!-- <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="expenses_chart_filter.months">
                                    <option disabled>Select months</option>
                                    <option :value="0">January - June</option>
                                    <option :value="1">July - December</option>
                                </SelectInput> -->
                            </div>
                        </div>
                        <v-card elevation="0" class="border border-gray-500 px-8 py-8 mt-4 w-full">
                            <!-- <AreaChart></AreaChart> -->
                             <ColumnChart :series="filterExpensesData.series"></ColumnChart>
                        </v-card>
                    </div>
                 </div>

                 <div class="mb-12">
                    <div>
                        <p class="font-bold text-xl mb-2">Income and Expenses Comparison</p>
                        <!-- {{ filterIncomeExpenseComparison }} -->
                        <v-divider></v-divider>
                        <div class="flex justify-between align-center">
                            <div>
                                <p class="text-xl font-bold text-gray-700">{{ filterIncomeExpenseComparison.campusName }} Campus</p>
                                <p class="text-disabled">Profit: <span :class="[(filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) > 0 ? 'text-teal-700 font-bold' : (filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) < 0
                                    ? 'text-red-700 font-bold'
                                    : 'text-gray-700 font-bold'
                                ]"
                                >₱{{ formatCurrency(filterIncomeExpenseComparison.overallIncomeTotal - filterIncomeExpenseComparison.overallExpensesTotal) }}</span></p>
                            </div>
                            <div class="flex flex-col sm:flex-row sm:gap-4 w-full sm:w-auto">
                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_and_expenses_comp.campus">
                                    <option disabled>Select campus</option>
                                    <option v-for="c in $page.props.campuses" :key="c.id" :value="Number(c.id)">{{ c.campus }}</option>
                                </SelectInput>
                                <SelectInput class="max-w-sm w-full min-w-[200px]" v-model="income_and_expenses_comp.months">
                                    <option disabled>Select months</option>
                                    <option :value="0">January - June</option>
                                    <option :value="1">July - December</option>
                                </SelectInput>
                            </div>
                        </div>
                        <v-card elevation="0" class="border border-gray-500 px-8 py-8 mt-4">
                            <BarChart :data="filterIncomeExpenseComparison"></BarChart>
                        </v-card>
                    </div>
                 </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
