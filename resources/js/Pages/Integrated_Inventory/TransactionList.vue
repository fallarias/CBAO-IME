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
import { computed } from 'vue';
const page = usePage()

const current_user = {
    name: page.props.auth.user.first_name + " " + page.props.auth.user.last_name,
    campus: page.props.auth.user.campus.campus,
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
    campus: '',
    product_id: '',
    quantity: 0,
})

const filteredProducts = computed(() => {
    const campusId = Number(add_product.campus)
    const products = page.props.products ?? []

    if (!campusId) {
        return products
    }

    return products.filter(product => product.campus_id === campusId)
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

//UPDATE ACTION
const changeStatus = (item, newStatus) => {
    Swal.fire({
        title: "Are you sure?",
        text: "This will update the status.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, confirm",
        cancelButtonText: "No, cancel",
    }).then((result) => {
        if (result.isConfirmed) {
            router.put('/integrated/inventory/transaction/status', {
                id: item.id,
                status: newStatus
            });
        }
    });
};

page.props.transaction = page.props.transaction.map(item => ({
  ...item,
  status: item.status ?? ""
}));

const submitProduct = () => {
    //console.log(add_product.data());
    add_product.post(route('reservation.store'), {
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

useFlashWatcher("integrated_inventory.display_transaction")
</script>

<template>
    <Head title="Transaction List " />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">Transaction List</h2>
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
                                        Transaction List
                                    </span>
                                </div>

                                <!-- Right Section: Responsive Button -->
                                <div>
                                <!-- Full button for medium and up -->
                                <v-btn
                                    v-if="!$vuetify.display.smAndDown"
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-ticket"
                                    rounded="l"
                                    text="Reservation Form"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="dialog = true"
                                ></v-btn>

                                <!-- Full button for medium and up -->
                                <!-- <v-btn
                                    v-if="!$vuetify.display.smAndDown"
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-import"
                                    rounded="l"
                                    text="Import Enterprises"
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="import_enterprises_dialog = true"
                                ></v-btn> -->

                                <!-- Icon-only button for small devices -->
                                <!-- <v-btn
                                    v-else
                                    class="ms-2"
                                    icon
                                    variant="flat"
                                    color="green-darken-4"
                                    @click="add_new_dialog = true"
                                >
                                    <v-icon size="18" class="font-weight-bold">mdi-plus</v-icon>
                                </v-btn> -->
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
                                        <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.category">
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
                                        <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.unit">
                                            <option disabled>
                                                Filter by Unit
                                            </option>
                                            <option value="" selected>
                                                All Unit
                                            </option>
                                            <option value="pc">
                                                pc (piece/pieces)
                                            </option>
                                            <option value="kg">
                                                kg (kilo/kilogram)
                                            </option>
                                            <option value="m">
                                                m (meter/meters)
                                            </option>
                                            <option value="l">
                                                l (liter/liters)
                                            </option>
                                        </SelectInput>
                                    </FilterWrapper>
                                </div>
                            </div>

                            <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                            <v-data-table
                                v-model:search="search"
                                :filter-keys="['transaction_id']" :headers="header"
                                :items="$page.props.transaction" hover :loading="loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{item}">
                                    <div class="text-start">{{ item.number }}</div>
                                </template>

                                <template v-slot:item.product_name="{item}">
                                    <div>{{ item.product.product_name }}</div>
                                </template>

                                <template v-slot:item.reserve_quantity="{item}">
                                    <div>{{ item.reserve_quantity }}</div>
                                </template>

                                <template v-slot:item.price="{item}">
                                    <div>{{ item.product.price }}</div>
                                </template>

                                <template v-slot:item.campus="{item}">
                                    <div>
                                        {{ item.campus.name }}
                                        <!-- <v-chip label v-if="item.quantity <= 10" color="orange-darken-4" size="small" class="ms-2">Low stock!</v-chip> -->
                                    </div>
                                </template>

                                <template v-slot:item.date_purchase="{item}">
                                    <div>{{ item.purchase }}</div>
                                </template>

                                <template v-slot:item.id_number="{item}">
                                    <div>{{ item.id_number }}</div>
                                </template>

                                <template v-slot:item.order="{ item }">
                                    <div>{{ item.order }}</div>
                                </template>

                                <template v-slot:item.paid="{item}">
                                    <div>
                                        <span v-if="['unpaid', 'cancelled', ''].includes(item.order)">—</span>
                                        <span v-else>{{ item.paid }}</span>
                                    </div>
                                </template>

                                <template v-slot:item.action="{ item }">
                                    <div class="flex justify-center">
                                        <v-menu offset-y>
                                            <!-- Dropdown button -->
                                            <template #activator="{ props }">
                                                <v-btn color="success" v-bind="props" outlined>
                                                    Change Status
                                                </v-btn>
                                            </template>

                                            <!-- Dropdown options wrapped in v-list -->
                                            <v-list>
                                                <v-list-item @click="changeStatus(item, 'paid')">
                                                    <v-list-item-title>
                                                        Mark as Paid
                                                    </v-list-item-title>
                                                </v-list-item>

                                                <v-list-item @click="changeStatus(item, 'unpaid')">
                                                    <v-list-item-title>
                                                        Mark as Unpaid
                                                    </v-list-item-title>
                                                </v-list-item>

                                                <v-list-item @click="changeStatus(item, 'cancelled')">
                                                    <v-list-item-title>
                                                        Mark as Cancelled
                                                    </v-list-item-title>
                                                </v-list-item>
                                            </v-list>
                                        </v-menu>
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
                            <v-card prepend-icon="mdi-ticket" title="ReservationForm" class="pa-2">
                                <v-card-text>
                                    <div>
                                        <form @submit.prevent="submitProduct">

                                            <div class="flex gap-4">
                                                <!-- All Product and Stocks -->
                                                <div class="mb-2">
                                                    <v-table class="max-w-sm min-w-[300px] border rounded-lg">
                                                        <thead>
                                                        <tr>
                                                            <th class="text-left"></th>
                                                            <th class="text-center">Product Name</th>
                                                            <th class="text-center">Current Stocks</th>
                                                            <th class="text-left"></th>
                                                        </tr>
                                                        </thead>

                                                        <tbody>
                                                        <tr v-for="product in $page.props.reservation" :key="product.id">
                                                            <td>
                                                                <v-checkbox
                                                                    v-model="add_product.product_id"
                                                                    :value="product.id"
                                                                    hide-details
                                                                />
                                                            </td>

                                                            <td class="text-center">{{ product.product_name }}</td>
                                                            <td class="text-center">{{ product.quantity }}</td>
                                                            <td class="text-center">
                                                                <v-text-field
                                                                    v-if="add_product.product_id === product.id"
                                                                    v-model="add_product.quantity"
                                                                    type="number"
                                                                    density="compact"
                                                                    class="w-20"
                                                                    hide-details
                                                                ></v-text-field>
                                                            </td>
                                                        </tr>
                                                        </tbody>
                                                    </v-table>
                                                </div>


                                                <!-- All User -->
                                                <div class="mb-2">
                                                    <v-table class="max-w-sm min-w-[300px] border rounded-lg">
                                                        <thead>
                                                        <tr>
                                                            <th class="text-left"></th>
                                                            <th class="text-center">Name</th>
                                                            <th class="text-center">Designation</th>
                                                        </tr>
                                                        </thead>

                                                        <tbody>
                                                        <tr v-for="personnel in $page.props.personnels" :key="personnel.id">
                                                            <td>
                                                            <v-checkbox
                                                                v-model="add_product.campus"
                                                                :value="personnel.id"
                                                                hide-details
                                                            ></v-checkbox>
                                                            </td>

                                                            <td class="text-center">{{ personnel.first_name }} {{ personnel.last_name }}</td>
                                                            <td class="text-center">{{ personnel.designation }}</td>
                                                        </tr>
                                                        </tbody>
                                                    </v-table>
                                                </div>
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
                title: 'NAME ',
                align: 'start',
                key: 'name',
                sortable: true,
            },
            {
                title: 'PRODUCT NAME',
                align: 'start',
                key: 'product_name',
                sortable: false,
            },
            {
                title: 'RESERVE QUANTITY',
                align: 'start',
                key: 'quantity',
                sortable: true,
            },
            {
                title: 'PRODUCT PRICE',
                align: 'start',
                key: 'price',
                sortable: true,
            },
            {
                title: 'CAMPUS',
                align: 'center',
                key: 'campus',
                sortable: true,
            },
            {
                title: 'DATE & TIME PUCHASED',
                align: 'center',
                key: 'purchase',
                sortable: true,
            },
            {
                title: 'STUDENT NUMBER',
                align: 'center',
                key: 'id_number',
                sortable: true,
            },
            {
                title: 'ORDER STATUS',
                align: 'center',
                key: 'order',
                sortable: true,
            },
            {
                title: 'DATE & TIME PAID',
                align: 'center',
                key: 'paid',
                sortable: true,
            },
            {
                title: 'ACTION',
                align: 'center',
                key: 'action',
                sortable: false,
            },
            // {
            //     title: 'Sales',
            //     align: 'start',
            //     key: 'sales',
            //     sortable: false,
            // },
            // {
            //     title: 'Actions',
            //     align: 'end',
            //     key: 'actions',
            //     sortable: false,
            // },
        ],
        breadcrumbs_items: [
            {
                title: 'Inventory',
                active: false
            },
            {
                title: 'Transaction List',
                active: true
            },
        ],
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
