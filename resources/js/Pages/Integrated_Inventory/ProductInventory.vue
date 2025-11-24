<script setup>
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, router, useForm, usePage } from '@inertiajs/vue3';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { nextTick, ref, watch } from 'vue';
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'
import Swal from 'sweetalert2';

const page = usePage()

const current_user = {
    name: page.props.auth.user.first_name + " " + page.props.auth.user.last_name,
    campus: page.props.auth.user.campus.campus
}

const isExporting = ref(false)
const pdfSection = ref(null)
const add_new_dialog = ref(false)
const edit_dialog = ref(false)
const dialog = ref(false);

const add_new_form = useForm({
    enterprise_id: '',
    enterprise_name: '',
    enterprise_category: '',
    quantity: 0,
    price: 0.00,
    unit: ''
})

const add_product = useForm({
    product_name: '',
    price: 0.00,
    quantity: 0,
    low: 0,
})

const form = useForm({
    product_name: '',
    product_name: '',
    product_quantity: 0,
    product_price: 0.00,
    product_category: '',
});

const submit = () => {
    // console.log(add_user_form.data());
    add_enterprise_form.post(route('enterprises.store'), {
        onSuccess: () => {
            add_enterprise_form.reset()
            add_enterprise_dialog.value = false // Close dialog
        },
    });
};

const submitProduct = () => {
    //console.log(add_product.data());
    add_product.post(route('integrated_inventory.store'), {
        onSuccess: () => {
            add_product.reset()
            dialog.value = false // Close dialog
        },
    });
};

// define the functions here
const export_excel_report = () => {
  console.log("Excel Export clicked")
  // your excel export logic here...
}

const export_pdf_report = () => {
    console.log("PDF Export clicked")
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
        const reportTitle = 'InventoryReport'
        const randomId = Math.random().toString(36).substring(2, 8).toUpperCase()

        return `${year}-${month}-${day}_${reportTitle}_${randomId}`
    }

    const generatePDF = async () => {
        isExporting.value = true
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
            //doc.output('dataurlnewwindow') // Stream view in new tab
            doc.save(`${pdfTitle}.pdf`)
            isExporting.value = false
        }
    }
    generatePDF()
}



// edit inventory
const edit_inventory_dialog = ref(false);
const edit_inventory_form = useForm({
    id: '',
    product_name: '',
    quantity: 0,
    price: 0.00,
    low: 0,
    status: '',
    category: '',
});

const handle_edit_inventory = (id) => {
    const inventory = page.props.inventories.find(inv => inv.id === id);
    if (inventory) {
        edit_inventory_form.id = inventory.id;
        edit_inventory_form.product_name = inventory.product_name;
        edit_inventory_form.quantity = inventory.quantity;
        edit_inventory_form.price = inventory.price;
        edit_inventory_form.low = inventory.low;
        edit_inventory_form.status = inventory.status;
        edit_inventory_form.category = inventory.category;
        edit_inventory_dialog.value = true; // Open dialog
    }
};

const update_inventory = () => {
    // console.log(edit_inventory_form)
    edit_inventory_form.put(route('integrated_inventory.update', edit_inventory_form.id), {
        onSuccess: () => {
            edit_inventory_form.reset()
            edit_inventory_dialog.value = false // Close dialog
        },
    });
};

// filtering
const filter = ref({
  campus: '',
  status: 'Available',
  unit: ''
})
// end of filtering

// import existing iges
const import_enterprises_dialog = ref(false);
const is_importing = ref(false);
const import_progress = ref(0);

const import_enterprise_form = useForm({
    campus_id: page.props.auth.user.campus.id
})

const handle_import_enterprises = () => {

    // Trigger backend route (Laravel: route('inventory.import'))
    import_enterprise_form.post(route("inventory.import"), {
        onSuccess: () => {
            import_enterprises_dialog.value = false;
        },
    });

    // console.log(import_enterprise_form)
};

const handle_redirect = () => {
    router.get(route('enterprises.display'));
};
// end import existing iges

useFlashWatcher("integrated_inventory.display")
</script>

<template>
    <Head title="Product Inventory" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Product Inventory</h2>
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
                                        mdi-package
                                    </v-icon>
                                    <span
                                        :class="$vuetify.display.smAndDown ? 'text-lg font-weight-semibold' : 'text-2xl font-weight-semibold'"
                                    >
                                        Product Inventory
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
                                    text="Add Product"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="dialog = true"
                                ></v-btn>

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
                                    @click="add_new_dialog = true"
                                >
                                    <v-icon size="18" class="font-weight-bold">mdi-plus</v-icon>
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

                                    class="mt-4"
                                >
                                    <FilterWrapper>
                                        <SelectInput v-if="$page.props.auth.user.role != 'User'" class="max-w-sm min-w-[200px]" v-model="filter.campus">
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
                                            <option value="Paid">
                                                Paid
                                            </option>
                                            <option value="Unpaid">
                                                Unpaid
                                            </option>
                                            <option value="Cancelled">
                                                Cancelled
                                            </option>
                                        </SelectInput>
                                    </FilterWrapper>
                                </div>
                            </div>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['product_name']" :headers="header"
                                :items="$page.props.inventories" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <!-- <template v-slot:item.image="{ item }">
                                    <div class="my-2">
                                        <v-img
                                            :src="`/storage/uploads/products/${item.image}`"
                                            height="100" width="100"
                                            cover
                                        ></v-img>
                                    </div>
                                </template> -->

                                <template v-slot:item.product_name="{item}">
                                    <div>{{ item.product_name }}</div>
                                </template>

                                <template v-slot:item.campus="{item}">
                                    <div>{{ item.campus.name }}</div>
                                </template>

                                <template v-slot:item.quantity="{item}">
                                    <div>
                                        {{ item.quantity }}
                                        <v-chip label v-if="item.quantity <= 10" color="orange-darken-4" size="small" class="ms-2">Low stock!</v-chip>
                                    </div>
                                </template>

                                <template v-slot:item.status="{item}">
                                    <v-chip size="small" class="ma-2" :color="item.status == 'Available' ? 'green-darken-3' : 'red-darken-4'" label>{{ item.status }}</v-chip>
                                </template>

                                <template v-slot:item.category="{item}">
                                    <div>{{ item.category }}</div>
                                </template>

                                <template v-slot:item.last_modified="{ item }">
                                    <td style="width: fit-content; white-space: nowrap;" class="text-start pa-4">
                                        <p class="text-xs font-bold text-uppercase text-gray-500">Last Modified</p>
                                        <p class="my-1">{{ item.date }}</p>
                                        <p class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600">{{ item.updated_by }}</p>
                                    </td>
                                </template>

                                <template v-slot:item.sales="{item}">
                                    <div>
                                        <Link :href="route('inventory.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View Sales</Link>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">
                                    <div class="text-end">
                                        <!-- <v-btn variant="flat" color="warning" class="mr-2 text-none" prepend-icon="mdi-pencil">Edit</v-btn>
                                        <v-btn variant="flat" color="error" class="mr-2 text-none" prepend-icon="mdi-delete" @click="deleteProduct">Delete</v-btn> -->
                                        <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small" @click="edit_enterprise(item.number-1)"></v-btn>
                                        <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                                        <div class="text-end d-flex justify-end align-center gap-1">
                                            <ActionButton @click="handle_edit_inventory(item.id)" :variant="'flat'" :color="'warning'" :text="'Edit'" prepend-icon="mdi-pencil" />
                                            <!-- <ActionButton @click="handle_delete_inventory(item.id)" :variant="'flat'" :color="'error'" :text="'Delete'" prepend-icon="mdi-delete" /> -->
                                        </div>
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>

                    <div>
                        <!-- import dialog  -->
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
                                                <div v-if="$page.props.auth.user.role == 'Admin'">
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

                        <!-- add or import product to button creating new product-->
                        <v-dialog v-model="add_new_dialog" persistent max-width="600">
                            <v-card prepend-icon="mdi-cash-multiple" title="Import or Add New" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="submit">
                                            <div class="mb-4">
                                                <label for="enterprise_id" class="block mb-2 text-sm font-medium text-gray-900">Import or Add Enterprise <span class="text-red-500">*</span></label>
                                                <select id="enterprise_id" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_new_form.enterprise_id">
                                                    <option disabled value="">-- Select to import --</option>
                                                    <option v-for="item in $page.props.enterprises" :key="item.id" :value="item.id">{{ item.enterprise }}</option>
                                                    <option :value="0">Others</option>
                                                </select>
                                                <InputError class="mt-2" :message="add_new_form.errors.enterprise_id" />
                                            </div>

                                            <div class="mb-4" v-if="add_new_form.enterprise_id === 0">
                                                <div class="mb-4">
                                                    <label for="enterprise_name" class="block mb-2 text-sm font-medium text-gray-900">Business Enterprise <span class="text-red-500">*</span></label>
                                                    <input type="text" id="enterprise_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter business enterprise." v-model="add_new_form.enterprise_name"/>

                                                    <InputError class="mt-2" :message="add_new_form.errors.enterprise_name" />
                                                </div>

                                                <div class="mb-4">
                                                    <label for="enterprise_category" class="block mb-2 text-sm font-medium text-gray-900">Category <span class="text-red-500">*</span></label>
                                                    <select id="enterprise_category" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_new_form.enterprise_category">
                                                        <option disabled selected value="">-- Select category --</option>
                                                        <option value="Agri-based">Agri-based</option>
                                                        <option value="Non agri-based">Non agri-based</option>
                                                    </select>
                                                    <InputError class="mt-2" :message="add_new_form.errors.enterprise_category" />
                                                </div>
                                            </div>
                                            <div>
                                                <div class="mb-4">
                                                    <v-row>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="price" class="block mb-2 text-sm font-medium text-gray-900">Price <span class="text-red-500">*</span></label>
                                                                <input type="number" id="price" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter price." v-model="add_new_form.price"/>

                                                                <InputError class="mt-2" :message="add_new_form.errors.price" />
                                                            </div>
                                                        </v-col>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="quantity" class="block mb-2 text-sm font-medium text-gray-900">Quantity <span class="text-red-500">*</span></label>
                                                                <input type="number" id="quantity" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter quantity." v-model="add_new_form.quantity"/>

                                                                <InputError class="mt-2" :message="add_new_form.errors.quantity" />
                                                            </div>
                                                        </v-col>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="unit" class="block mb-2 text-sm font-medium text-gray-900">Unit <span class="text-red-500">*</span></label>
                                                                <select id="unit" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_new_form.unit">
                                                                    <option disabled selected value="">-- Select unit --</option>
                                                                    <option value="pc">pc/s (piece/pieces)</option>
                                                                    <option value="kg">kg (kilogram)</option>
                                                                    <option value="m">m (meter)</option>
                                                                    <option value="l">l (liter)</option>
                                                                </select>
                                                                <InputError class="mt-2" :message="add_new_form.errors.unit" />
                                                            </div>
                                                        </v-col>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="unit" class="block mb-2 text-sm font-medium text-gray-900">Low Product <span class="text-red-500">*</span></label>
                                                                <input type="number" id="low" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter quantity." v-model="add_new_form.quantity"/>
                                                                <InputError class="mt-2" :message="add_new_form.errors.unit" />
                                                            </div>
                                                        </v-col>
                                                    </v-row>
                                                </div>
                                            </div>
                                            <v-divider class="my-4"></v-divider>
                                            <div class="text-end">
                                                <v-btn
                                                    text="Close"
                                                    variant="plain"
                                                    @click="add_new_dialog = false"
                                                ></v-btn>

                                                <v-btn
                                                    color="primary"
                                                    text="Save"
                                                    variant="tonal"
                                                    type="submit"
                                                    :class="{ 'opacity-25': add_new_form.processing }"
                                                    :disabled="add_new_form.processing"
                                                ></v-btn>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>

                        <!-- add or import product  -->
                        <v-dialog v-model="edit_inventory_dialog" persistent max-width="600">
                            <v-card prepend-icon="mdi-pencil" title="Edit Inventory" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="update_inventory">
                                            <div class="mb-4">
                                                <InputLabel for="enterprise" value="Enterprise" required="true"/>
                                                <TextInput id="product_name" type="text" class="w-full" v-model="edit_inventory_form.product_name" disabled/>
                                            </div>

                                            <div class="mb-4">
                                                <InputLabel for="price" value="Price" required="true"/>
                                                <TextInput id="price" type="text" class="w-full" v-model="edit_inventory_form.price"/>
                                                <InputError class="mt-2" :message="edit_inventory_form.errors.price" />
                                            </div>

                                            <div class="mb-4 d-flex justify-between align-center gap-4">
                                                <div class="w-full">
                                                    <InputLabel for="quantity" value="Quantity" required="true"/>
                                                    <TextInput id="quantity" type="text" class="w-full" v-model="edit_inventory_form.quantity"/>
                                                    <InputError class="mt-2" :message="edit_inventory_form.errors.quantity" />
                                                </div>
                                                <div class="w-full">
                                                    <InputLabel for="low" value="Low" required="true"/>
                                                    <TextInput id="low" v-model="edit_inventory_form.low"/>
                                                </div>
                                            </div>
                                            <div class="w-full">
                                                    <InputLabel for="status" value="Status" required="true"/>
                                                    <SelectInput id="status" v-model="edit_inventory_form.status">
                                                        <option disabled value="">-- Select status --</option>
                                                        <option value="Available">Available</option>
                                                        <option value="Not Available">Not Available</option>
                                                    </SelectInput>
                                                    <InputError class="mt-2" :message="edit_inventory_form.errors.status" />
                                                </div>

                                                <div class="mb-4">
                                                    <label for="category" class="block mb-2 text-sm font-medium text-gray-900">Category <span class="text-red-500">*</span></label>
                                                    <select id="category" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="edit_inventory_form.category">
                                                        <option disabled selected value="">-- Select category --</option>
                                                        <option value="Agri-based">Agri-based</option>
                                                        <option value="Non Agri-based">Non Agri-based</option>
                                                    </select>
                                                    <InputError class="mt-2" :message="edit_inventory_form.errors.category" />
                                                </div>

                                            <!-- <div class="mb-4" v-if="add_new_form.enterprise_id === 0">
                                                <div class="mb-4">
                                                    <label for="enterprise_name" class="block mb-2 text-sm font-medium text-gray-900">Business Enterprise <span class="text-red-500">*</span></label>
                                                    <input type="text" id="enterprise_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter business enterprise." v-model="add_new_form.enterprise_name"/>

                                                    <InputError class="mt-2" :message="add_new_form.errors.enterprise_name" />
                                                </div>

                                                <div class="mb-4">
                                                    <label for="enterprise_category" class="block mb-2 text-sm font-medium text-gray-900">Category <span class="text-red-500">*</span></label>
                                                    <select id="enterprise_category" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_new_form.enterprise_category">
                                                        <option disabled selected value="">-- Select category --</option>
                                                        <option value="Agri-based">Agri-based</option>
                                                        <option value="Non agri-based">Non agri-based</option>
                                                    </select>
                                                    <InputError class="mt-2" :message="add_new_form.errors.enterprise_category" />
                                                </div>
                                            </div>
                                            <div>
                                                <div class="mb-4">
                                                    <v-row>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="price" class="block mb-2 text-sm font-medium text-gray-900">Price <span class="text-red-500">*</span></label>
                                                                <input type="number" id="price" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter price." v-model="add_new_form.price"/>

                                                                <InputError class="mt-2" :message="add_new_form.errors.price" />
                                                            </div>
                                                        </v-col>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="quantity" class="block mb-2 text-sm font-medium text-gray-900">Quantity <span class="text-red-500">*</span></label>
                                                                <input type="number" id="quantity" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter quantity." v-model="add_new_form.quantity"/>

                                                                <InputError class="mt-2" :message="add_new_form.errors.quantity" />
                                                            </div>
                                                        </v-col>
                                                        <v-col cols="12" :md="4" :lg="4">
                                                            <div>
                                                                <label for="unit" class="block mb-2 text-sm font-medium text-gray-900">Unit <span class="text-red-500">*</span></label>
                                                                <select id="unit" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="add_new_form.unit">
                                                                    <option disabled selected value="">-- Select unit --</option>
                                                                    <option value="pc">pc/s (piece/pieces)</option>
                                                                    <option value="kg">kg (kilogram)</option>
                                                                    <option value="m">m (meter)</option>
                                                                    <option value="l">l (liter)</option>
                                                                </select>
                                                                <InputError class="mt-2" :message="add_new_form.errors.unit" />
                                                            </div>
                                                        </v-col>
                                                    </v-row>
                                                </div>
                                            </div> -->
                                            <v-divider class="my-4"></v-divider>
                                            <div class="text-end">
                                                <v-btn
                                                    text="Close"
                                                    variant="plain"
                                                    @click="edit_inventory_dialog = false"
                                                ></v-btn>

                                                <v-btn
                                                    color="primary"
                                                    text="Save"
                                                    variant="tonal"
                                                    type="submit"
                                                    :class="{ 'opacity-25': edit_inventory_form.processing }"
                                                    :loading="edit_inventory_form.processing"
                                                ></v-btn>
                                            </div>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>

                        <v-dialog v-model="dialog" persistent max-width="800">
                            <v-card prepend-icon="mdi-package" title="Add Product" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="submitProduct">
                                            <!-- 1. Product image  -->
                                            <!-- <div class="mb-6">
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
                                                        <input id="image" type="file" class="hidden" @change="handleFileChange" accept="image/*"/>
                                                    </label>
                                                </div>
                                                <div v-if="previewUrl" class="d-flex">
                                                    <div @click="previewImageDialog = true" class="hover:cursor-pointer text-blue-500 italic mt-2 text-sm">View image preview</div>
                                                    <div @click="previewUrl = null" class="hover:cursor-pointer text-red-500 italic mt-2 text-sm ms-4">Remove image</div>
                                                </div>

                                                <v-dialog v-model="previewImageDialog" max-width="400">
                                                    <v-card>
                                                         Image preview
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
                                            </div> -->

                                            <!-- <div class="mb-2">
                                                <v-select
                                                    clearable
                                                    label="Product category"
                                                    :items="['Category 1', 'Category 2']"
                                                    multiple
                                                    variant="outlined"
                                                ></v-select>

                                            </div> -->

                                            <div class="mb-2">
                                                <v-text-field clearable label="Product name" variant="outlined" v-model = "add_product.product_name" class="focus:outline-none focus:ring-0"></v-text-field>
                                                <InputError class="mt-2" :message="add_product.product_name" />
                                            </div>

                                            <div class="mb-2">
                                                <v-row>
                                                    <v-col>
                                                        <v-number-input
                                                            :reverse="false"
                                                            controlVariant="default"
                                                            label="Product quantity"
                                                            v-model = "add_product.quantity"
                                                            :hideInput="false"
                                                            :inset="false"
                                                            variant="outlined"
                                                        ></v-number-input>
                                                        <InputError class="mt-2" :message="add_product.quantity" />
                                                    </v-col>
                                                    <v-col>
                                                        <v-number-input
                                                            :reverse="false"
                                                            controlVariant="default"
                                                            label="Product price"
                                                            v-model = "add_product.price"
                                                            :hideInput="false"
                                                            :inset="false"
                                                            variant="outlined"
                                                            precision="2"
                                                        ></v-number-input>
                                                        <InputError class="mt-2" :message="add_product.price" />
                                                    </v-col>
                                                    <v-col>
                                                        <v-number-input
                                                            :reverse="false"
                                                            controlVariant="default"
                                                            label="Low Product"
                                                            v-model = "add_product.low"
                                                            :hideInput="false"
                                                            :inset="false"
                                                            variant="outlined"
                                                            precision="3"
                                                        ></v-number-input>
                                                        <InputError class="mt-2" :message="add_product.low" />
                                                    </v-col>
                                                </v-row>
                                            </div>
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
                                                    type="submit"
                                                    :class="{ 'opacity-25': add_product.processing }"
                                                    :disabled="add_product.processing"
                                                ></v-btn>
                                            </v-card-actions>
                                        </form>
                                    </div>
                                </v-card-text>
                            </v-card>
                        </v-dialog>
                    </div>
                </div>


                <!-- pdf generation  -->
                <div>
                    <InventoryListPDF v-show="isExporting" ref="pdfSection" :current_user="current_user" :inventories="$page.props.inventories"></InventoryListPDF>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import Swal from 'sweetalert2';
import { ref } from 'vue';
import InventoryListPDF from '@/Components/PDFs/InventoryListPDF.vue';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import SearchBar from '@/Components/SearchBar.vue';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import SelectInput from '@/Components/SelectInput.vue';
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import ExportButton from '@/Components/ExportButton.vue';
import ActionButton from '@/Components/ActionButton.vue';
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
        header: [
            {
                title: '#',
                align: 'start',
                key: 'number',
                sortable: false,
            },
            {
                title: 'Product Name',
                align: 'start',
                key: 'product_name',
                sortable: false,
            },
            //{
            //    title: 'Image',
            //    align: 'start',
            //    key: 'image',
            //    sortable: true,
            //},
            {
                title: 'Campus',
                align: 'start',
                key: 'campus',
                sortable: true,
            },
            //{
            //    title: 'Enterprise',
            //    align: 'start',
            //    key: 'enterprise_name',
            //    sortable: true,
            //},
            {
                title: 'Quantity',
                align: 'center',
                key: 'quantity',
                sortable: true,
            },
            //{
            //    title: 'Unit',
            //    align: 'center',
            //    key: 'unit',
            //    sortable: true,
            //},
            {
                title: 'Price',
                align: 'center',
                key: 'price',
                sortable: true,
            },
            {
                title: 'Status',
                align: 'center',
                key: 'status',
                sortable: true,
            },
            {
                title: 'Category',
                align: 'start',
                key: 'category',
                sortable: true,
            },
            {
                title: 'Last Modified',
                align: 'start',
                key: 'last_modified',
                sortable: true,
            },
            {
                title: 'Sales',
                align: 'start',
                key: 'sales',
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
            image: 'product_placeholder.jpg',
            product: 'ID Lace',
            quantity: 500,
            price: 100,
            product_status: 'Available',
            last_modified: '2025-06-13 8:24 PM'
          },
          {
            number: 2,
            id: 2,
            image: 'product_placeholder.jpg',
            product: 'PE Uniform',
            quantity: 10,
            price: 350,
            product_status: 'Not Available',
            last_modified: '2025-06-13 8:24 PM'
          },
        ],

        breadcrumbs_items: [
            {
                title: 'Inventory',
                active: false
            },
            {
                title: 'Product Inventory',
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
