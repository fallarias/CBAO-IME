<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, router, useForm, usePage } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { ref } from 'vue';

const page = usePage();


// import existing iges
const import_enterprises_dialog = ref(false);
const is_importing = ref(false);
const import_progress = ref(0);

const import_enterprise_form = useForm({
    campus_id: page.props.auth.user.campus.id
})

const handle_import_enterprises = () => {

    // Trigger backend route (Laravel: route('income.import'))
    import_enterprise_form.post(route("expenses.import"), {
        onSuccess: () => {
            import_enterprises_dialog.value = false;
        },
    });
};

const handle_redirect = () => {
    router.get(route('enterprises.display'));
};
// end import existing iges

// edit expense
const edit_expense_dialog = ref(false);

const edit_expense_form = useForm({
    expense_id: '',
    budgeted_amount: 0.00,
    particulars: [
        {
            particular: '',
            amount: 0.00,
        }
    ],
})

const handle_edit_expense = (id) => {
    edit_expense_form.expense_id = id;
    edit_expense_dialog.value = true;
}

const add_particular = () => {
    edit_expense_form.particulars.push({
        particular: '',
        amount: 0.00,
    });
}

const remove_particular = (index) => {
    if (edit_expense_form.particulars.length === 1) {
        // Close the expense dialog first
        edit_expense_dialog.value = false;

        // Show alert
        Swal.fire({
            icon: "error",
            title: "Cannot Remove Item",
            text: "At least one particular must remain. You cannot remove the last item.",
            confirmButtonText: "OK, got it",
            confirmButtonColor: "#d33",
            allowOutsideClick: false,
            allowEscapeKey: false,
            allowEnterKey: true,
            didOpen: () => {
                const confirmBtn = Swal.getConfirmButton();
                if (confirmBtn) confirmBtn.style.color = "white";
            },
        }).then(() => {
            // Reopen the dialog after confirmation
            edit_expense_dialog.value = true;
        });

        return;
    }

    // 🧾 Proceed to remove the selected item
    edit_expense_form.particulars.splice(index, 1);
}

const update = () => {
    // console.log(edit_expense_form)
    edit_expense_form.put(route('expenses.update', edit_expense_form.expense_id), {
        onSuccess: () => {
            edit_expense_form.reset();
            edit_expense_dialog.value = false;
        },
    })
}

// delete expense
const handle_delete_expense = (id) => {
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
        didOpen: () => {
            const confirmBtn = Swal.getConfirmButton();
            if (confirmBtn) confirmBtn.style.color = "white";

            const cancelBtn = Swal.getCancelButton();
            if (cancelBtn) cancelBtn.style.color = "white";
        },
    }).then((result) => {
        if (result.isConfirmed) {
            // Trigger backend route (Laravel: route('expenses.delete', id))
            router.delete(route('expenses.delete', id), {
                onSuccess: () => {
                    Swal.fire(
                        'Deleted!',
                        'The record has been deleted from the list.',
                        'success'
                    )
                },
                onError: () => {
                    Swal.fire(
                        'Error!',
                        'There was an error deleting the record.',
                        'error'
                    )
                }
            });
        }
    })
};

// filtering
const expenses_list = ref(page.props.expenses)

const { list, filter, filteredList } = useListFilter(expenses_list.value, {
  campus: "",
  year: new Date().getFullYear(),
})


const form = useForm({
    product_name: '',
    product_name: '',
    product_quantity: 0,
    product_price: 0.00,
    product_category: '',
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};

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
const pdf_headers = ['#', 'Campus', 'Enterprise', 'Budgeted Amount', 'Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.', 'Total MOOE', 'Total CO', 'Overall Total']

// const column_styles = Object.fromEntries(
//   pdf_headers.map((_, i) => [i, { cellWidth: 270 / pdf_headers.length }])
// );

const column_styles = {
  0: { cellWidth: 8, halign: "center" },   // #
  1: { cellWidth: 20 },                    // Campus
  2: { cellWidth: 35 },                    // Enterprise
  3: { cellWidth: 16.5, halign: "right" },   // Continuing
  4: { cellWidth: 16.5, halign: "right" },   // January
  5: { cellWidth: 16.5, halign: "right" },   // February
  6: { cellWidth: 16.5, halign: "right" },   // March
  7: { cellWidth: 16.5, halign: "right" },   // April
  8: { cellWidth: 16.5, halign: "right" },   // May
  9: { cellWidth: 16.5, halign: "right" },   // June
  10: { cellWidth: 16.5, halign: "right" },  // July
  11: { cellWidth: 16.5, halign: "right" },  // August
  12: { cellWidth: 16.5, halign: "right" },  // September
  13: { cellWidth: 16.5, halign: "right" },  // October
  14: { cellWidth: 16.5, halign: "right" },  // November
  15: { cellWidth: 16.5, halign: "right" },  // December
  16: { cellWidth: 16.5, halign: "right" },  // Total MOOE
  17: { cellWidth: 16.5, halign: "right" },  // Total CO
  18: { cellWidth: 16.5, halign: "right" },  // Overall Total
};

const export_pdf_report = () => {
  generatePDF({
    reportTitle: "Report of Monthly Expenses Per Enterprise",
    isExporting,
    currentUser: current_user,
    headers: pdf_headers,
    orientation: 'l',
    tableOptions: { columnStyles: column_styles },
    pageSize: 'legal',
    rows: filteredList.value.map((item, index) => [
      index + 1,
      item.campus_name,
      item.enterprise_name,
      formatCurrency(item.budgeted_amount),
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
      formatCurrency(item.total_mooe),
      formatCurrency(item.total_co),
      formatCurrency(item.overall_total),
    ]),
  });
};
// end of pdf section

// excel section
// Excel headers
const excel_headers = ['#', 'Campus', 'Enterprise', 'Budgeted Amount', 'Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sep.', 'Oct.', 'Nov.', 'Dec.', 'Total MOOE', 'Total CO', 'Overall Total'];

// Export handler
const export_excel_report = () => {
  // Use .value because it's a computed ref
  const excelData = filteredList.value.map((item, index) => ({
    '#': index + 1,
    'Campus': item.campus_name || '-',
    'Enterprise': item.enterprise_name || '-',
    'Budgeted Amount': formatCurrency(item.budgeted_amount),
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
    'Total MOOE': formatCurrency(item.total_mooe),
    'Total CO': formatCurrency(item.total_co),
    'Overall Total': formatCurrency(item.overall_total),
  }));

  exportExcel(excelData, excel_headers, "Monthly_Expenses_Report");
};
// end of excel section

useFlashWatcher("expenses.display")
</script>

<template>
    <Head title="Expenses" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Expenses</h2>
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
                                        Import Enterprises
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
                                        <!-- <SelectInput v-model="filter.quarter" class="max-w-sm min-w-[200px]">
                                            <option value="">All Quarters</option>
                                            <option value="Q1">Quarter 1 (Jan–Mar)</option>
                                            <option value="Q2">Quarter 2 (Apr–Jun)</option>
                                            <option value="Q3">Quarter 3 (Jul–Sep)</option>
                                            <option value="Q4">Quarter 4 (Oct–Dec)</option>
                                        </SelectInput> -->

                                    </FilterWrapper>
                                </div>
                            </div>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="filteredList" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item, index}">
                                    <div class="text-start">{{ index + 1 }}</div>
                                </template>

                                <template v-slot:item.enterprise_name="{item}">
                                    <div class="w-[200px]">{{ item.enterprise_name }}</div>
                                </template>

                                <template v-slot:item.budgeted_amount="{ item }">
                                    <div class="relative group w-[150px] my-2">
                                        <!-- Budget Amount Box -->
                                        <div
                                            class="border border-amber-500 bg-amber-50 rounded py-2 px-4 text-start cursor-pointer transition-all duration-200 group-hover:bg-amber-100"
                                        >
                                            ₱{{ formatCurrency(item.budgeted_amount) }}
                                        </div>

                                        <!-- Hover Card -->
                                        <div
                                            v-if="item.budget_particulars && item.budget_particulars.length"
                                            class="absolute left-1/2 z-10 hidden w-[250px] -translate-x-1/2 rounded-lg border border-gray-200 bg-white p-3 text-sm shadow-lg group-hover:block"
                                        >
                                            <div class="font-semibold text-gray-700 mb-2 border-b pb-1">
                                                Budget Particulars
                                            </div>
                                            <ul class="space-y-1 max-h-[200px] overflow-y-auto">
                                                <li
                                                    v-for="(particular, index) in item.budget_particulars"
                                                    :key="index"
                                                    class="flex justify-between text-gray-600"
                                                >
                                                    <span class="truncate w-[60%]">{{ particular.particular_name }}</span>
                                                    <span class="font-medium text-gray-800">
                                                        ₱{{ formatCurrency(particular.amount) }}
                                                    </span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
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

                                <template v-slot:item.total_mooe="{item}">
                                    <div class="border-[1px] w-[150px] bg-amber-50 !border-amber-500 rounded py-2 px-4">
                                        ₱{{ formatCurrency(item.total_mooe) }}
                                    </div>
                                </template>

                                <template v-slot:item.total_co="{item}">
                                    <div class="border-[1px] w-[150px] bg-cyan-50 !border-cyan-500 rounded py-2 px-4">
                                        ₱{{ formatCurrency(item.total_co) }}
                                    </div>
                                </template>

                                <template v-slot:item.overall_total="{item}">
                                    <div class="border-[1px] w-[150px] bg-teal-50 !border-teal-500 rounded py-2 px-4">
                                        ₱{{ formatCurrency(item.overall_total) }}
                                    </div>
                                </template>

                                <!-- <template v-slot:item.budget="{item}">
                                    <div v-if="item.budget == ''">
                                        <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-exclamation-thick" @click="set_budget_dialog = true">Set Budget</v-btn>
                                    </div>
                                    <div v-else>
                                        {{ item.budget }}
                                    </div>
                                </template> -->

                                <template v-slot:item.creditors="{item}">
                                    <div>
                                        <Link :href="route('creditors.display', item.id)" class="text-blue-darken-3 hover:font-bold hover:underline">View List</Link>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end d-flex justify-end align-center">
                                        <ActionButton :disabled="item.budgeted_amount != 0.00" @click="handle_edit_expense(item.id)" class="me-2" variant="flat" text="Set Budget" prepend-icon="mdi-pencil" color="warning" />
                                        <ActionButton @click="handle_delete_expense(item.id)" class="me-2" variant="flat" text="Delete" prepend-icon="mdi-delete" color="error" />
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                    <div>
                        <!-- add new expense  -->
                        <v-dialog v-model="dialog" persistent max-width="800">
                            <v-card prepend-icon="mdi-package" title="Add Product" class="pa-2">
                                <v-card-text>
                                    
                                    
                                    <div>
                                        <form>
                                            <!-- 1. Product image  -->
                                            <div class="mb-6">
                                                <label for="default-input" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Product image <span>(optional)</span></label>
                                                <div class="flex items-center justify-center w-full">
                                                    <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-gray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600">
                                                        <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                                            <svg class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
                                                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
                                                            </svg>
                                                            <p v-if="previewUrl" class="mb-2 text-sm text-gray-500 dark:text-gray-400 font-semibold">Change uploaded image</p>
                                                            <p v-else class="mb-2 text-sm text-gray-500 dark:text-gray-400"><span class="font-semibold">Click to upload</span> or drag and drop</p>
                                                            <p class="text-xs text-gray-500 dark:text-gray-400">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
                                                        </div>
                                                        <input id="dropzone-file" type="file" class="hidden" @change="handleFileChange" accept="image/*"/>
                                                    </label>
                                                </div>
                                                <div v-if="previewUrl" class="d-flex">
                                                    <div @click="previewImageDialog = true" class="hover:cursor-pointer text-blue-500 italic mt-2 text-sm">View image preview</div>
                                                    <div @click="previewUrl = null" class="hover:cursor-pointer text-red-500 italic mt-2 text-sm ms-4">Remove image</div>
                                                </div>
                                                
                                                <v-dialog v-model="previewImageDialog" max-width="400">
                                                    <v-card>
                                                        <!-- Image preview -->
                                                        <div v-if="previewUrl" height="400">
                                                            <v-img :src="previewUrl" alt="Preview" cover></v-img>
                                                        </div>
                                                        <div v-else class="text-center">
                                                            <v-empty-state
                                                                action-text="Okay, thanks"
                                                                image="/storage/default/no_data.svg"
                                                                text="The system failed to preview your image. Have you uploaded it yet?"
                                                                title="No image found"
                                                                @click:action="previewImageDialog = false"
                                                            ></v-empty-state>
                                                        </div>
                                                    </v-card>
                                                </v-dialog> 
                                            </div>

                                            <div class="mb-2">
                                                <v-select
                                                    clearable
                                                    label="Product category"
                                                    :items="['California', 'Colorado', 'Florida', 'Georgia', 'Texas', 'Wyoming']"
                                                    multiple
                                                    variant="outlined"
                                                ></v-select>

                                            </div>

                                            <div class="mb-2">
                                                <v-text-field clearable label="Product name" variant="outlined" class="focus:outline-none focus:ring-0"></v-text-field>
                                            </div>

                                            <div class="mb-2">
                                                <v-row>
                                                    <v-col>
                                                        <v-number-input
                                                            :reverse="false"
                                                            controlVariant="default"
                                                            label="Product quantity"
                                                            :hideInput="false"
                                                            :inset="false"
                                                            variant="outlined"
                                                        ></v-number-input>
                                                    </v-col>
                                                    <v-col>
                                                        <v-number-input
                                                            :reverse="false"
                                                            controlVariant="default"
                                                            label="Product price"
                                                            :hideInput="false"
                                                            :inset="false"
                                                            variant="outlined"
                                                            precision="2"
                                                        ></v-number-input>
                                                    </v-col>
                                                </v-row>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                                <v-divider></v-divider>
                                <v-card-actions>
                                    <v-spacer></v-spacer>
                                    <v-btn
                                        text="Close"
                                        variant="plain"
                                        @click="dialog = false"
                                    ></v-btn>

                                    <v-btn
                                        color="primary"
                                        text="Save"
                                        variant="tonal"
                                        @click="addProduct"
                                    ></v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-dialog>

                        <!-- edit expense dialog  -->
                        <v-dialog v-model="edit_expense_dialog" persistent max-width="600">
                            <v-card prepend-icon="mdi-cash-multiple" title="Set Budget" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="update">
                                            <div class="mb-4">
                                                <div>
                                                    <InputLabel for="budgeted_amount" value="Budgeted Amount" required="true"/>
                                                    <TextInput
                                                        id="budgeted_amount"
                                                        type="number"
                                                        class="mt-1 block w-full"
                                                        v-model="edit_expense_form.budgeted_amount"
                                                        autocomplete="budgeted_amount"
                                                        placeholder="Enter budgeted amount."
                                                    />
                                                    <InputError class="mt-2" :message="edit_expense_form.errors.budgeted_amount" />
                                                </div>
                                            </div>
                                            <div class="mb-4">
                                                <div>
                                                    <InputLabel for="particulars" value="Particulars" required="true"/>

                                                    <div class="grid grid-cols-3 gap-4 mt-2 mb-3" v-for="(req, index) in edit_expense_form.particulars" :key="index">
                                                        <TextInput type="text" placeholder="Particular" v-model="req.particular"/>
                                                        <TextInput type="number" placeholder="Amount" v-model="req.amount"/>
                                                        <div class="border-2 text-red-500 border-red-500 flex text-center justify-center align-center rounded hover:cursor-pointer hover:bg-red-50 hover:font-bold" @click="remove_particular(index)">Remove</div>
                                                    </div>
                                                    <div class="border-2 border-teal-500 text-teal-500 text-center rounded pa-4 hover:cursor-pointer hover:bg-teal-50 hover:font-bold" @click="add_particular">Add Particular</div>
                                                </div>
                                            </div>
                                            <v-divider class="my-4"></v-divider>
                                            <div class="text-end">
                                                <v-btn
                                                    text="Close"
                                                    variant="plain"
                                                    @click="edit_expense_dialog = false"
                                                ></v-btn>

                                                <v-btn
                                                    color="primary"
                                                    text="Save Changes"
                                                    variant="tonal"
                                                    type="submit"
                                                    :class="{ 'opacity-25': edit_expense_form.processing }"
                                                    :loading="edit_expense_form.processing"
                                                ></v-btn>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>

                        <!-- set budget  -->
                         <v-dialog v-model="set_budget_dialog" persistent max-width="600">
                            <v-card prepend-icon="mdi-cash" title="Set Budget" class="pa-2">
                                <v-card-text>
                                    <v-row>
                                        <v-col>
                                            <div>Set Budget for <span class="text-green-500 font-bold">2025 Scheme Rental (Rice)</span></div>
                                        </v-col>
                                    </v-row>
                                    <v-row>
                                        <v-col>
                                            <v-number-input
                                                :reverse="false"
                                                controlVariant="default"
                                                label="Budget"
                                                :hideInput="false"
                                                :inset="false" 
                                                variant="outlined"
                                                precision="2"
                                            ></v-number-input>
                                        </v-col>
                                    </v-row>
                                </v-card-text>
                                <v-divider></v-divider>
                                <v-card-actions>
                                    <v-spacer></v-spacer>
                                    <v-btn
                                        text="Close"
                                        variant="plain"
                                        @click="set_budget_dialog = false"
                                    ></v-btn>

                                    <v-btn
                                        color="primary"
                                        text="Save"
                                        variant="tonal"
                                        @click="addProduct"
                                    ></v-btn>
                                </v-card-actions>
                            </v-card>
                         </v-dialog>
                    </div>
                </div>
                
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
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import Swal from 'sweetalert2';
import { ref } from 'vue';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import ExportButton from '@/Components/ExportButton.vue';
import SearchBar from '@/Components/SearchBar.vue';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import SelectInput from '@/Components/SelectInput.vue';
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import useListFilter from '@/Utils/useListFilter';
import ActionButton from '@/Components/ActionButton.vue';
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
        set_budget_dialog: false,
        previewUrl: null,
        previewImageDialog: false,
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
                key: 'campus_name',
                sortable: true,
            },
            {
                title: 'Enterprise',
                align: 'start',
                key: 'enterprise_name',
                sortable: true,
            },
            {
                title: 'Budgeted Amount',
                align: 'center',
                key: 'budgeted_amount',
                sortable: true,
            },
            {
                title: 'January',
                align: 'start',
                key: 'january',
                sortable: true,
            },
            {
                title: 'February',
                align: 'start',
                key: 'february',
                sortable: true,
            },
            {
                title: 'March',
                align: 'start',
                key: 'march',
                sortable: true,
            },
            {
                title: 'April',
                align: 'start',
                key: 'april',
                sortable: true,
            },
            {
                title: 'May',
                align: 'start',
                key: 'may',
                sortable: true,
            },
            {
                title: 'June',
                align: 'start',
                key: 'june',
                sortable: true,
            },
            {
                title: 'July',
                align: 'start',
                key: 'july',
                sortable: true,
            },
            {
                title: 'August',
                align: 'start',
                key: 'august',
                sortable: true,
            },
            {
                title: 'September',
                align: 'start',
                key: 'september',
                sortable: true,
            },
            {
                title: 'October',
                align: 'start',
                key: 'october',
                sortable: true,
            },
            {
                title: 'November',
                align: 'start',
                key: 'november',
                sortable: true,
            },
            {
                title: 'December',
                align: 'start',
                key: 'december',
                sortable: true,
            },
            {
                title: 'Total MOOE',
                align: 'start',
                key: 'total_mooe',
                sortable: true,
            },
            {
                title: 'Total CO',
                align: 'start',
                key: 'total_co',
                sortable: true,
            },
            {
                title: 'Overall Total',
                align: 'start',
                key: 'overall_total',
                sortable: true,
            },
            {
                title: 'Creditors',
                align: 'start',
                key: 'creditors',
                sortable: true,
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
            budget: '',
            total_mooe: '0.00',
            total_co: '0.00',
            overall_total: '0.00',
          },
          {
            number: 2,
            id: 2,
            enterprise: 'Rice Project',
            budget: '1,913,672.16',
            total_mooe: '370,395.59',
            total_co: '0.00',
            overall_total: '370,395.59',
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
    methods: {
        handleFileChange(event) {
            const file = event.target.files[0]
            if (file && file.type.startsWith('image/')) {
                const reader = new FileReader()
                reader.onload = (e) => {
                this.previewUrl = e.target.result
                }
                reader.readAsDataURL(file)
            } else {
                this.previewUrl = null
            }
        },
        addProduct(){
            // add ajax processing here
            this.dialog = false;
            Swal.fire({
                title: "Good job!",
                text: "You clicked the button!",
                icon: "success"
            });
        },
        deleteProduct(){
            Swal.fire({
                title: "Are you sure?",
                text: "You won't be able to revert this!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Yes, delete it!",
                didOpen: () => {
                    const confirmBtn = Swal.getConfirmButton();
                    const cancelBtn = Swal.getCancelButton();
                    if (confirmBtn) confirmBtn.style.color = "white";
                    if (cancelBtn) cancelBtn.style.color = "white";
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: "Deleted!",
                        text: "Your file has been deleted.",
                        icon: "success",
                        didOpen: () => {
                            const confirmBtn = Swal.getConfirmButton();
                            const cancelBtn = Swal.getCancelButton();
                            if (confirmBtn) confirmBtn.style.color = "white";
                            if (cancelBtn) cancelBtn.style.color = "white";
                        }
                    });
                }
            });
        }
    }
  }
</script>

<style scoped>
:deep(.v-field input:focus) {
  outline: none !important;
  box-shadow: none !important;
}
</style>