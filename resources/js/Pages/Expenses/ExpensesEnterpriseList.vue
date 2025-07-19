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
                            <v-card-title class="d-flex align-center pe-2">
                                <v-icon icon="mdi-cash-remove"></v-icon> &nbsp;
                                Expenses

                                

                                <!-- <v-spacer></v-spacer>

                                <v-text-field
                                    v-model="search"
                                    density="compact"
                                    label="Search"
                                    prepend-inner-icon="mdi-magnify"
                                    variant="solo-filled"
                                    flat
                                    hide-details
                                    single-line
                                ></v-text-field>

                                <v-btn
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-refresh"
                                    rounded="l"
                                    text="Refresh"
                                    border
                                    variant="tonal"
                                    color="green-darken-4"
                                    @click="onClick"
                                ></v-btn>

                                <v-btn
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-plus"
                                    rounded="l"
                                    text="Add Product"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="dialog = true"
                                ></v-btn> -->
                            </v-card-title>

                            <div class="mb-3">
                                <v-row dense>
                                    <v-col cols="12" md="9" lg="9">
                                        <v-text-field
                                            v-model="search"
                                            density="compact"
                                            label="Search"
                                            prepend-inner-icon="mdi-magnify"
                                            variant="solo-filled"
                                            flat
                                            hide-details
                                            single-line class="border"
                                        ></v-text-field>
                                    </v-col>
                                    <v-col cols="12" md="3" lg="3" class="text-end">
                                        <div>
                                            <v-btn
                                            class="ms-2 text-none tracking-normal"
                                            prepend-icon="mdi-refresh"
                                            rounded="l"
                                            text="Refresh"
                                            border
                                            variant="tonal"
                                            color="green-darken-4"
                                            @click="onClick"
                                        ></v-btn>

                                        <v-btn
                                            class="ms-2 text-none tracking-normal"
                                            prepend-icon="mdi-plus"
                                            rounded="l"
                                            text="Add New"
                                            variant="flat"
                                            color="green-darken-4"
                                            @click="dialog = true"
                                        ></v-btn>
                                        </div>
                                    </v-col>
                                </v-row>
                            </div>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['name']" :headers="header"
                                :items="products" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <template v-slot:item.budget="{item}">
                                    <div v-if="item.budget == ''">
                                        <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-exclamation-thick" @click="set_budget_dialog = true">Set Budget</v-btn>
                                    </div>
                                    <div v-else>
                                        {{ item.budget }}
                                    </div>
                                </template>

                                <template v-slot:item.creditors="{item}">
                                    <div>
                                        <Link :href="route('expenses.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View List</Link>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <td style="width: fit-content; white-space: nowrap;" class="text-end">
                                        <v-btn variant="flat" color="info" class="mr-2 text-none" prepend-icon="mdi-eye">View</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete" @click="deleteProduct">Remove</v-btn>
                                        <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                                    </td>
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
                title: 'Enterprise',
                align: 'start',
                key: 'enterprise',
                sortable: true,
            },
            {
                title: 'Budgeted Amount',
                align: 'center',
                key: 'budget',
                sortable: true,
            },
            {
                title: 'Total MOOE',
                align: 'center',
                key: 'total_mooe',
                sortable: true,
            },
            {
                title: 'Total CO',
                align: 'center',
                key: 'total_co',
                sortable: true,
            },
            {
                title: 'Overall Total',
                align: 'center',
                key: 'overall_total',
                sortable: true,
            },
            {
                title: 'Creditors',
                align: 'center',
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