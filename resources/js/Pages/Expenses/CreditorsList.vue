<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { ref } from 'vue';

const page = usePage();

// add record
const add_creditor_dialog = ref(false);

const add_creditor_form = useForm({
    expenses_id: page.props.expense_id,
    creditor_name: '',
    reference_date: '',
    reference_serial_number: '',
    utilization: 0.00,
    disbursements: 0.00,
    uu_due_and_demandable: 0.00,
    uu_not_yet_due_and_demandable: 0.00,
    check_number: '',
    check_date: '',
    particulars: '',
    selected_uacs: [
        {
            uacs_id: '',
            amount: 0.00
        }
    ],
    total_mooe: 0.00,
    total_co: 0.00,
});

const add_selected_uacs = () => {
    add_creditor_form.selected_uacs.push({
        uacs_id: '',
        amount: 0.00,
    });
}

const remove_selected_uacs = (index) => {
    if (add_creditor_form.selected_uacs.length === 1) {
        // Close the expense dialog first
        add_creditor_dialog.value = false;

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
            add_creditor_dialog.value = true;
        });

        return;
    }

    // 🧾 Proceed to remove the selected item
    add_creditor_form.selected_uacs.splice(index, 1);
}

const submit = () => {
    // console.log(add_creditor_form);
    add_creditor_form.post(route('creditors.store', page.props.expense_id), {
        onSuccess: () => {
            add_creditor_dialog.value = false;
            add_creditor_form.reset();
        },
    });
};
// end add record

// format the numbers to be displayed on the table
function formatCurrency(value) {
  if (value === null || value === undefined || value === "") return "";
  return Number(value).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}
// end

useFlashWatcher("creditors.display", page.props.expense_id);
</script>

<template>
    <Head title="Expenses - Creditors" />

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
                            <v-card-title
                                class="d-flex align-center pe-2 justify-space-between"
                            >
                                <!-- Left Section: Icon + Text -->
                                <div class="d-flex align-center pe-2">
                                    <v-icon
                                        :size="
                                            $vuetify.display.smAndDown ? 18 : 24
                                        "
                                        class="me-2 font-weight-bold"
                                    >
                                        mdi-file-document-alert-outline
                                    </v-icon>
                                    <span
                                        :class="
                                            $vuetify.display.smAndDown
                                                ? 'text-lg font-weight-semibold'
                                                : 'text-2xl font-weight-semibold'
                                        "
                                    >
                                        {{ $page.props.enterprise }} - Creditors
                                    </span>
                                </div>

                                <!-- Right Section: Responsive Button -->
                                <div>
                                    <!-- Full button for medium and up -->
                                    <v-btn
                                        v-if="!$vuetify.display.smAndDown"
                                        class="ms-2 text-none tracking-normal"
                                        prepend-icon="mdi-plus"
                                        rounded="l"
                                        text="Add Record"
                                        variant="flat"
                                        color="green-darken-4"
                                        @click="
                                            add_creditor_dialog = true
                                        "
                                    ></v-btn>

                                    <!-- Icon-only button for small devices -->
                                    <v-btn
                                        v-else
                                        class="ms-2"
                                        icon
                                        variant="flat"
                                        color="green-darken-4"
                                        @click="
                                            add_creditor_dialog = true
                                        "
                                    >
                                        <v-icon
                                            size="18"
                                            class="font-weight-bold"
                                            >mdi-plus</v-icon
                                        >
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

                            <!-- <div class="filter-sort-wrapper mb-4">
                                <div
                                    v-if="$page.props.auth.user.role == 'Admin'"
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
                                        <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.status">
                                            <option disabled>
                                                Filter by Status
                                            </option>
                                            <option value="" selected>
                                                All Status
                                            </option>
                                            <option value="Pending">
                                                Pending
                                            </option>
                                            <option value="Approved">
                                                Approved
                                            </option>
                                            <option value="Declined">
                                                Declined
                                            </option>
                                        </SelectInput>
                                    </FilterWrapper>
                                </div>
                            </div> -->

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table class="h-screen"
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="$page.props.creditors" hover :loading="loading" fixed-header
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item, index}">
                                    <div class="text-start">{{ index + 1 }}</div>
                                </template>

                                <template v-slot:item.creditor="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.creditor_name }}
                                    </td>
                                </template>

                                <template v-slot:item.reference_date="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.reference_date }}
                                    </td>
                                </template>

                                <template v-slot:item.serial_number="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.reference_serial_number }}
                                    </td>
                                </template>

                                <!-- <template v-slot:item.uacs="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.uacs }}
                                    </td>
                                </template> -->

                                <template v-slot:item.uacs="{ item }">
  <div class="relative group inline-block w-[180px] !overflow-visible">
    <!-- Trigger Area -->
    <div
      class="border border-sky-500 bg-sky-50 rounded py-2 px-3 text-center cursor-pointer transition-all duration-200 group-hover:bg-sky-100"
    >
      {{ item.uacs_codes?.length ? `${item.uacs_codes.length} UACS Code(s)` : 'No UACS Data' }}
    </div>

    <!-- Hover Card -->
    <div
      v-if="item.uacs_codes && item.uacs_codes.length"
      class="absolute left-1/2 top-full mt-2 z-50 hidden w-[350px] -translate-x-1/2 rounded-lg border border-gray-200 bg-white p-3 text-sm shadow-xl group-hover:block"
    >
      <div class="font-semibold text-gray-700 mb-2 border-b pb-1">
        UACS Codes
      </div>

      <ul class="space-y-2 max-h-[250px] overflow-y-auto">
        <li
          v-for="(uacs, index) in item.uacs_codes"
          :key="index"
          class="border-b last:border-0 pb-1"
        >
          <div class="flex justify-between text-gray-700">
            <span class="font-medium truncate w-[60%]">
              {{ uacs.uacs_code }}
            </span>
            <span class="text-gray-800 font-semibold">
              ₱{{ formatCurrency(uacs.amount) }}
            </span>
          </div>
          <div class="text-xs text-gray-500">
            {{ uacs.uacs_type_name }} • {{ uacs.uacs_group_name }}
          </div>
          <div class="text-xs text-gray-400 italic">
            {{ uacs.object_code }}{{ uacs.sub_object_code ? ' - ' + uacs.sub_object_code : '' }}
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>


                                <template v-slot:item.check_date="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.check_date ?? '--' }}
                                    </td>
                                </template>

                                <template v-slot:item.check_number="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.check_number ?? '--' }}
                                    </td>
                                </template>

                                <template v-slot:item.particulars="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.particulars ?? '--' }}
                                    </td>
                                </template>

                                <template v-slot:item.utilization="{item}">
                                    <div class="border-[1px] w-[150px] border-pink-500 py-2 px-4 rounded my-2 bg-pink-50">
                                        ₱{{ formatCurrency(item.utilization) }}
                                    </div>
                                </template>

                                <template v-slot:item.total_mooe="{item}">
                                    <div class="border-[1px] w-[150px] border-amber-500 py-2 px-4 rounded my-2 bg-amber-50">
                                        ₱{{ formatCurrency(item.total_mooe) }}
                                    </div>
                                </template>

                                <template v-slot:item.total_co="{item}">
                                    <div class="border-[1px] w-[150px] border-cyan-500 py-2 px-4 rounded my-2 bg-cyan-50">
                                        ₱{{ formatCurrency(item.total_co) }}
                                    </div>
                                </template>

                                <template v-slot:item.overall_total="{item}">
                                    <div class="border-[1px] w-[150px] border-cyan-500 py-2 px-4 rounded my-2 bg-cyan-50">
                                        ₱{{ formatCurrency(item.overall_total) }}
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <td style="width: fit-content; white-space: nowrap;" class="text-end">
                                        <!-- <v-btn variant="flat" color="info" class="mr-2 text-none" prepend-icon="mdi-eye">View</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete" @click="deleteProduct">Remove</v-btn> -->
                                        <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                                    </td>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                    <div>
                        <v-dialog
                        v-model="uacs_dialog"
                        width="auto"
                        >
                            <v-card
                                max-width="900"
                                :title="uacs_dialog_data.creditor"
                            >
                                <v-card-text>
                                    <table class="min-w-full bg-white rounded-lg overflow-hidden">
                                        <thead class="bg-emerald-800 text-white text-sm uppercase tracking-wide">
                                            <tr>
                                                <th class="px-6 py-4 text-left">#</th>
                                                <th class="px-6 py-4 text-left">UACS Code</th>
                                                <th class="px-6 py-4 text-left">UACS Description</th>
                                                <th class="px-6 py-4 text-left">Type</th>
                                                <th class="px-6 py-4 text-left">Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody class="text-gray-700 text-sm divide-y divide-gray-200">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4">1</td>
                                                <td class="px-6 py-4">{{uacs_dialog_data.uacs}}</td>
                                                <td class="px-6 py-4">{{ uacs_dialog_data.particulars }}</td>
                                                <td class="px-6 py-4">MOOE</td>
                                                <td class="px-6 py-4">₱{{ uacs_dialog_data.total_mooe }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </v-card-text>
                                <template v-slot:actions>
                                <v-btn
                                    class="ms-auto"
                                    text="Ok"
                                    @click="uacs_dialog = false"
                                ></v-btn>
                                </template>
                            </v-card>
                        </v-dialog>

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
                    </div>
                </div>
                
                <v-dialog v-model="add_creditor_dialog" persistent max-width="600">
                    <v-card prepend-icon="mdi-account-alert-outline" title="Add Creditor" class="pa-2">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="submit">
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="name" value="Name" required="true"/>
                                            <TextInput
                                                id="name"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.creditor_name"
                                                autocomplete="creditor_name"
                                                placeholder="Enter creditor name."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.creditor_name" />
                                        </div>
                                    </div>
                                    <div class="mb-4 grid grid-cols-2 gap-4">
                                        <div>
                                            <InputLabel for="reference_date" value="Reference Date" required="true"/>
                                            <TextInput
                                                id="reference_date"
                                                type="date"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.reference_date"
                                                autocomplete="reference_date"
                                                placeholder="Enter reference date."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.reference_date" />
                                        </div>
                                        <div>
                                            <InputLabel for="reference_serial_number" value="Reference Serial Number" required="true"/>
                                            <TextInput
                                                id="reference_serial_number"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.reference_serial_number"
                                                autocomplete="reference_serial_number"
                                                placeholder="Enter reference serial number."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.reference_serial_number" />
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <InputLabel for="uacs_codes" value="UACS Codes" required="true"/>

                                        <!-- <div>
                                            <SelectInput>
                                                <option disabled value="">Select UACS Type</option>
                                                <option v-for="uacs_type in $page.props.uacs_types" :key="uacs_type.id" :value="uacs_type.id">{{ uacs_type.name }}</option>
                                            </SelectInput>
                                        </div>

                                        <div>
                                            <SelectInput>
                                                <option disabled value="">Select UACS Group</option>
                                                <option v-for="uacs_group in $page.props.uacs_groups" :key="uacs_group.id" :value="uacs_group.id">{{ uacs_group.name }}</option>
                                            </SelectInput>
                                        </div> -->

                                        <div class="mt-1 grid grid-cols-3 gap-4 mb-4" v-for="(uacs, index) in add_creditor_form.selected_uacs" :key="index">
                                            <SelectInput v-model="uacs.uacs_id">
                                                <option disabled value="">Select UACS Code</option>
                                                <option v-for="uacs in $page.props.uacs" :key="uacs.id" :value="uacs.id">[{{ uacs.uacs_type_name }}] {{ uacs.uacs_code }} ({{ uacs.object_code }} - {{ uacs.sub_object_code }})</option>
                                            </SelectInput>
                                            <TextInput
                                                id="uacs_amount"
                                                type="number"
                                                class="mt-1 block w-full"
                                                v-model="uacs.amount"
                                                autocomplete="uacs_amount"
                                                placeholder="Enter amount."
                                            />
                                            <div class="border-2 text-red-500 border-red-500 flex text-center justify-center align-center rounded hover:cursor-pointer hover:bg-red-50 hover:font-bold" @click="remove_selected_uacs(index)">Remove</div>
                                        </div>
                                        <div class="mt-4 border-2 border-teal-500 text-teal-500 text-center rounded pa-4 hover:cursor-pointer hover:bg-teal-50 hover:font-bold" @click="add_selected_uacs">Add UACS</div>
                                    </div>
                                    <div class="mb-4">
                                        <InputLabel for="disbursements" value="Disbursements" />
                                        <TextInput
                                            id="disbursements"
                                            type="text"
                                            class="mt-1 block w-full"
                                            v-model="add_creditor_form.disbursements"
                                            autocomplete="disbursements"
                                            placeholder="Enter disbursements."
                                        />
                                        <InputError class="mt-2" :message="add_creditor_form.errors.disbursements" />
                                    </div>
                                    <div class="mb-4 grid grid-cols-2 gap-4">
                                        <div>
                                            <InputLabel for="uu_due_and_demandable" value="Due and Demandable"/>
                                            <TextInput
                                                id="uu_due_and_demandable"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.uu_due_and_demandable"
                                                autocomplete="uu_due_and_demandable"
                                                placeholder="Enter due and demandable."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.uu_due_and_demandable" />
                                        </div>
                                        <div>
                                            <InputLabel for="uu_not_yet_due_and_demandable" value="Not Yet Due and Demandable"/>
                                            <TextInput
                                                id="uu_not_yet_due_and_demandable"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.uu_not_yet_due_and_demandable"
                                                autocomplete="uu_not_yet_due_and_demandable"
                                                placeholder="Enter not yet due and demandable."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.uu_not_yet_due_and_demandable" />
                                        </div>
                                    </div>
                                    <div class="mb-4 grid grid-cols-2 gap-4">
                                        <div>
                                            <InputLabel for="check_date" value="Check Date"/>
                                            <TextInput
                                                id="check_date"
                                                type="date"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.check_date"
                                                autocomplete="check_date"
                                                placeholder="Enter check date."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.check_date" />
                                        </div>
                                        <div>
                                            <InputLabel for="check_number" value="Check Number"/>
                                            <TextInput
                                                id="check_number"
                                                type="text"
                                                class="mt-1 block w-full"
                                                v-model="add_creditor_form.check_number"
                                                autocomplete="check_number"
                                                placeholder="Enter check number."
                                            />
                                            <InputError class="mt-2" :message="add_creditor_form.errors.check_number" />
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <InputLabel for="particulars" value="Particulars" required="true"/>
                                        <TextInput
                                            id="particulars"
                                            type="text"
                                            class="mt-1 block w-full"
                                            v-model="add_creditor_form.particulars"
                                            autocomplete="particulars"
                                            placeholder="Enter particulars."
                                        />
                                        <InputError class="mt-2" :message="add_creditor_form.errors.particulars" />
                                    </div>

                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="add_creditor_dialog = false"
                                        ></v-btn>

                                        <v-btn
                                            color="primary"
                                            text="Save"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': add_creditor_form.processing }"
                                            :loading="add_creditor_form.processing"
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
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import ExportButton from '@/Components/ExportButton.vue';
import SearchBar from '@/Components/SearchBar.vue';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import SelectInput from '@/Components/SelectInput.vue';
import DatePicker from '@/Components/DatePicker.vue';

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
        uacs_dialog: false,
        uacs_dialog_data: null,
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
                title: 'Creditor',
                align: 'start',
                key: 'creditor',
                sortable: true,
            },
            {
                title: 'Reference',
                align: 'center',
                children: [
                    {
                        title: 'Date',
                        value: 'reference_date',
                        align: 'start'
                    },
                    {
                        title: 'Serial No.',
                        value: 'serial_number',
                        align: 'start'
                    },
                ]
            },
            {
                title: 'UACS Object Code',
                align: 'start',
                key: 'uacs',
                sortable: true,
            },
            {
                title: 'Utilization',
                align: 'start',
                key: 'utilization',
                sortable: true,
            },
            // {
            //     title: 'Utilized BA',
            //     align: 'center',
            //     key: 'utilized_ba',
            //     sortable: true,
            // },
            {
                title: 'Disbursements',
                align: 'start',
                key: 'disbursements',
                sortable: true,
            },
            {
                title: 'Check No.',
                value: 'check_number',
                align: 'start',
                sortable: false,
            },
            {
                title: 'Date',
                value: 'check_date',
                align: 'start'
            },
            {
                title: 'Particulars',
                value: 'particulars',
                align: 'start',
                sortable: false,
            },
            {
                title: 'Unpaid Utilization',
                align: 'center',
                children: [
                    {
                        title: 'Due and Demandable',
                        value: 'uu_due_and_demandable',
                        align: 'start'
                    },
                    {
                        title: 'Not Yet Due and Demandable',
                        value: 'uu_not_yet_due_and_demandable',
                        align: 'start'
                    },
                ]
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
            creditor: 'REYMARK GALLETES',
            reference_date: '01-01-2025',
            serial_number: '02-206441-2025-01-003',
            uacs: '50203090 00',
            utilization: '10,000',
            utilized_ba: '1,903,672.00',
            disbursements: 'No data',
            check_number: 'No data',
            particulars_date: 'No data',
            particulars: 'C/a Fuel expenses for rice field land preparation',
            total_mooe: '10,000.00',
            total_co: '0.00',
            overall_total: '10,000.00',
          },
          {
            number: 2,
            id: 2,
            creditor: 'DELILAH ZIPAGANG',
            reference_date: '02-04-2025',
            serial_number: '02-206441-2025-02-012',
            uacs: '50216010 00',
            utilization: '10,000',
            utilized_ba: '1,903,672.00',
            disbursements: 'No data',
            check_number: 'No data',
            particulars_date: 'No data',
            particulars: 'payment of labor(pulling,transpalnting & hauling of seedlings)',
            total_mooe: '46,800.00',
            total_co: '0.00',
            overall_total: '46,800.00',
          },
        ],
        uacs_dialog_table: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'UACS Code',
                align: 'center',
                key: 'uacs_code',
                sortable: false,
            },
            {
                title: 'UACS Description',
                align: 'starts',
                key: 'uacs_description',
                sortable: false,
            },
            {
                title: 'Type',
                align: 'center',
                key: 'type',
                sortable: false,
            },
            {
                title: 'Amount',
                align: 'center',
                key: 'amount',
                sortable: false,
            },
        ],
        // uacs_dialog_table_data: [
        //     {
        //         number: 1,
        //         uacs_code: '50203090 00',
        //         uacs_description: 
        //     }
        // ],
        breadcrumbs_items: [
            {
                title: 'Transaction',
                active: false
            },
            {
                title: 'Expenses',
                active: false
            },
            {
                title: 'Creditors',
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
        },
        view_uacs(data){
            this.uacs_dialog_data = data;
            this.uacs_dialog = true;
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