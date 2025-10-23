<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, router, useForm, usePage } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { nextTick, ref, watch, computed, reactive, onMounted } from 'vue';

const page = usePage()
const loading = ref(false)
const search = ref('')

// filtering
const income_list = ref(page.props.incomes)

// 🧩 Define any number of filters you want
const { list, filter, filteredList } = useListFilter(income_list.value, {
  campus: "",
  quarter: "",
  year: new Date().getFullYear(),
})

const allHeaders = [
  { title: "#", align: "start", key: "number" },
  { title: "Campus", align: "start", key: "campus" },
  { title: "Enterprise", align: "start", key: "enterprise" },
  { title: `${filter.value.year - 1} Continuing`, align: "start", key: "continuing" },
  { title: "January", align: "start", key: "january" },
  { title: "February", align: "start", key: "february" },
  { title: "March", align: "start", key: "march" },
  { title: "April", align: "start", key: "april" },
  { title: "May", align: "start", key: "may" },
  { title: "June", align: "start", key: "june" },
  { title: "July", align: "start", key: "july" },
  { title: "August", align: "start", key: "august" },
  { title: "September", align: "start", key: "september" },
  { title: "October", align: "start", key: "october" },
  { title: "November", align: "start", key: "november" },
  { title: "December", align: "start", key: "december" },
  { title: `${filter.value.year} Current`, align: "start", key: "current" },
  { title: "Last Modified", align: "center", key: "last_modified" },
  { title: "Actions", align: "end", key: "actions" },
];

// 🧠 setup composable
// const { list, filter, filteredList } = useListFilter(income_list.value, {
//   campus: "",
//   status: "",
//   year: new Date().getFullYear(),
//   quarter: "All",
// });

// 🗓️ Define months per quarter
const quarterMonths = {
  All: [
    "january","february","march","april","may","june",
    "july","august","september","october","november","december"
  ],
  Q1: ["january", "february", "march"],
  Q2: ["april", "may", "june"],
  Q3: ["july", "august", "september"],
  Q4: ["october", "november", "december"],
};

// 🧩 Computed headers based on selected quarter
const tableHeaders = computed(() => {
  // base columns always shown
  const baseCols = ["number", "campus", "enterprise", "continuing", "current", "last_modified", "actions"];
  const selectedQuarter = filter.value.quarter || "All";
  const months = quarterMonths[selectedQuarter] || quarterMonths["All"];

  return allHeaders.filter(
    (h) => baseCols.includes(h.key) || months.includes(h.key)
  );
});
// const filter = ref({
//     campus: '',
//     year: new Date().getFullYear()
// })

// import existing iges
const import_enterprises_dialog = ref(false);
const is_importing = ref(false);
const import_progress = ref(0);

const import_enterprise_form = useForm({
    campus_id: page.props.auth.user.campus.id
})

const handle_import_enterprises = () => {

    // Trigger backend route (Laravel: route('income.import'))
    import_enterprise_form.post(route("income.import"), {
        onSuccess: () => {
            import_enterprises_dialog.value = false;
        },
    });
};

const handle_redirect = () => {
    router.get(route('enterprises.display'));
};
// end import existing iges

// add income
const add_income_dialog = ref(false)
const add_income_form = useForm({
    year: new Date().getFullYear(),
    enterprise: '',
    income_id: '',
    continuing: '', 
    january: '',
    february: '',
    march: '',
    april: '',
    may: '',
    june: '',
    july: '',
    august: '',
    september: '',
    october: '',
    november: '',
    december: '',
    current: ''
})
// end add income

// edit income
const monthly_text_fields = [
    { text: 'January', value: 'january' },
    { text: 'February', value: 'february' },
    { text: 'March', value: 'march' },
    { text: 'April', value: 'april' },
    { text: 'May', value: 'may' },
    { text: 'June', value: 'june' },
    { text: 'July', value: 'july' },
    { text: 'August', value: 'august' },
    { text: 'September', value: 'september' },
    { text: 'October', value: 'october' },
    { text: 'November', value: 'november' },
    { text: 'December', value: 'december' }
]

const edit_income_dialog = ref(false)
const edit_income_form = useForm({
    income_id: '',
    campus_id: page.props.auth.user.campus.id,
    enterprise_id: '',
    enterprise: '',
    continuing: 0.00,
    january: 0.00,
    february: 0.00,
    march: 0.00,
    april: 0.00,
    may: 0.00,
    june: 0.00,
    july: 0.00,
    august: 0.00,
    september: 0.00,
    october: 0.00,
    november: 0.00,
    december: 0.00,
    current: 0.00
})
// 🗓️ Get the current month (0 = Jan, 9 = Oct, etc.)
const currentMonthIndex = new Date().getMonth()

// 🧩 Separate display layer for formatted text
const formattedFields = reactive({});

// 💡 Helper: format with commas and two decimals max
function formatWithCommas(value) {
  if (value === null || value === undefined || value === "") return "";
  const parts = value.toString().split(".");
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  if (parts.length > 1) {
    return `${parts[0]}.${parts[1].slice(0, 2)}`;
  }
  return parts[0];
}


// 🎯 Handle input — keep numeric in form, formatted in view
function onInput(event, key) {
  const raw = event.target.value.replace(/,/g, "");
  const numeric = raw === "" ? 0 : parseFloat(raw);

  // Save raw numeric value
  edit_income_form[key] = isNaN(numeric) ? 0 : numeric;

  // Show formatted value
  formattedFields[key] = formatWithCommas(raw);

  updateCurrent();
}

// 🧮 Update total current (sum of all months)
function updateCurrent() {
  let total = 0;

  monthly_text_fields.forEach(({ value }) => {
    const val = parseFloat(edit_income_form[value]) || 0;
    total += val;
  });

  // numeric only in form
  edit_income_form.current = parseFloat(total.toFixed(2));

  // formatted display for disabled input
  formattedFields.current = formatWithCommas(edit_income_form.current);
}

// 🧠 Initialize formatted fields after component mounts
onMounted(() => {
  for (const key in edit_income_form) {
    if (Object.hasOwn(edit_income_form, key)) {
      formattedFields[key] = formatWithCommas(edit_income_form[key]);
    }
  }
});

const handle_edit_income = (income_id) => {
    const income = page.props.incomes.find(
        (i) => i.id === income_id
    )

    if (income) {
        edit_income_form.income_id = income.id
        edit_income_form.enterprise_id = income.enterprise_id
        edit_income_form.enterprise = income.enterprise
        edit_income_form.continuing = income.continuing
        edit_income_form.january = income.january
        edit_income_form.february = income.february
        edit_income_form.march = income.march
        edit_income_form.april = income.april
        edit_income_form.may = income.may
        edit_income_form.june = income.june
        edit_income_form.july = income.july
        edit_income_form.august = income.august
        edit_income_form.september = income.september
        edit_income_form.october = income.october
        edit_income_form.november = income.november
        edit_income_form.december = income.december
        edit_income_form.current = income.current

        // Initialize formatted fields
        formattedFields.continuing = formatWithCommas(edit_income_form.continuing);
        formattedFields.january = formatWithCommas(edit_income_form.january);
        formattedFields.february = formatWithCommas(edit_income_form.february);
        formattedFields.march = formatWithCommas(edit_income_form.march);
        formattedFields.april = formatWithCommas(edit_income_form.april);
        formattedFields.may = formatWithCommas(edit_income_form.may);
        formattedFields.june = formatWithCommas(edit_income_form.june);
        formattedFields.july = formatWithCommas(edit_income_form.july);
        formattedFields.august = formatWithCommas(edit_income_form.august);
        formattedFields.september = formatWithCommas(edit_income_form.september);
        formattedFields.october = formatWithCommas(edit_income_form.october);
        formattedFields.november = formatWithCommas(edit_income_form.november);
        formattedFields.december = formatWithCommas(edit_income_form.december);
        formattedFields.current = formatWithCommas(edit_income_form.current);

        edit_income_dialog.value = true
    }
}

const update_income = () => {
    // console.log(edit_income_form)
    edit_income_form.put(route('income.update', edit_income_form.income_id), {
        onSuccess: () => {
            edit_income_dialog.value = false
        },
    })
}
// end edit income

// format the numbers to be displayed on the table
function formatCurrency(value) {
  if (value === null || value === undefined || value === "") return "";
  return Number(value).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}
// end

// pdf section
const current_user = {
  name: `${page.props.auth.user.first_name} ${page.props.auth.user.last_name}`,
  campus: page.props.auth.user.campus.campus,
  role: page.props.auth.user.role
};

const pdfSection = ref(null);
const isExporting = ref(false);
const pdf_headers = ['#', 'Campus', 'Enterprise', `${filter.value.year - 1} Continuing`, 'Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.', `${filter.value.year} Current`, 'Added/Submitted By']

// const column_styles = Object.fromEntries(
//   pdf_headers.map((_, i) => [i, { cellWidth: 270 / pdf_headers.length }])
// );

const column_styles = {
  0: { cellWidth: 8, halign: "center" },   // #
  1: { cellWidth: 20 },                    // Campus
  2: { cellWidth: 35 },                    // Enterprise
  3: { cellWidth: 25, halign: "right" },   // Continuing
  4: { cellWidth: 15, halign: "right" },   // January
  5: { cellWidth: 15, halign: "right" },   // February
  6: { cellWidth: 15, halign: "right" },   // March
  7: { cellWidth: 15, halign: "right" },   // April
  8: { cellWidth: 15, halign: "right" },   // May
  9: { cellWidth: 15, halign: "right" },   // June
  10: { cellWidth: 15, halign: "right" },  // July
  11: { cellWidth: 15, halign: "right" },  // August
  12: { cellWidth: 15, halign: "right" },  // September
  13: { cellWidth: 15, halign: "right" },  // October
  14: { cellWidth: 15, halign: "right" },  // November
  15: { cellWidth: 15, halign: "right" },  // December
  16: { cellWidth: 25, halign: "right" },  // Current
  17: { cellWidth: 35 },                   // Added/Submitted By
};

const export_pdf_report = () => {
  generatePDF({
    reportTitle: "Report of Monthly Income Per Enterprise",
    isExporting,
    currentUser: current_user,
    headers: pdf_headers,
    orientation: 'l',
    tableOptions: { columnStyles: column_styles },
    pageSize: 'legal',
    rows: filteredList.value.map((item, index) => [
      index + 1,
      item.campus,
      item.enterprise,
      formatCurrency(item.continuing),
      formatCurrency(item.january),
      formatCurrency(item.february),
      formatCurrency(item.march),
      formatCurrency(item.april),
      formatCurrency(item.may),
      formatCurrency(item.june),
      formatCurrency(item.july),
      formatCurrency(item.august),
      formatCurrency(item.september),
      formatCurrency(item.october),
      formatCurrency(item.november),
      formatCurrency(item.december),
      formatCurrency(item.current),
      `${item.updated_by} | ${item.date}`
    ]),
  });
};
// end of pdf section

// excel section
// Excel headers
const excel_headers = ['#', 'Campus', 'Enterprise', `${filter.value.year - 1} Continuing`, 'Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.', `${filter.value.year} Current`, 'Added/Submitted By'];

// Export handler
const export_excel_report = () => {
  // Use .value because it's a computed ref
  const excelData = filteredList.value.map((item, index) => ({
    '#': index + 1,
    'Campus': item.campus || '-',
    'Enterprise': item.enterprise || '-',
    [`${filter.value.year - 1} Continuing`]: formatCurrency(item.continuing),
    'Jan.': formatCurrency(item.january),
    'Feb.': formatCurrency(item.february),
    'Mar.': formatCurrency(item.march),
    'Apr.': formatCurrency(item.april),
    'May': formatCurrency(item.may),
    'Jun.': formatCurrency(item.june),
    'Jul.': formatCurrency(item.july),
    'Aug.': formatCurrency(item.august),
    'Sep.': formatCurrency(item.september),
    'Oct.': formatCurrency(item.october),
    'Nov.': formatCurrency(item.november),
    'Dec.': formatCurrency(item.december),
    [`${filter.value.year} Current`]: formatCurrency(item.current),
    'Added/Submitted By': `${item.updated_by} | ${item.date}`,
  }));

  exportExcel(excelData, excel_headers, "Monthly_Income_Report");
};
// end of excel section

useFlashWatcher('income.display')
</script>

<template>
    <Head title="Income" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Income</h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items"/>
                </div>

                <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg  border border-stone-200">
                    <div class="p-6 text-gray-900">
                        <v-card flat>
                            <v-card-title class="d-flex align-center pe-2 justify-space-between">
                                <!-- Left Section: Icon + Text -->
                                <div class="d-flex align-center pe-2" @click="import_enterprises_dialog = true">
                                    <v-icon
                                        :size="$vuetify.display.smAndDown ? 18 : 24"
                                        class="me-2 font-weight-bold"
                                    >
                                        mdi-import
                                    </v-icon>
                                    <span
                                        :class="$vuetify.display.smAndDown ? 'text-lg font-weight-semibold' : 'text-2xl font-weight-semibold'"
                                    >
                                        Income
                                    </span>
                                </div>

                                <!-- Right Section: Responsive Button -->
                                <div>
                                <!-- Full button for medium and up -->
                                <v-btn
                                    v-if="!$vuetify.display.smAndDown"
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-import"
                                    rounded="l"
                                    text="Import Enterprises"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="import_enterprises_dialog = true"
                                ></v-btn>

                                <!-- Icon-only button for small devices -->
                                <v-btn
                                    v-else
                                    class="ms-2"
                                    icon
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="import_enterprises_dialog = true"
                                >
                                    <v-icon size="18" class="font-weight-bold">mdi-import</v-icon>
                                </v-btn>
                                </div>
                            </v-card-title>

                            <div class="export-search-wrapper">
                                <ExportSearchWrapper>
                                    <div class="d-flex flex-wrap gap-2">
                                        <ExportButton
                                            :text="'Export to Excel'"
                                            icon="mdi-file-excel"
                                            @click="export_excel_report"
                                        />
                                        <ExportButton
                                            :text="'Print to PDF'"
                                            icon="mdi-printer"
                                            @click="export_pdf_report"
                                        />
                                    </div>
                                    <SearchBar v-model="search" />
                                </ExportSearchWrapper>
                            </div>


                            <div class="filter-sort-wrapper mb-4">
                                <div
                                    v-if="$page.props.auth.user.role != 'User'"
                                    class="mt-4"
                                >
                                    <FilterWrapper>
                                        <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.campus">
                                            <option disabled>
                                                Filter by Campus
                                            </option>
                                            <option selected value="">All Campuses</option>
                                            <option v-for="campus in $page.props.campuses" :value="campus.id" :key="campus.id">{{ campus.campus }}</option>
                                        </SelectInput>
                                        <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.year">
                                            <option disabled>
                                                Filter by Year
                                            </option>
                                            <option value="">All Years</option>
                                            <option v-for="year in $page.props.years" :key="year.id" :value="year.id">
                                                Year {{ year.year }}
                                            </option>
                                        </SelectInput>
                                        <SelectInput v-model="filter.quarter" class="max-w-sm min-w-[200px]">
                                            <option value="">All Quarters</option>
                                            <option value="Q1">Quarter 1 (Jan–Mar)</option>
                                            <option value="Q2">Quarter 2 (Apr–Jun)</option>
                                            <option value="Q3">Quarter 3 (Jul–Sep)</option>
                                            <option value="Q4">Quarter 4 (Oct–Dec)</option>
                                        </SelectInput>

                                    </FilterWrapper>
                                </div>
                            </div>

                            <!-- <div class="d-flex mb-4">
                                <form>
                                    <select id="income_year" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
                                        <option value="" disabled>Select Year</option>
                                        <option value="2025" selected>2025</option>
                                    </select>
                                </form>
                                <form class="ms-2">
                                    <select v-model="selectedQuarter" id="income_year" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" @change="updateTableHeaders">
                                        <option value="" disabled>Select Quarter</option>
                                        <option value="All" selected>All Quarters</option>
                                        <option value="Q1" >Quarter 1</option>
                                        <option value="Q2" >Quarter 2</option>
                                        <option value="Q3" >Quarter 3</option>
                                        <option value="Q4" >Quarter 4</option>
                                    </select>
                                </form>
                            </div> -->

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search" :headers="tableHeaders"
                                :items="filteredList" hover :loading="loading"
                            >
                                <!-- <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template> -->

                                <template v-slot:item.enterprise="{item}">
                                    <div class="w-[200px]">{{ item.enterprise }}</div>
                                </template>

                                <template v-slot:item.continuing="{item}">
                                    <div class="border-[1px] w-[150px] bg-amber-50 !border-amber-500 rounded pa-4">₱{{ formatCurrency(item.continuing) }}</div>
                                </template>

                                <template v-slot:item.january="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.january) }}</div>
                                </template>

                                <template v-slot:item.february="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.february) }}</div>
                                </template>

                                <template v-slot:item.march="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.march) }}</div>
                                </template>

                                <template v-slot:item.april="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.april) }}</div>
                                </template>

                                <template v-slot:item.may="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.may) }}</div>
                                </template>

                                <template v-slot:item.june="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.june) }}</div>
                                </template>

                                <template v-slot:item.july="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.july) }}</div>
                                </template>

                                <template v-slot:item.august="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.august) }}</div>
                                </template>

                                <template v-slot:item.september="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.september) }}</div>
                                </template>

                                <template v-slot:item.october="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.october) }}</div>
                                </template>

                                <template v-slot:item.november="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.november) }}</div>
                                </template>

                                <template v-slot:item.december="{item}">
                                    <div class="w-[100px]">₱{{ formatCurrency(item.december) }}</div>
                                </template>

                                <template v-slot:item.current="{item}">
                                    <div :class="['border-[1px] w-[150px] rounded p-4 transition-all duration-300', quarterFilter === 'Q1' ? 'border-teal-500 bg-teal-50' : 'border-amber-500 bg-amber-50']">
                                        ₱{{ formatCurrency(item.current) }}
                                    </div>

                                </template>

                                <!-- <template v-slot:item.enterprise="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.enterprise }}
                                    </td>
                                </template> -->

                                <template v-slot:item.last_modified="{ item }">
                                    <div class="text-start py-4 w-max inline-block">
                                        <p class="text-xs font-bold uppercase text-gray-500">
                                            Last Modified By
                                        </p>
                                        <p class="my-1">
                                            {{ item.date }}
                                        </p>
                                        <p class="border-l-4 ps-1 border-emerald-600 text-xs font-bold uppercase text-emerald-600">
                                            {{ item.updated_by }}
                                        </p>
                                    </div>
                                </template>


                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end d-flex justify-end align-center gap-1">
                                        <ActionButton @click="handle_edit_income(item.id)" :variant="'flat'" :color="'warning'" :text="'Edit'" prepend-icon="mdi-pencil" />
                                        <ActionButton @click="handle_delete_income(item.id)" :variant="'flat'" :color="'error'" :text="'Delete'" prepend-icon="mdi-delete" />
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                </div>
                
            </div>

            <!-- modals  -->
             <div>
                <!-- add income  -->
                <v-dialog v-model="import_enterprises_dialog" persistent max-width="600">
                    <v-card class="pa-8">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="handle_import_enterprises">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-gray-600">Import existing enterprises?</p>
                                        <p class="text-sm my-2">To add and update each enterprise's monthly income, import existing business enterprises or create new.</p>
                                    </div>

                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="campus_id" value="Select campus" required="true"/>
                                            <SelectInput id="campus_id" v-model="import_enterprise_form.campus_id">
                                                <option disabled>Select campus</option>
                                                <option v-for="campus in $page.props.campuses" :value="campus.id" :key="campus.id">{{ campus.campus }}</option>
                                            </SelectInput>
                                            <InputError class="mt-2" :message="import_enterprise_form.errors.campus_id" />
                                        </div>
                                    </div>

                                    <div>
                                        <div class="text-center mt-6">
                                            <ActionButton @click="handle_redirect" class="me-2" variant="outlined" text="Add New" prepend-icon="mdi-plus" color="teal-darken-3" :disabled="import_enterprise_form.processing"/>
                                            <ActionButton :text="import_enterprise_form.processing ? 'Importing...' : 'Import IGEs'" prepend-icon="mdi-import" color="teal-darken-3" type="submit" :loading="import_enterprise_form.processing"/>
                                        </div>
                                    </div>

                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="import_enterprises_dialog = false"
                                        ></v-btn>

                                        <!-- <v-btn
                                            color="primary"
                                            text="Save Changes"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': add_income_form.processing }"
                                            :loading="add_income_form.processing"
                                        ></v-btn> -->
                                    </div>
                                </form>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-dialog>

                <!-- add income  -->
                <v-dialog v-model="add_income_dialog" persistent max-width="600">
                    <v-card prepend-icon="mdi-cash-multiple" title="Add Academic Year" class="pa-2">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="submit">
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="year" value="Year" required="true"/>
                                            <TextInput
                                                id="year"
                                                type="number"
                                                class="mt-1 block w-full"
                                                v-model="add_income_form.year"
                                                autocomplete="year"
                                                disabled
                                            />
                                            <InputError class="mt-2" :message="add_income_form.errors.continuing" />
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="Enterprise" value="Enterprise" required="true"/>
                                            <SelectInput v-model="add_income_form.enterprise">
                                                <option disabled>Import existing enterprise or add new</option>
                                                <option v-for="enterprise in $page.props.enterprises" :key="enterprise.id" :value="enterprise.id">{{ enterprise.enterprise }}</option>
                                                <option :value="0">Others/Add new</option>
                                            </SelectInput>
                                            <InputError class="mt-2" :message="add_income_form.errors.continuing" />
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="january" value="January" required="true"/>
                                            <TextInput
                                                id="january"
                                                type="number"
                                                class="mt-1 block w-full"
                                                v-model="add_income_form.continuing"
                                                autocomplete="year"
                                                placeholder="Enter income for the month of January."
                                            />
                                            <InputError class="mt-2" :message="add_income_form.errors.continuing" />
                                        </div>
                                    </div>
                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="add_income_dialog = false"
                                        ></v-btn>

                                        <v-btn
                                            color="primary"
                                            text="Save Changes"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': add_income_form.processing }"
                                            :loading="add_income_form.processing"
                                        ></v-btn>
                                    </div>
                                </form>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-dialog>

                <!-- edit income  -->
                <v-dialog v-model="edit_income_dialog" persistent max-width="600">
                    <v-card prepend-icon="mdi-cash-multiple" title="Enter Income" class="pa-2">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="update_income">
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="enterprise" value="Enterprise" required="true"/>
                                            <TextInput
                                                id="enterprise"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="edit_income_form.enterprise"
                                                autocomplete="enterprise"
                                                placeholder="Enter enterprise."
                                                disabled
                                            />
                                            <!-- <InputError class="mt-2" :message="edit_income_form.errors.enterprise" /> -->
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="continuing" :value="(filter.year)-1 + ' Continuing'" required="true"/>
                                            <TextInput
                                                id="continuing"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="formattedFields['continuing']"
                                                placeholder="Enter continuing."
                                                @input="onInput($event, 'continuing')"
                                            />
                                            <InputError class="mt-2" :message="edit_income_form.errors.continuing" />
                                        </div>
                                    </div>
                                    <div class="mb-4" v-for="(month, index) in monthly_text_fields" :key="month.value">
                                        <div>
                                            <InputLabel :for="month.value" :value="month.text" required="true"/>
                                            <TextInput
                                                :id="month.value"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="formattedFields[month.value]"
                                                :placeholder="'Enter ' + month.text + ' income.'"
                                                :disabled="index > currentMonthIndex"
                                                @input="onInput($event, month.value)"
                                            />
                                            <InputError class="mt-2" :message="edit_income_form.errors[month.value]" />
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="current" :value="filter.year + ' Current'" required="true"/>
                                            <TextInput
                                                id="current"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="formattedFields.current"
                                                placeholder="Enter current income."
                                                disabled
                                            />

                                            <!-- <InputError class="mt-2" :message="edit_income_form.errors.enterprise" /> -->
                                        </div>
                                    </div>
                                    
                                    
                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="edit_income_dialog = false"
                                        ></v-btn>

                                        <v-btn
                                            color="primary"
                                            text="Save Changes"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': edit_income_form.processing }"
                                            :loading="edit_income_form.processing"
                                        ></v-btn>
                                    </div>
                                </form>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-dialog>
             </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import Swal from 'sweetalert2';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import SearchBar from '@/Components/SearchBar.vue';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import SelectInput from '@/Components/SelectInput.vue';
import { ref } from 'vue';
import ExportButton from '@/Components/ExportButton.vue';
import ActionButton from '@/Components/ActionButton.vue';
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import useListFilter from '@/Utils/useListFilter';
import { generatePDF } from '@/Utils/PDFGenerator';
import { exportExcel } from '@/Utils/ExcelGenerator';

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
        dialog: false,
        previewUrl: null,
        previewImageDialog: false,
        selectedQuarter: 'All',
        headers: [
            { title: '#', key: 'number' },
            { title: 'Enterprise', key: 'enterprise' },
            { title: `2024 Continuing`, key: 'continuing' },
            { title: 'January', key: 'jan' },
            { title: 'February', key: 'feb' },
            { title: 'March', key: 'mar' },
            { title: 'April', key: 'apr' },
            { title: 'May', key: 'may' },
            { title: 'June', key: 'jun' },
            { title: 'July', key: 'jul' },
            { title: 'August', key: 'aug' },
            { title: 'September', key: 'sep' },
            { title: 'October', key: 'oct' },
            { title: 'November', key: 'nov' },
            { title: 'December', key: 'dec' },
            { title: `${new Date().getFullYear()} Current`, key: 'current' },
            {
                title: 'Actions',
                align: 'end',
                key: 'actions',
                sortable: false,
            },
        ],
        allData: [
            { number: 1, enterprise: 'ABC Corp', continuing: 5000, jan: 1500, feb: 2000, mar: 1500, apr: 0, may: 0, jun: 0, jul: 0, aug: 0, sep: 0, oct: 0, nov: 0, dec: 0, current: 0 },
            { number: 2, enterprise: 'XYZ Ltd', continuing: 7000, jan: 2000, feb: 2500, mar: 2500, apr: 0, may: 0, jun: 0, jul: 0, aug: 0, sep: 0, oct: 0, nov: 0, dec: 0, current: 0 },
        ],
        header: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'Campus',
                align: 'start',
                key: 'campus',
                sortable: true,
            },
            {
                title: 'Enterprise',
                align: 'start',
                key: 'enterprise',
                sortable: true,
            },
            {
                title: new Date().getFullYear()-1 + ' Continuing',
                align: 'center',
                key: 'continuing',
                sortable: true,
            },
            {
                title: 'January',
                align: 'center',
                key: 'january',
                sortable: true,
            },
            {
                title: 'February',
                align: 'center',
                key: 'february',
                sortable: true,
            },
            {
                title: 'March',
                align: 'center',
                key: 'march',
                sortable: true,
            },
            {
                title: 'April',
                align: 'center',
                key: 'april',
                sortable: true,
            },
            {
                title: 'May',
                align: 'center',
                key: 'may',
                sortable: true,
            },
            {
                title: 'June',
                align: 'center',
                key: 'june',
                sortable: true,
            },
            {
                title: 'July',
                align: 'center',
                key: 'july',
                sortable: true,
            },
            {
                title: 'August',
                align: 'center',
                key: 'august',
                sortable: true,
            },
            {
                title: 'September',
                align: 'center',
                key: 'september',
                sortable: true,
            },
            {
                title: 'October',
                align: 'center',
                key: 'october',
                sortable: true,
            },
            {
                title: 'November',
                align: 'center',
                key: 'november',
                sortable: true,
            },
            {
                title: 'December',
                align: 'center',
                key: 'december',
                sortable: true,
            },
            {
                title: new Date().getFullYear() + ' Current',
                align: 'center',
                key: 'current',
                sortable: true,
            },
            {
                title: 'Last Modified',
                align: 'center',
                key: 'last_modified',
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
            enterprise: 'Scheme Rental (Rice)',
            continuing: '23,000',
            current: '0.00',
            jan: '0.00',
            feb: '0.00',
            mar: '0.00',
            apr: '0.00',
            may: '0.00',
            jun: '0.00',
            jul: '0.00',
            aug: '0.00',
            sep: '0.00',
            oct: '0.00',
            nov: '0.00',
            dec: '0.00',
            overall_total: '0.00',
          },
          {
            number: 2,
            id: 2,
            enterprise: 'Rice Project',
            continuing: '53,000',
            current: '0.00',
            jan: '0.00',
            feb: '0.00',
            mar: '0.00',
            apr: '0.00',
            may: '0.00',
            jun: '0.00',
            jul: '0.00',
            aug: '0.00',
            sep: '0.00',
            oct: '0.00',
            nov: '0.00',
            dec: '0.00',
            overall_total: '0.00',
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Transaction',
                active: false
            },
            {
                title: 'Expenses',
                active: true
            },
        ]
      }
    },
    computed: {
        filteredData() {
        // You can also slice/filter by months if needed here
            return this.allData;
        }
    },
    methods: {
        updateTableHeaders() {
            switch (this.selectedQuarter) {
                case 'Q1':
                    this.headers = [
                        { title: '#', key: 'number' },
                        { title: 'Enterprise', key: 'enterprise' },
                        { title: `${new Date().getFullYear()} Current`, key: 'current' },
                        { title: 'January', key: 'jan' },
                        { title: 'February', key: 'feb' },
                        { title: 'March', key: 'mar' },
                        {
                            title: 'Actions',
                            align: 'end',
                            key: 'actions',
                            sortable: false,
                        },
                    ];
                    break;
                case 'Q2':
                    this.headers = [
                        { title: '#', key: 'number' },
                        { title: 'Enterprise', key: 'enterprise' },
                        { title: `${new Date().getFullYear()} Current`, key: 'current' },
                        { title: 'April', key: 'apr' },
                        { title: 'May', key: 'may' },
                        { title: 'June', key: 'jun' },
                        {
                            title: 'Actions',
                            align: 'end',
                            key: 'actions',
                            sortable: false,
                        },
                    ];
                    break;
                case 'Q3':
                    this.headers = [
                        { title: '#', key: 'number' },
                        { title: 'Enterprise', key: 'enterprise' },
                        { title: `${new Date().getFullYear()} Current`, key: 'current' },
                        { title: 'July', key: 'jul' },
                        { title: 'August', key: 'aug' },
                        { title: 'September', key: 'sep' },
                        {
                            title: 'Actions',
                            align: 'end',
                            key: 'actions',
                            sortable: false,
                        },
                    ];
                    break;
                case 'Q4':
                    this.headers = [
                        { title: '#', key: 'number' },
                        { title: 'Enterprise', key: 'enterprise' },
                        { title: `${new Date().getFullYear()} Current`, key: 'current' },
                        { title: 'October', key: 'oct' },
                        { title: 'November', key: 'nov' },
                        { title: 'December', key: 'dec' },
                        {
                            title: 'Actions',
                            align: 'end',
                            key: 'actions',
                            sortable: false,
                        },
                    ];
                    break;
                case 'All':
                    this.headers = [
                        { title: '#', key: 'number' },
                        { title: 'Enterprise', key: 'enterprise' },
                        { title: `${new Date().getFullYear()} Current`, key: 'current' },
                        { title: 'January', key: 'jan' },
                        { title: 'February', key: 'feb' },
                        { title: 'March', key: 'mar' },
                        { title: 'April', key: 'apr' },
                        { title: 'May', key: 'may' },
                        { title: 'June', key: 'jun' },
                        { title: 'July', key: 'jul' },
                        { title: 'August', key: 'aug' },
                        { title: 'September', key: 'sep' },
                        { title: 'October', key: 'oct' },
                        { title: 'November', key: 'nov' },
                        { title: 'December', key: 'dec' },
                        {
                            title: 'Actions',
                            align: 'end',
                            key: 'actions',
                            sortable: false,
                        },
                    ];
                    break;
            }
        },
    }
  }
</script>

<style scoped>
:deep(.v-field input:focus) {
  outline: none !important;
  box-shadow: none !important;
}
</style>