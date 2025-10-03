<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';

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
                                <div class="d-flex align-center pe-2">
                                    <v-icon
                                        :size="$vuetify.display.smAndDown ? 18 : 24"
                                        class="me-2 font-weight-bold"
                                    >
                                        mdi-cash-plus
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
                                    prepend-icon="mdi-plus"
                                    rounded="l"
                                    text="Add New Record"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_new_dialog = true"
                                ></v-btn>

                                <!-- Icon-only button for small devices -->
                                <v-btn
                                    v-else
                                    class="ms-2"
                                    icon
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_new_dialog = true"
                                >
                                    <v-icon size="18" class="font-weight-bold">mdi-plus</v-icon>
                                </v-btn>
                                </div>
                            </v-card-title>

                            <div class="my-3 d-flex flex-column flex-sm-row align-start align-sm-center justify-space-between gap-2">
                                <!-- Left: Buttons -->
                                <div class="d-flex flex-wrap gap-2">
                                    <v-btn
                                    class="text-none tracking-normal"
                                    prepend-icon="mdi-file-excel"
                                    rounded="l"
                                    text="Download Excel"
                                    variant="flat"
                                    color="grey-lighten-3"
                                    @click="generatePDF"
                                    ></v-btn>
                                    <v-btn
                                    class="text-none tracking-normal"
                                    prepend-icon="mdi-printer"
                                    rounded="l"
                                    text="Print PDF"
                                    variant="flat"
                                    color="grey-lighten-3"
                                    @click="generatePDF"
                                    ></v-btn>
                                </div>

                                <!-- Right: Search Field -->
                                <v-text-field
                                    v-model="search"
                                    density="compact"
                                    label="Search"
                                    prepend-inner-icon="mdi-magnify"
                                    variant="solo-filled"
                                    flat
                                    hide-details
                                    single-line
                                    class="border"
                                    :style="{
                                    minWidth: '200px',
                                    width: $vuetify.display.smAndDown ? '100%' : '300px'
                                    }"
                                ></v-text-field>
                            </div>

                            <div class="d-flex mb-4">
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
                            </div>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search" :headers="headers"
                                :items="products" hover :loading="loading"
                            >
                                <!-- <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <template v-slot:item.enterprise="{item}">
                                    <td style="width: fit-content; white-space: nowrap;">
                                        {{ item.enterprise }}
                                    </td>
                                </template> -->

                                <template v-slot:item.actions="{ item }">
                                    <td class="flex justify-end">
                                        <!-- <v-btn variant="flat" color="info" class="mr-2 text-none" prepend-icon="mdi-eye">View</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete" @click="deleteProduct">Remove</v-btn> -->
                                        <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn>
                                    </td>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                    <div>
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
                
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import Swal from 'sweetalert2';
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
                title: 'Enterprise',
                align: 'start',
                key: 'enterprise',
                sortable: true,
            },
            {
                title: new Date().getFullYear() + ' Current',
                align: 'center',
                key: 'current',
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
                title: 'Total',
                align: 'center',
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