<template>
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
                            mdi-cash-multiple
                        </v-icon>
                        <span
                            :class="$vuetify.display.smAndDown ? 'text-lg font-weight-semibold' : 'text-2xl font-weight-semibold'"
                        >
                            Business Enterprises
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
                        @click="add_enterprise_dialog = true"
                    ></v-btn>

                    <!-- Icon-only button for small devices -->
                    <v-btn
                        v-else
                        class="ms-2"
                        icon
                        variant="flat"
                        color="green-darken-4"
                        @click="add_enterprise_dialog = true"
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
                            <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.category">
                                <option disabled>
                                    Filter by Category
                                </option>
                                <option value="" selected>
                                    All Categories
                                </option>
                                <option value="Agri-based">
                                    Agri-based Enterprises
                                </option>
                                <option value="Non agri-based">
                                    Non agri-based Enterprises
                                </option>
                            </SelectInput>
                            <SelectInput class="max-w-sm min-w-[200px]" v-model="filter.inventory">
                                <option disabled>
                                    Filter by Inventory
                                </option>
                                <option value="" selected>
                                    All
                                </option>
                                <option value="true">
                                    With inventory
                                </option>
                                <option value="false">
                                    Without inventory
                                </option>
                            </SelectInput>
                        </FilterWrapper>
                    </div>
                </div>

                <!-- <div class="mb-3">
                    <v-row dense>
                        <v-col cols="12" md="8" lg="8">
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
                        <v-col cols="12" md="4" lg="4" class="text-end">
                            <div>
                                 <v-btn
                                    class="ms-2 text-none tracking-normal"
                                    prepend-icon="mdi-printer"
                                    rounded="l"
                                    text="Print"
                                    variant="flat"
                                    color="grey-lighten-3"
                                    @click="generatePDF"
                                ></v-btn>
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
                                    @click="add_enterprise_dialog = true"
                                ></v-btn>
                            </div>
                        </v-col>
                    </v-row>
                </div> -->

                <v-divider class="border-opacity-75" :thickness="2"></v-divider>

                <v-data-table
                    :search="search"
                    :headers="header"
                    :items="filteredData" hover :loading="loading"
                >
                    <template v-slot:loading>
                        <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                    </template>

                    <template v-slot:item.number="{ index }">
                        <div class="text-start">{{ index + 1 }}</div>
                    </template>


                    <template v-slot:item.enterprise="{item}">
                        <div>
                            <Link href="#" class="hover:text-blue-500 hover:font-bold hover:underline">
                                {{ item.enterprise }}
                                <br>
                                <!-- <span class="text-small text-gray-500 hidden hover:block">View Record</span> -->
                            </Link>
                        </div>
                    </template>

                    <template v-slot:item.category="{item}">
                        <v-chip class="ma-2" :color="item.category == 'Agri-based' ? 'green-darken-3' : 'lime-darken-4'" label>
                            <v-icon :icon="item.category == 'Agri-based' ? 'mdi-sprout' : 'mdi-book-open-variant-outline'" start></v-icon>
                            {{ item.category }}
                        </v-chip>
                    </template>

                    <template v-slot:item.inventory="{item}">
                        <div class="flex justify-center">
                            <v-switch
                                v-model="item.inventory"
                                hide-details
                                inset disabled color="primary"
                            ></v-switch>
                        </div>
                    </template>

                    <template v-slot:item.added_by="{ item }">
                        <div class="text-start py-4">
                            <p
                                class="text-xs font-bold text-uppercase text-gray-500"
                            >
                                Added By
                            </p>
                            <p class="my-1">
                                {{ item.added_at }}
                            </p>
                            <p
                                class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600"
                            >
                                {{ item.added_by }}
                            </p>
                        </div>
                    </template>

                    <template v-slot:item.account_ledgers="{item}">
                        <div class="text-center">
                            <Link :href="route('enterprises.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View Ledgers</Link>
                        </div>
                    </template>

                    <template v-slot:item.actions="{ item }">
                        <div class="text-end d-flex justify-end align-center gap-1">
                            <ActionButton @click="handle_edit_enterprise(item.id)" :variant="'flat'" :color="'warning'" :text="'Edit'" prepend-icon="mdi-pencil"/>
                            <ActionButton :variant="'flat'" :color="'error'" :text="'Delete'" prepend-icon="mdi-delete"/>
                            <!-- <v-btn variant="tonal" color="info" class="mr-2" icon="mdi-eye" size="x-small"></v-btn> -->
                            <!-- <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small" @click="edit_enterprise(item.number-1)"></v-btn> -->
                            <!-- <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn> -->
                        </div>
                    </template>
                </v-data-table>
            </v-card>
        </div>

        <div>
            <!-- add business enterprise  -->
            <v-dialog v-model="add_enterprise_dialog" persistent max-width="600">
                <v-card prepend-icon="mdi-cash-multiple" title="Add Business Enterprise" class="pa-2">
                    <v-card-text>
                        <div>
                            <form @submit.prevent="submit">
                                <div v-if="$page.props.auth.user.role != 'User'" class="mb-4">
                                    <InputLabel for="campus" value="Campus" required="true"/>
                                    <SelectInput id="campus" class="mt-1 w-full" v-model="add_enterprise_form.campus_id">
                                        <option disabled value="">-- Select Campus --</option>
                                        <option v-for="campus in $page.props.campuses" :key="campus.id" :value="campus.id">
                                            {{ campus.campus }}
                                        </option>
                                    </SelectInput>
                                </div>
                                <div class="mb-4">
                                    <div>
                                        <InputLabel for="enterprise" value="Business Enterprise" required="true"/>
                                        <TextInput
                                            id="enterprise"
                                            type="text"
                                            class="mt-1 block w-full"
                                            v-model="add_enterprise_form.enterprise"
                                            autocomplete="enterprise"
                                            placeholder="Enter name of business enterprise."
                                        />
                                        <InputError class="mt-2" :message="add_enterprise_form.errors.enterprise" />
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <InputLabel for="category" value="Category" required="true"/>
                                    <SelectInput id="category" class="mt-1 w-full" v-model="add_enterprise_form.category">
                                        <option disabled value="">-- Select Category --</option>
                                        <option value="Agri-based">Agri-based</option>
                                        <option value="Non agri-based">Non agri-based</option>
                                    </SelectInput>
                                    <InputError class="mt-2" :message="add_enterprise_form.errors.category" />
                                </div>
                                <div class="mb-4">
                                    <InputLabel for="inventory" value="Inventory" required="true"/>
                                    <div class="flex align-center justify-between">
                                        <div>
                                            <p class="me-2 text-xs text-gray-500 italic border rounded-lg border-yellow-500 p-2">Does this enterprise have merchandise that needs to be inventoried? <br /> <br /> Enabling this option will automatically import the business enterprise into the <strong>Inventory</strong> section.</p>
                                        </div>
                                        <v-switch v-model="add_enterprise_form.inventory" hide-details inset color="primary"></v-switch>
                                    </div>
                                    <InputError class="mt-2" :message="add_enterprise_form.errors.inventory" />
                                </div>
                                <v-divider class="my-4"></v-divider>
                                <div class="text-end">
                                    <v-btn
                                        text="Close"
                                        variant="plain"
                                        @click="add_enterprise_dialog = false"
                                    ></v-btn>

                                    <v-btn
                                        color="primary"
                                        text="Save"
                                        variant="tonal"
                                        type="submit"
                                        :class="{ 'opacity-25': add_enterprise_form.processing }"
                                        :loading="add_enterprise_form.processing"
                                    ></v-btn>
                                </div>
                            </form>
                        </div>
                    </v-card-text>
                </v-card>
            </v-dialog>

            <!-- edit business enterprise  -->
             <v-dialog v-model="edit_enterprise_dialog" persistent max-width="600">
                <v-card prepend-icon="mdi-cash-multiple" title="Edit Business Enterprise" class="pa-2">
                    <v-card-text>
                        <div>
                            <form @submit.prevent="update(edit_enterprise_form.enterprise_id)">
                                <div v-if="$page.props.auth.user.role != 'User'" class="mb-4">
                                    <InputLabel for="campus" value="Campus" required="true"/>
                                    <SelectInput id="campus" class="mt-1 w-full" v-model="edit_enterprise_form.campus_id">
                                        <option disabled value="">-- Change Campus --</option>
                                        <option v-for="campus in $page.props.campuses" :key="campus.id" :value="campus.id">
                                            {{ campus.campus }}
                                        </option>
                                    </SelectInput>
                                </div>
                                <div class="mb-4">
                                    <div>
                                        <label for="enterprise" class="block mb-2 text-sm font-medium text-gray-900">Business Enterprise <span class="text-red-500">*</span></label>
                                        <input type="text" id="enterprise" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" placeholder="Enter business enterprise." v-model="edit_enterprise_form.enterprise"/>

                                        <InputError class="mt-2" :message="edit_enterprise_form.errors.enterprise" />
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="countries" class="block mb-2 text-sm font-medium text-gray-900">Category <span class="text-red-500">*</span></label>
                                    <select id="countries" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500 focus:border-emerald-500 block w-full p-2.5" v-model="edit_enterprise_form.category">
                                        <option disabled value="">-- Select Category --</option>
                                        <option value="Agri-based">Agri-based</option>
                                        <option value="Non agri-based">Non agri-based</option>
                                    </select>
                                    <InputError class="mt-2" :message="edit_enterprise_form.errors.category" />
                                </div>
                                <div class="mb-4">
                                    <InputLabel for="inventory" value="Inventory" required="true"/>
                                    <div class="flex align-center justify-between">
                                        <div>
                                            <p class="me-2 text-xs text-gray-500 italic border rounded-lg border-yellow-500 p-2">Does this enterprise have merchandise that needs to be inventoried? <br /> <br /> Enabling this option will automatically import the business enterprise into the <strong>Inventory</strong> section.</p>
                                        </div>
                                        <v-switch v-model="edit_enterprise_form.inventory" hide-details inset color="primary"></v-switch>
                                    </div>
                                    <InputError class="mt-2" :message="edit_enterprise_form.errors.inventory" />
                                </div>
                                <v-divider class="my-4"></v-divider>
                                <div class="text-end">
                                    <v-btn
                                        text="Close"
                                        variant="plain"
                                        @click="edit_enterprise_dialog = false"
                                    ></v-btn>

                                    <v-btn
                                        color="primary"
                                        text="Save Changes"
                                        variant="tonal"
                                        type="submit"
                                        :class="{ 'opacity-25': edit_enterprise_form.processing }"
                                        :disabled="edit_enterprise_form.processing"
                                    ></v-btn>
                                </div>
                            </form>
                        </div>
                    </v-card-text>
                </v-card>
            </v-dialog>
        </div>


        <div >
            <!-- pdf reports here  -->
             <!-- <PDFLayout v-show="isExporting" ref="pdfSection" :current_user="current_user" :headers="pdf_headers" title="List of Enterprises">
                <tr v-for="(item, index) in filteredData" :key="index">
                    <td class="px-6 pb-3 whitespace-nowrap text-sm font-medium text-gray-900">{{ index + 1 }}.</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.campus_name }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.enterprise }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.category }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.added_by }} | {{ item.added_at }}</td>
                </tr>
             </PDFLayout> -->
             <!-- <EnterpriseListPDF v-show="isExporting" ref="pdfSection" :current_user="current_user" :category="sort_category" :enterprises="sort_category == 'all' ? $page.props.all_enterprises : sort_category == 'abe' ? $page.props.agri_based : $page.props.non_agri_based"/> -->
        </div>
    </div>
</template>

<script setup>
import InputError from '@/Components/InputError.vue';
import EnterpriseListPDF from '@/Components/PDFs/EnterpriseListPDF.vue';
import { Link, useForm, usePage } from '@inertiajs/vue3'
import Swal from 'sweetalert2';
import { nextTick, ref, watch, computed } from 'vue';
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'
import InputLabel from '@/Components/InputLabel.vue';
import TextInput from '@/Components/TextInput.vue';
import SelectInput from '@/Components/SelectInput.vue';
import ActionButton from '@/Components/ActionButton.vue';
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import FilterWrapper from '@/Components/FilterWrapper.vue';
import { generatePDF } from '@/Utils/PDFGenerator';
import ExportSearchWrapper from '@/Components/ExportSearchWrapper.vue';
import ExportButton from '@/Components/ExportButton.vue';
import SearchBar from '@/Components/SearchBar.vue';
import PDFLayout from '@/Components/PDFs/PDFLayout.vue';

const page = usePage();

const search = ref('');
// const isExporting = ref(false)
const add_enterprise_dialog = ref(false)
const edit_enterprise_dialog = ref(false)
// const pdfSection = ref(null)

const props = defineProps({
    enterprises: {
        type: Array,
        required: true,
    },
    sort_category: {
        type: String,
        required: true
    }
})

const add_enterprise_form = useForm({
    campus_id: page.props.auth.user.campus.id,
    enterprise: '',
    category: 'Non agri-based',
    inventory: false
})

const edit_enterprise_form = useForm({
    enterprise_id: '',
    campus_id: '',
    enterprise: '',
    category: '',
    inventory: false
})

const handle_edit_enterprise = (enterprise_id) => {
    const enterprise = page.props.all_enterprises.find(
        (e) => e.id === enterprise_id
    )

    edit_enterprise_form.enterprise_id = enterprise.id
    edit_enterprise_form.campus_id = enterprise.campus_id
    edit_enterprise_form.enterprise = enterprise.enterprise
    edit_enterprise_form.category = enterprise.category
    edit_enterprise_form.inventory = enterprise.inventory

    edit_enterprise_dialog.value = true;
    // console.log(edit_enterprise_form)
}

function edit_enterprise(index) {
    const enterprise = (() => {
        switch (props.sort_category) {
            case 'abe':
                console.log(props.sort_category + ' clicked' + index)
                return page.props.agri_based[index];
            case 'nabe':
                console.log(props.sort_category + ' clicked' + index)
                return page.props.non_agri_based[index];
            default:
                console.log(props.sort_category + ' clicked' + index)
                return page.props.all_enterprises[index];
        }
    })();
    if (!enterprise) return

    console.log(enterprise)

    edit_enterprise_form.enterprise_id = enterprise.id

    edit_enterprise_form.enterprise = enterprise.enterprise
    edit_enterprise_form.category = enterprise.category

    edit_enterprise_dialog.value = true;
}

const submit = () => {
    // console.log(add_user_form.data());
    add_enterprise_form.post(route('enterprises.store'), {
        onSuccess: () => {
            add_enterprise_form.reset()
            add_enterprise_dialog.value = false // Close dialog
        },
    });
};

const update = (id) => {
    // console.log(add_user_form.data());
    edit_enterprise_form.put(route('enterprises.update', id), {
        onSuccess: () => {
            edit_enterprise_form.reset()
            edit_enterprise_dialog.value = false // Close dialog
        },
    });
};

// const current_user = {
//     name: page.props.auth.user.first_name + " " + page.props.auth.user.last_name,
//     campus: page.props.auth.user.campus.campus
// }

// const formatPrintedDate = () => {
//   const now = new Date()
//   const year = now.getFullYear()
//   const month = String(now.getMonth() + 1).padStart(2, '0')
//   const day = String(now.getDate()).padStart(2, '0')

//   let hours = now.getHours()
//   const minutes = String(now.getMinutes()).padStart(2, '0')
//   const ampm = hours >= 12 ? 'PM' : 'AM'
//   hours = hours % 12 || 12 // convert 0 to 12

//   return `${year}-${month}-${day} at ${hours}:${minutes} ${ampm}`
// }

// const generatePdfTitle = () => {
//   const now = new Date()
//   const year = now.getFullYear()
//   const month = String(now.getMonth() + 1).padStart(2, '0')
//   const day = String(now.getDate()).padStart(2, '0')
//   const reportTitle = 'EnterpriseReport'
//   const randomId = Math.random().toString(36).substring(2, 8).toUpperCase()

//   return `${year}-${month}-${day}_${reportTitle}_${randomId}`
// }

// const generatePDF = async () => {
//   isExporting.value = true
//   await nextTick() // Ensure content is rendered

//   const doc = new jsPDF('p', 'mm', 'a4')
//   const pdfTitle = generatePdfTitle()
//   const pageWidth = doc.internal.pageSize.getWidth()
//   const pageHeight = doc.internal.pageSize.getHeight()

//   doc.setProperties({ title: pdfTitle })

//   const logo = new Image()
//   logo.src = '/storage/isu_seal.png' // Make sure this exists in public folder

//   logo.onload = async () => {
//     const canvas = await html2canvas(pdfSection.value.$el, { scale: 2 })
//     const imgData = canvas.toDataURL('image/png')

//     const contentHeight = (canvas.height * 210) / canvas.width
//     const totalPages = Math.ceil(contentHeight / pageHeight)

//     for (let i = 0; i < totalPages; i++) {
//       if (i !== 0) doc.addPage()

//       // === HEADER ===
//       doc.addImage(logo, 'PNG', 15, 10, 18, 18)
//       doc.setFontSize(11)
//       doc.setTextColor(0)
//       doc.text('Republic of the Philippines', 40, 15)
//       doc.setFontSize(13)
//       doc.setFont('helvetica', 'bold')
//       doc.text('ISABELA STATE UNIVERSITY', 40, 20)
//       doc.setFontSize(11)
//       doc.setFont('helvetica', 'normal')
//       doc.text(current_user.campus + ', Isabela', 40, 25)
//       doc.setLineWidth(0.1)
//       doc.line(10, 30, pageWidth - 10, 30)

//       // === CONTENT ===
//       doc.addImage(
//         imgData,
//         'PNG',
//         10,
//         35,
//         190,
//         0,
//         '',
//         'FAST',
//         0,
//         i * pageHeight * (canvas.width / 210)
//       )

//       // === FOOTER ===
//     doc.setFillColor(255, 255, 255)
//     doc.rect(0, pageHeight - 20, pageWidth, 20, 'F')

//     // === Left: Page number ===
//     const pageText = `Page ${i + 1} of ${totalPages}`
//     doc.setFontSize(10)
//     doc.setTextColor(0)
//     doc.text(pageText, 10, pageHeight - 10) // left aligned

//     // === Right: Printed by and Date ===
//     const printedBy = `Printed by: ${current_user.name}`.toUpperCase()
//     const printedDate = formatPrintedDate().toUpperCase()

//     // Printed by
//     doc.setFontSize(8)
//     doc.setTextColor(0) // black
//     const printedByWidth = doc.getTextWidth(printedBy)
//     doc.text(printedBy, pageWidth - printedByWidth - 10, pageHeight - 10)

//     // Printed date (lighter gray)
//     doc.setTextColor(160, 160, 160) // lighter gray
//     const printedDateWidth = doc.getTextWidth(printedDate)
//     doc.text(printedDate, pageWidth - printedDateWidth - 10, pageHeight - 6)


//     }

//     // doc.save('isu-enterprise-report.pdf')

//     // === STREAM the PDF ===
//     doc.output('dataurlnewwindow') // Stream view in new tab
//     isExporting.value = false
//   }
// }


// filtering

// pdf section
const current_user = {
  name: `${page.props.auth.user.first_name} ${page.props.auth.user.last_name}`,
  campus: page.props.auth.user.campus.campus,
  role: page.props.auth.user.role
};

const pdfSection = ref(null);
const isExporting = ref(false);
const pdf_headers = ['#', 'Campus', 'Enterprise', 'Enterprise Category', 'Added/Submitted By']

const export_pdf_report = () => {
  generatePDF({
    reportTitle: "List of Enterprises",
    isExporting,
    currentUser: current_user,
    headers: pdf_headers,
    orientation: 'l',
    rows: filteredData.value.map((item, index) => [
      index + 1,
      item.campus_name,
      item.enterprise,
      item.category,
      `${item.added_by} | ${item.added_at}`,
    ]),
  });
};

// const export_pdf_report = () => {
//   generatePDF({
//     pdfSection,
//     reportTitle: "List of Enterprises",
//     isExporting,
//     currentUser: current_user,
//     orientation: "l", // Landscape mode
//     width_size: 277 // l - 277 | p - 190
//   });
// };
// end of pdf section

const filter = ref({
  campus: '',
  inventory: '',
  category: ''
})

const enterprises_list = ref(page.props.all_enterprises)

const filteredData = computed(() => {
  return enterprises_list.value.filter((enterprise) => {
    // campus filter
    const campusMatch =
      !filter.value.campus ||
      enterprise.campus_id === parseInt(filter.value.campus)

    // category filter
    const categoryMatch = !filter.value.category || enterprise.category === filter.value.category

    // inventory filter (ensure boolean comparison)
    let inventoryMatch = true
    if (filter.value.inventory !== '') {
      const inventoryBool = filter.value.inventory === 'true' || filter.value.inventory === true
      inventoryMatch = enterprise.inventory === inventoryBool
    }

    // must match both filters
    return campusMatch && categoryMatch && inventoryMatch
  })
})
// end of filtering

// watch(
//   () => page.props.flash,
//   (flash) => {
//     if (flash?.success) {
//       Swal.fire({
//         icon: 'success',
//         title: 'Success',
//         text: flash.success,
//         confirmButtonColor: '#3085d6'
//       })
//     } else if (flash?.error) {
//       Swal.fire({
//         icon: 'error',
//         title: 'Error',
//         text: flash.error,
//         confirmButtonColor: '#d33'
//       })
//     }
//   },
//   { immediate: true }
// )

useFlashWatcher("enterprises.display");

</script>

<script>
export default {
    data(){
        return {
            search: '',
            loading: false,
            header: [
                {
                    title: '#',
                    align: 'start',
                    key: 'number',
                    sortable: false,
                },
                {
                    title: 'Business Enterprise',
                    align: 'start',
                    key: 'enterprise',
                    sortable: true,
                },
                {
                    title: 'Campus',
                    align: 'start',
                    key: 'campus_name',
                    sortable: true,
                },
                {
                    title: 'Category',
                    align: 'center',
                    key: 'category',
                    sortable: true,
                },
                {
                    title: 'Inventory',
                    align: 'center',
                    key: 'inventory',
                    sortable: false,
                },
                {
                    title: 'Added By',
                    align: 'start',
                    key: 'added_by',
                    sortable: false,
                },
                {
                    title: 'Account Ledgers',
                    align: 'center',
                    key: 'account_ledgers',
                    sortable: true,
                },
                {
                    title: 'Actions',
                    align: 'end',
                    key: 'actions',
                    sortable: false,
                },
            ]
        }
    },
    methods: {
        onClick() {
            this.loading = true
            setTimeout(() => {
                this.loading = false
            }, 1000)
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