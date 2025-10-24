<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import FlashMessage from '@/Components/FlashMessage.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm, usePage } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import Swal from 'sweetalert2'
import { nextTick, ref, watch } from 'vue';
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'
import UserAccountsListPDF from '@/Components/PDFs/UserAccountsListPDF.vue';
import SelectInput from '@/Components/SelectInput.vue';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import ExportButton from '@/Components/ExportButton.vue';
import SearchBar from '@/Components/SearchBar.vue';

const page = usePage();
// const success = ref(page.props.flash?.success);

// Optionally watch for changes
// watch(() => page.props.flash, (newFlash) => {
//     success.value = newFlash?.success;
// });

// Access props
const clients = page.props.clients
const client = {
    client_id: '',
    client_name: ''
}

const current_user = {
    name: page.props.auth.user.first_name + " " + page.props.auth.user.last_name,
    // campus: page.props.auth.user.campus.campus
}

const isPDFExporting = ref(false)
const isExcelExporting = ref(false)
const pdfSection = ref(null)
const add_user_dialog = ref(false)
const edit_user_dialog = ref(false)
const reset_user_password_dialog = ref(false)
const change_account_status_dialog = ref(false)

// Define the form
const edit_user_form = useForm({
    user_id: '',
    last_name: '',
    first_name: '',
    middle_name: '',
    sex: '',
    email: '',
    campus: '',
    designation: '',
    reports: false,
    enterprises: false,
    inventory: false,
    income: false,
    expenses: false
})

// Define the method to fill the form
function editUserData(index) {
  const user = clients[index]
  if (!user) return

  edit_user_form.user_id = user.id

  edit_user_form.last_name = user.full_name.split(',')[0].trim()
  const firstAndMiddle = user.full_name.split(',')[1]?.trim().split(' ') || []

  edit_user_form.first_name = firstAndMiddle[0] || ''
  edit_user_form.middle_name = firstAndMiddle[1] || ''

  edit_user_form.sex = user.sex
  edit_user_form.email = user.email
  edit_user_form.campus = user.campus_id      // Adjust if needed to use campus_id
  edit_user_form.designation = user.designation
  edit_user_form.reports = user.reports || false
  edit_user_form.enterprises = user.enterprises || false
  edit_user_form.inventory = user.inventory || false
  edit_user_form.income = user.income || false
  edit_user_form.expenses = user.expenses || false

    edit_user_dialog.value = true;
}

function resetPassword(index){
    console.log(index)
    const user = clients[index]
    if (!user) return

    reset_password_form.client_id = user.id
    reset_password_form.client_name = user.full_name

    reset_user_password_dialog.value = true;
}

function changeAccountStatus(index){
    console.log(index)
    const user = clients[index]
    if (!user) return

    change_account_status_form.client_id = user.id
    change_account_status_form.client_name = user.full_name
    change_account_status_form.client_account_status = user.account_status

    change_account_status_dialog.value = true;
}

const formatPrintedDate = () => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')

  let hours = now.getHours()
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const ampm = hours >= 12 ? 'PM' : 'AM'
  hours = hours % 12 || 12 // convert 0 to 12

  return `${year}-${month}-${day} at ${hours}:${minutes} ${ampm}`
}

const generatePdfTitle = () => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const reportTitle = 'UserAccounts'
  const randomId = Math.random().toString(36).substring(2, 8).toUpperCase()

  return `${year}-${month}-${day}_${reportTitle}_${randomId}`
}

const generatePDF = async () => {
    isPDFExporting.value = true
  await nextTick() // Ensure content is rendered

  const doc = new jsPDF('p', 'mm', 'a4')
  const pdfTitle = generatePdfTitle()
  const pageWidth = doc.internal.pageSize.getWidth()
  const pageHeight = doc.internal.pageSize.getHeight()

  doc.setProperties({ title: pdfTitle })

  const logo = new Image()
  logo.src = '/storage/isu_seal.png' // Make sure this exists in public folder

  logo.onload = async () => {
    const canvas = await html2canvas(pdfSection.value.$el, { scale: 2 })
    const imgData = canvas.toDataURL('image/png')

    const contentHeight = (canvas.height * 210) / canvas.width
    const totalPages = Math.ceil(contentHeight / pageHeight)

    for (let i = 0; i < totalPages; i++) {
      if (i !== 0) doc.addPage()

      // === HEADER ===
      doc.addImage(logo, 'PNG', 15, 10, 18, 18)
      doc.setFontSize(11)
      doc.setTextColor(0)
      doc.text('Republic of the Philippines', 40, 15)
      doc.setFontSize(13)
      doc.setFont('helvetica', 'bold')
      doc.text('ISABELA STATE UNIVERSITY', 40, 20)
      doc.setFontSize(11)
      doc.setFont('helvetica', 'normal')
      doc.text('Echague, Isabela', 40, 25)
      doc.setLineWidth(0.1)
      doc.line(10, 30, pageWidth - 10, 30)

      // === CONTENT ===
      doc.addImage(
        imgData,
        'PNG',
        10,
        35,
        190,
        0,
        '',
        'FAST',
        0,
        i * pageHeight * (canvas.width / 210)
      )

      // === FOOTER ===
    doc.setFillColor(255, 255, 255)
    doc.rect(0, pageHeight - 20, pageWidth, 20, 'F')

    // === Left: Page number ===
    const pageText = `Page ${i + 1} of ${totalPages}`
    doc.setFontSize(10)
    doc.setTextColor(0)
    doc.text(pageText, 10, pageHeight - 10) // left aligned

    // === Right: Printed by and Date ===
    const printedBy = `Printed by: ${current_user.name}`.toUpperCase()
    const printedDate = formatPrintedDate().toUpperCase()

    // Printed by
    doc.setFontSize(8)
    doc.setTextColor(0) // black
    const printedByWidth = doc.getTextWidth(printedBy)
    doc.text(printedBy, pageWidth - printedByWidth - 10, pageHeight - 10)

    // Printed date (lighter gray)
    doc.setTextColor(160, 160, 160) // lighter gray
    const printedDateWidth = doc.getTextWidth(printedDate)
    doc.text(printedDate, pageWidth - printedDateWidth - 10, pageHeight - 6)


    }

    // doc.save('isu-enterprise-report.pdf')

    // === STREAM the PDF ===
    doc.output('dataurlnewwindow') // Stream view in new tab
    isPDFExporting.value = false
  }
}

watch(
  () => page.props.flash,
  (flash) => {
    if (flash?.success) {
      Swal.fire({
        icon: 'success',
        title: 'Success',
        text: flash.success,
        confirmButtonColor: '#3085d6'
      })
    } else if (flash?.error) {
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: flash.error,
        confirmButtonColor: '#d33'
      })
    }
  },
  { immediate: true }
)


const reset_password_form = useForm({
    client_id: '',
    client_name: ''
})

const change_account_status_form = useForm({
    client_id: '',
    client_name: '',
    client_account_status: ''
})


const add_user_form = useForm({
    role: '',
    last_name: '',
    first_name: '',
    middle_name: '',
    sex: '',
    email: '',
    campus: '',
    designation: '',
    accounts: false,
    reports: false,
    enterprises: false,
    inventory: false,
    income: false,
    expenses: false,
    proposals: false
})

const submit = () => {
    // console.log(add_user_form.data());
    add_user_form.post(route('accounts.store'), {
        onSuccess: () => {
            add_user_form.reset()
            add_user_dialog.value = false // Close dialog
        },
    });
};

const update = (id) => {
    // console.log(add_user_form.data());
    edit_user_form.put(route('accounts.update', id), {
        onSuccess: () => {
            edit_user_form.reset()
            edit_user_dialog.value = false // Close dialog
        },
    });
};

const reset_password = (id) => {
    // console.log(add_user_form.data());
    reset_password_form.put(route('accounts.reset', id), {
        onSuccess: () => {
            reset_password_form.reset()
            reset_user_password_dialog.value = false // Close dialog
        },
    });
};

const change_account_status = (id) => {
    // console.log(add_user_form.data());
    change_account_status_form.put(route('accounts.change_status', id), {
        onSuccess: () => {
            change_account_status_form.reset()
            change_account_status_dialog.value = false // Close dialog
        },
    });
};
</script>

<template>
    <Head title="Accounts" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">User Accounts</h2>
        </template>

        <div>
            <div class="mx-auto sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items"/>
                </div>

                <div class="overflow-hidden bg-white shadow-sm sm:rounded-lg  border border-stone-200">

                    <div class="p-6 text-gray-900">
                        <v-card flat>
                            <v-card-title class="d-flex align-center pe-2 justify-space-between">
                                <!-- Left Section: Icon + Text -->
                                <div class="d-flex align-center pe-2">
                                    <v-icon
                                        :size="$vuetify.display.smAndDown ? 18 : 24"
                                        class="me-2 font-weight-bold"
                                    >
                                        mdi-account-group
                                    </v-icon>
                                    <span
                                        :class="$vuetify.display.smAndDown ? 'text-lg font-weight-semibold' : 'text-2xl font-weight-semibold'"
                                    >
                                        User Accounts
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
                                    text="Add New Record"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_user_dialog = true"
                                ></v-btn>

                                <!-- Icon-only button for small devices -->
                                <v-btn
                                    v-else
                                    class="ms-2"
                                    icon
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_user_dialog = true"
                                >
                                    <v-icon size="18" class="font-weight-bold">mdi-plus</v-icon>
                                </v-btn>
                                </div>
                            </v-card-title>

                            <ExportSearchWrapper>
                                <div class="d-flex flex-wrap gap-2">
                                    <ExportButton
                                        :text="isExcelExporting ? 'Exporting...' : 'Export to Excel'"
                                        icon="mdi-file-excel"
                                        @click="generateExcel"
                                        :disabled="isExcelExporting"
                                    />
                                    <ExportButton
                                        :text="isPDFExporting ? 'Generating PDF...' : 'Print to PDF'"
                                        icon="mdi-printer"
                                        @click="generatePDF"
                                        :disabled="isPDFExporting"
                                    />
                                </div>
                                <SearchBar v-model="search" />
                            </ExportSearchWrapper>

                            <div class="mb-6 mt-4">
                                <FilterWrapper>
                                    <!-- Campus Filter -->
                                    <SelectInput>
                                        <option disabled value="">-- Filter by Campus --</option>
                                        <option value="All">All Campuses</option>
                                        <option value="San Mateo">San Mateo</option>
                                        <option value="Cauayan">Cauayan</option>
                                    </SelectInput>

                                    <!-- Sex Filter -->
                                    <SelectInput>
                                        <option disabled value="">-- Filter by Sex --</option>
                                        <option value="Male">All</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                    </SelectInput>

                                    <!-- Account Status Filter -->
                                    <SelectInput>
                                        <option disabled value="">-- Filter by Status --</option>
                                        <option value="Active">Active</option>
                                        <option value="Inactive">Inactive</option>
                                    </SelectInput>
                                </FilterWrapper>
                            </div>


                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="$page.props.clients" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{ item }">
                                    <div class="text-start">{{ item.number }}.</div>
                                </template>

                                <template v-slot:item.full_name="{ item }">
                                    <div class="d-flex align-center">
                                        <v-avatar class="mr-4">
                                            <v-img
                                                :src="`/storage/uploads/avatar/default_avatar.jpg`"
                                                height="64"
                                                cover
                                            ></v-img>
                                        </v-avatar>
                                        <div>
                                            <p class="font-bold">{{ item.full_name }}</p>
                                            <p class="text-sm text-disabled">{{ item.email }}</p>
                                        </div>
                                    </div>
                                </template>

                                <template v-slot:item.role="{ item }">
                                    <v-chip size="small" label :color="item.role == 'Admin' ? 'green' : 'purple'">{{ item.role }}</v-chip>
                                </template>

                                <template v-slot:item.permission="{ item }">

                                    <div class="d-flex align-center">
                                        <v-chip size="small" color="info" label class="mr-2">{{ item.permission[0] }}</v-chip>
                                        <div v-if="(item.permission).length > 1">
                                            <v-chip size="small" color="info" label class="mr-2" prepend-icon="mdi-plus">{{ item.permission.length - 1}} more</v-chip>
                                        </div>
                                    </div>
                                </template>

                                <template v-slot:item.account_status="{ item }">
                                    <div class="text-start">
                                    <v-chip
                                        :color="item.account_status === 'Verified' ? 'green' :
                                                item.account_status === 'Not Verified' ? 'orange' :
                                                item.account_status === 'Locked' ? 'slate' :
                                                item.account_status === 'Deactivated' ? 'red' : 'grey'"
                                        :text="item.account_status"
                                        class="text-uppercase"
                                        size="small"
                                        label
                                    ></v-chip>
                                    </div>
                                </template>

                                <template v-slot:item.last_updated="{ item }">
                                    <td style="width: fit-content; white-space: nowrap;" class="text-start pa-4">
                                        <p class="text-xs font-bold text-uppercase text-gray-500">Last Modified</p>
                                        <p class="my-1">{{ item.date }}</p>
                                        <p class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600">{{ item.updated_by }}</p>
                                    </td>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end">
                                        <div class="inline-flex rounded-md shadow-xs" role="group">
                                            <!-- <button type="button" class="inline-flex items-center px-4 py-4 text-sm font-medium text-white border border-gray-200 rounded-s-lg hover:bg-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 bg-blue-500">
                                                <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                                                <path d="M10 0a10 10 0 1 0 10 10A10.011 10.011 0 0 0 10 0Zm0 5a3 3 0 1 1 0 6 3 3 0 0 1 0-6Zm0 13a8.949 8.949 0 0 1-4.951-1.488A3.987 3.987 0 0 1 9 13h2a3.987 3.987 0 0 1 3.951 3.512A8.949 8.949 0 0 1 10 18Z"/>
                                                </svg>
                                            </button> -->
                                            <v-tooltip :text="$page.props.auth.user.role == 'Admin' ? 'Edit user details.' : 'You don/t have the permission to use this feature.'" location="top">
                                                <template v-slot:activator="{ props }">
                                                    <button :disabled="$page.props.auth.user.role != 'Admin'" v-bind="props" @click="editUserData(item.number-1)" type="button" class="inline-flex items-center px-4 py-4 text-sm font-medium text-white bg-yellow-500 border-t border-b border-gray-200 rounded-s-lg hover:bg-yellow-700 focus:z-10 focus:ring-2 focus:ring-yellow-700 focus:text-yellow-700 disabled:bg-gray-300 disabled:text-gray-500">
                                                        <v-icon size="15">mdi-account-edit</v-icon>
                                                    </button>
                                                </template>
                                            </v-tooltip>

                                            <v-tooltip text="Reset user password." location="top">
                                                <template v-slot:activator="{ props }">
                                                    <button v-bind="props" @click="resetPassword(item.number-1)" type="button" class="inline-flex items-center px-4 py-4 text-sm font-medium text-white bg-slate-500 border-t border-b border-gray-200 hover:bg-slate-700 hover:text-slate-700 focus:z-10 focus:ring-2 focus:ring-slate-700 focus:text-slate-700">

                                                        <v-icon size="15">mdi-key-variant</v-icon>
                                                    </button>
                                                </template>
                                            </v-tooltip>

                                            <v-tooltip :text="$page.props.auth.user.role == 'Admin' ? 'Reactivate user.' : 'You don/t have the permission to use this feature.'" location="top"  v-if="item.account_status == 'Deactivated'" >
                                                <template v-slot:activator="{ props }">
                                                    <button :disabled="$page.props.auth.user.role != 'Admin'" v-bind="props" @click="changeAccountStatus(item.number-1)" type="button" class="inline-flex items-center px-4 py-4 text-sm font-medium text-white bg-emerald-500 border border-gray-200 rounded-e-lg hover:bg-emerald-700 hover:text-emerald-700 focus:z-10 focus:ring-2 focus:ring-emerald-700 focus:text-emerald-700 disabled:bg-gray-300 disabled:text-gray-500">

                                                        <v-icon size="15">mdi-lock-open-variant</v-icon>
                                                    </button>
                                                </template>
                                            </v-tooltip>

                                            <v-tooltip :text="$page.props.auth.user.role == 'Admin' ? 'Deactivate user.' : 'You don/t have the permission to use this feature.'" location="top" v-else >
                                                <template v-slot:activator="{ props }">
                                                    <button  :disabled="$page.props.auth.user.role != 'Admin'" v-bind="props" @click="changeAccountStatus(item.number-1)" type="button" class="inline-flex items-center px-4 py-4 text-sm font-medium text-white bg-red-500 border border-gray-200 rounded-e-lg hover:bg-red-700 hover:text-emerald-700 focus:z-10 focus:ring-2 focus:ring-red-700 focus:text-red-700 disabled:bg-gray-300 disabled:text-gray-500">

                                                        <v-icon size="15">mdi-lock</v-icon>
                                                    </button>
                                                </template>
                                            </v-tooltip>
                                        </div>

                                        <!-- <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-pencil" @click="editUserData(item.number-1)">Edit</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete" @click="deleteProduct">Delete</v-btn> -->
                                        <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                    <!-- dialogs  -->
                     <div>
                        <!-- add new user account  -->
                         <v-dialog v-model="add_user_dialog" persistent max-width="900">
                            <v-card prepend-icon="mdi-account" title="Add User Account" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="submit">
                                            <div class="mb-4" v-if="$page.props.auth.user.role == 'Admin'">
                                                <label for="role" class="block mb-2 text-sm font-medium text-gray-900">User Role <span class="text-red-500">*</span></label>
                                                <select id="role" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_user_form.role">
                                                    <option disabled value="">-- Select User Role --</option>
                                                    <option value="President">University President</option>
                                                    <option value="VP">University Vice President</option>
                                                    <option value="University">University Director</option>
                                                    <option value="Campus">Campus Director</option>
                                                    <option value="User">User</option>
                                                </select>
                                            </div>
                                            <div class="mb-4">
                                                <v-row>
                                                    <v-col>
                                                        <div>
                                                            <label for="last_name" class="block mb-2 text-sm font-medium text-gray-900">Last name <span class="text-red-500">*</span></label>
                                                            <input type="text" id="last_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your last name." required v-model="add_user_form.last_name"/>

                                                            <InputError class="mt-2" :message="add_user_form.errors.last_name" />
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="first_name" class="block mb-2 text-sm font-medium text-gray-900">First name <span class="text-red-500">*</span></label>
                                                            <input type="text" id="first_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your first name." required v-model="add_user_form.first_name"/>
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="middle_name" class="block mb-2 text-sm font-medium text-gray-900">Middle name</label>
                                                            <input type="text" id="middle_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your middle name." v-model="add_user_form.middle_name"/>
                                                        </div>
                                                    </v-col>
                                                </v-row>
                                            </div>
                                            <div class="mb-4">
                                                <label for="countries" class="block mb-2 text-sm font-medium text-gray-900">Sex <span class="text-red-500">*</span></label>
                                                <select id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_user_form.sex">
                                                    <option disabled value="">-- Select Sex --</option>
                                                    <option value="Male">Male</option>
                                                    <option value="Female">Female</option>
                                                </select>
                                            </div>
                                            <div class="mb-4">
                                                <div>
                                                    <label for="email_address" class="block mb-2 text-sm font-medium text-gray-900">Email address <span class="text-red-500">*</span></label>
                                                    <input type="email" id="email_address" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your email address." v-model="add_user_form.email"/>

                                                    <InputError class="mt-2" :message="add_user_form.errors.email" />
                                                </div>
                                            </div>
                                            <div class="mb-4">
                                                <v-row>
                                                    <v-col>
                                                        <div>
                                                            <label for="countries" class="block mb-2 text-sm font-medium text-gray-900">Campus <span class="text-red-500">*</span></label>
                                                            <select id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_user_form.campus">
                                                                <option disabled value="">-- Select Campus --</option>
                                                                <option 
                                                                    v-for="item in $page.props.campuses" 
                                                                    :key="item.id" 
                                                                    :value="item.id"
                                                                >
                                                                    {{ item.campus }}
                                                                </option>
                                                            </select>
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="designation" class="block mb-2 text-sm font-medium text-gray-900">Designation <span class="text-red-500">*</span></label>
                                                            <input type="text" id="designation" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your designation." required v-model="add_user_form.designation"/>
                                                        </div>
                                                    </v-col>
                                                </v-row>
                                            </div>
                                            <div class="mb-2">
                                                <p class="block mb-2 text-sm font-medium text-gray-900">Permissions (Optional)</p>
                                                <div>
                                                    <div class="flex p-4 mb-4 text-sm text-yellow-800 border border-yellow-300 rounded-lg bg-yellow-50" role="alert">
                                                        <svg class="shrink-0 inline w-4 h-4 me-3 mt-[2px]" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                                                            <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
                                                        </svg>
                                                        <span class="sr-only">Warning</span>
                                                        <div>
                                                            <span class="font-medium">By default, the user can only access records within the selected campus. By checking one of these, you allow this user to:</span>
                                                            <ul class="mt-1.5 list-disc list-inside">
                                                                <li>View <span class="font-bold">all the records in each campuses</span>.</li>
                                                                <li>Print and download reports of <span class="font-bold">all the records in each campuses</span></li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <ul class="items-center w-full text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg sm:flex">
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="accounts" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.accounts">
                                                            <label for="accounts" class="w-full py-3 ms-2 text-sm text-gray-900">Accounts</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="reports" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.reports">
                                                            <label for="reports" class="w-full py-3 ms-2 text-sm text-gray-900">Reports</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="enterprises" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.enterprises">
                                                            <label for="enterprises" class="w-full py-3 ms-2 text-sm text-gray-900">Enterprises</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="inventory" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.inventory">
                                                            <label for="inventory" class="w-full py-3 ms-2 text-sm text-gray-900">Inventory</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="income" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.income">
                                                            <label for="income" class="w-full py-3 ms-2 text-sm text-gray-900">Income</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="expenses" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.expenses">
                                                            <label for="expenses" class="w-full py-3 ms-2 text-sm text-gray-900">Expenses</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="proposals" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="add_user_form.proposals">
                                                            <label for="proposals" class="w-full py-3 ms-2 text-sm text-gray-900">Proposals</label>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </div>
                                            <v-divider class="my-4"></v-divider>
                                            <div class="text-end">
                                                <v-btn
                                                    text="Close"
                                                    variant="plain"
                                                    @click="add_user_dialog = false"
                                                ></v-btn>

                                                <v-btn
                                                    color="primary"
                                                    text="Save"
                                                    variant="tonal"
                                                    type="submit"
                                                    :class="{ 'opacity-25': add_user_form.processing }"
                                                    :disabled="add_user_form.processing"
                                                ></v-btn>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>

                        <!-- edit user account  -->
                         <v-dialog v-model="edit_user_dialog" persistent max-width="800">
                            <v-card prepend-icon="mdi-account" title="Edit User Account" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="update(edit_user_form.user_id)">
                                            <div class="mb-4">
                                                <v-row>
                                                    <v-col>
                                                        <div>
                                                            <label for="last_name" class="block mb-2 text-sm font-medium text-gray-900">Last name <span class="text-red-500">*</span></label>
                                                            <input type="text" id="last_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your last name." required v-model="edit_user_form.last_name"/>

                                                            <InputError class="mt-2" :message="edit_user_form.errors.last_name" />
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="first_name" class="block mb-2 text-sm font-medium text-gray-900">First name <span class="text-red-500">*</span></label>
                                                            <input type="text" id="first_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your first name." required v-model="edit_user_form.first_name"/>
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="middle_name" class="block mb-2 text-sm font-medium text-gray-900">Middle name</label>
                                                            <input type="text" id="middle_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your middle name." v-model="edit_user_form.middle_name"/>
                                                        </div>
                                                    </v-col>
                                                </v-row>
                                            </div>
                                            <div class="mb-4">
                                                <label for="countries" class="block mb-2 text-sm font-medium text-gray-900">Sex <span class="text-red-500">*</span></label>
                                                <select id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="edit_user_form.sex">
                                                    <option disabled value="">-- Select Sex --</option>
                                                    <option value="Male">Male</option>
                                                    <option value="Female">Female</option>
                                                </select>
                                            </div>
                                            <div class="mb-4">
                                                <div>
                                                    <label for="email_address" class="block mb-2 text-sm font-medium text-gray-900">Email address <span class="text-red-500">*</span></label>
                                                    <input type="email" id="email_address" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter your email address." v-model="edit_user_form.email"/>

                                                    <InputError class="mt-2" :message="edit_user_form.errors.email" />
                                                </div>
                                            </div>
                                            <div class="mb-4">
                                                <v-row>
                                                    <v-col>
                                                        <div>
                                                            <label for="countries" class="block mb-2 text-sm font-medium text-gray-900">Campus <span class="text-red-500">*</span></label>
                                                            <select id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="edit_user_form.campus">
                                                                <option disabled value="">-- Select Campus --</option>
                                                                <option 
                                                                    v-for="item in $page.props.campuses" 
                                                                    :key="item.id" 
                                                                    :value="item.id"
                                                                >
                                                                    {{ item.campus }}
                                                                </option>
                                                            </select>
                                                        </div>
                                                    </v-col>
                                                    <v-col>
                                                        <div>
                                                            <label for="designation" class="block mb-2 text-sm font-medium text-gray-900">Designation <span class="text-red-500">*</span></label>
                                                            <input type="text" id="designation" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="John" required v-model="edit_user_form.designation"/>
                                                        </div>
                                                    </v-col>
                                                </v-row>
                                            </div>
                                            <div class="mb-4"></div>
                                            <div class="mb-2">
                                                <p class="block mb-2 text-sm font-medium text-gray-900">Permissions (Optional)</p>
                                                <div>
                                                    <div class="flex p-4 mb-4 text-sm text-yellow-800 border border-yellow-300 rounded-lg bg-yellow-50" role="alert">
                                                        <svg class="shrink-0 inline w-4 h-4 me-3 mt-[2px]" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                                                            <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
                                                        </svg>
                                                        <span class="sr-only">Warning</span>
                                                        <div>
                                                            <span class="font-medium">By default, the user can only access records within the selected campus. By checking one of these, you allow this user to:</span>
                                                            <ul class="mt-1.5 list-disc list-inside">
                                                                <li>View <span class="font-bold">all the records in each campuses</span>.</li>
                                                                <li>Print and download reports of <span class="font-bold">all the records in each campuses</span></li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <ul class="items-center w-full text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg sm:flex">
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="accounts" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.accounts">
                                                            <label for="accounts" class="w-full py-3 ms-2 text-sm text-gray-900">Accounts</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="reports" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.reports">
                                                            <label for="reports" class="w-full py-3 ms-2 text-sm text-gray-900">Reports</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="enterprises" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.enterprises">
                                                            <label for="enterprises" class="w-full py-3 ms-2 text-sm text-gray-900">Enterprises</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="inventory" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.inventory">
                                                            <label for="inventory" class="w-full py-3 ms-2 text-sm text-gray-900">Inventory</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="income" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.income">
                                                            <label for="income" class="w-full py-3 ms-2 text-sm text-gray-900">Income</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="expenses" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.expenses">
                                                            <label for="expenses" class="w-full py-3 ms-2 text-sm text-gray-900">Expenses</label>
                                                        </div>
                                                    </li>
                                                    <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r">
                                                        <div class="flex items-center ps-3">
                                                            <input id="proposals" type="checkbox" value="" class="w-4 h-4 text-emerald-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-emerald-500 dark:focus:ring-emerald-600" v-model="edit_user_form.proposals">
                                                            <label for="proposals" class="w-full py-3 ms-2 text-sm text-gray-900">Proposals</label>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </div>
                                            <v-divider class="my-4"></v-divider>
                                            <div class="text-end">
                                                <v-btn
                                                    text="Close"
                                                    variant="plain"
                                                    @click="edit_user_dialog = false"
                                                ></v-btn>

                                                <v-btn
                                                    color="primary"
                                                    text="Save Changes"
                                                    variant="tonal"
                                                    type="submit"
                                                    :class="{ 'opacity-25': edit_user_form.processing }"
                                                    :disabled="edit_user_form.processing"
                                                ></v-btn>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>

                        <!-- reset user password  -->
                         <v-dialog v-model="reset_user_password_dialog" persistent max-width="500">
                            <v-card prepend-icon="mdi-key-variant" title="Reset Password?" class="pa-2">
                                <v-card-text>
                                    <form @submit.prevent="reset_password(reset_password_form.client_id)">
                                        <div class="flex justify-space-between">
                                            <div>
                                                <v-icon color="warning" icon="mdi-information" size="40"></v-icon>
                                            </div>
                                            <div class="ms-4">
                                                Are you sure you want to reset the password of <span class="text-uppercase font-bold">{{ reset_password_form.client_name }}</span>?
                                            </div>
                                        </div>

                                        <v-divider class="my-4"></v-divider>
                                        <div class="text-end">
                                            <v-btn
                                                text="No, close"
                                                variant="plain"
                                                @click="reset_user_password_dialog = false"
                                            ></v-btn>

                                            <v-btn
                                                color="warning"
                                                text="Yes, reset"
                                                variant="tonal"
                                                type="submit"
                                                :class="{ 'opacity-25': reset_password_form.processing }"
                                                :disabled="reset_password_form.processing"
                                            ></v-btn>
                                        </div>
                                    </form>
                                </v-card-text>
                            </v-card>
                         </v-dialog>

                         <!-- deactivate user account  -->
                          <v-dialog v-model="change_account_status_dialog" persistent max-width="500">
                            <v-card prepend-icon="mdi-archive-alert" :title="change_account_status_form.client_account_status == 'Deactivated' ? 'Reactivate Account?' : 'Deactivate Account?'" class="pa-2">
                                <v-card-text>
                                    <form @submit.prevent="change_account_status(change_account_status_form.client_id)">
                                        <div class="flex justify-space-between">
                                            <div>
                                                <v-icon :color="change_account_status_form.client_account_status == 'Deactivated' ? 'info' : 'error'" icon="mdi-information" size="40"></v-icon>
                                            </div>
                                            <div class="ms-4">
                                                Are you sure you want to <span v-if="change_account_status_form.client_account_status == 'Deactivated'">reactivate</span><span v-else>deactivate</span> this account: <span class="text-uppercase font-bold">{{ change_account_status_form.client_name }}</span>?
                                            </div>
                                        </div>

                                        <div v-if="change_account_status_form.client_account_status == 'Deactivated'" class="mt-4">
                                            <div class="flex items-center p-4 mb-4 text-sm text-blue-800 border border-blue-300 rounded-lg bg-blue-50" role="alert">
                                                <svg class="shrink-0 inline w-4 h-4 me-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                                                    <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
                                                </svg>
                                                <span class="sr-only">Info</span>
                                                <div>
                                                    <span class="font-medium">NOTE:</span> Reactivating this account will <span class="font-medium">restore the user's access to the system</span>. They will be able to log in and perform actions as usual.
                                                </div>
                                            </div>
                                        </div>

                                        <div v-else class="mt-4">
                                            <div class="flex items-center p-4 mb-4 text-sm text-red-800 border border-red-300 rounded-lg bg-red-50" role="alert">
                                                <svg class="shrink-0 inline w-4 h-4 me-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                                                    <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
                                                </svg>
                                                <span class="sr-only">Info</span>
                                                <div>
                                                    <span class="font-medium">WARNING:</span> Deactivating this account will immediately <span class="font-medium">revoke the user's access to the system</span>. They will no longer be able to log in or perform any actions until reactivated.
                                                </div>
                                            </div>
                                        </div>

                                        <v-divider class="my-4"></v-divider>
                                        <div class="text-end">
                                            <v-btn
                                                text="No, close"
                                                variant="plain"
                                                @click="change_account_status_dialog = false"
                                            ></v-btn>

                                            <v-btn
                                                :color="change_account_status_form.client_account_status == 'Deactivated' ? 'info' : 'error'"
                                                :text="change_account_status_form.client_account_status == 'Deactivated' ? 'Yes, reactivate' : 'Yes, deactivate'"
                                                variant="tonal"
                                                type="submit"
                                                :class="{ 'opacity-25': change_account_status_form.processing }"
                                                :disabled="change_account_status_form.processing"
                                            ></v-btn>
                                        </div>
                                    </form>
                                </v-card-text>
                            </v-card>
                         </v-dialog>
                     </div>


                     <!-- pdf  -->
                      <div>
                        <UserAccountsListPDF v-show="isPDFExporting" ref="pdfSection" :current_user="current_user" :user_accounts="$page.props.clients" :total_users="$page.props.total_users"/>
                      </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
  export default {
    data () {
      return {
        search: '',
        // add_user_dialog: false,
        header: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'User',
                align: 'start',
                key: 'full_name',
                sortable: true,
            },
            {
                title: 'Sex',
                align: 'start',
                key: 'sex',
                sortable: true,
            },
            {
                title: 'Campus',
                align: 'start',
                key: 'campus',
                sortable: true,
            },
            {
                title: 'Designation/Position',
                align: 'start',
                key: 'designation',
                sortable: true,
            },
            {
                title: 'Account Status',
                align: 'start',
                key: 'account_status',
                sortable: false,
            },
            {
                title: 'Last Updated',
                align: 'start',
                key: 'last_updated',
                sortable: false,
            },
            {
                title: 'Action',
                align: 'end',
                key: 'actions',
                sortable: false,
            },
        ],
        items: [
          {
            name: 'John Doe',
            image: '1.png',
            sex: 'M',
            campus: 'Echague',
            designation: 'CBAO Director',
            role: 'Admin',
            permission: ['FULL_ACCESS'],
            status: true,
            creation: {
                date: '2025-07-24 at 05:23 am',
                user: 'Cyra C.Cacho',
                status: 'Created'
            }
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Setup',
                active: false
            },
            {
                title: 'Accounts',
                active: true
            },
        ]
      }
    },
    methods: {
        addProduct(){
            console.log(this.add_user_form);
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