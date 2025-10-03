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
                    v-model:search="search"
                    :filter-keys="['name']" :headers="header"
                    :items="sort_category == 'all' ? $page.props.all_enterprises : sort_category == 'abe' ? $page.props.agri_based : $page.props.non_agri_based" hover :loading="loading"
                >
                    <template v-slot:loading>
                        <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
                    </template>

                    <template v-slot:item.number="{item}">
                        <div class="text-start">{{ item.number }}</div>
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

                    <template v-slot:item.account_ledgers="{item}">
                        <div class="text-center">
                            <Link :href="route('enterprises.view', 1)" class="text-blue-darken-3 hover:font-bold hover:underline">View Ledgers</Link>
                        </div>
                    </template>

                    <template v-slot:item.actions="{ item }">
                        <div class="text-end">
                            <!-- <v-btn variant="tonal" color="info" class="mr-2" icon="mdi-eye" size="x-small"></v-btn> -->
                            <v-btn variant="tonal" color="warning" class="mr-2"  icon="mdi-pencil" size="x-small" @click="edit_enterprise(item.number-1)"></v-btn>
                            <v-btn variant="tonal" color="error"  icon="mdi-delete" size="x-small"></v-btn>
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
                                <div v-if="$page.props.auth.user.role === 'Admin'" class="mb-4">
                                    <InputLabel for="campus" value="Campus" required="true"/>
                                    <SelectInput id="campus" class="mt-1 w-full">
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
                                        :disabled="add_enterprise_form.processing"
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
            <!-- enterprise list pdf  -->
             <EnterpriseListPDF v-show="isExporting" ref="pdfSection" :current_user="current_user" :category="sort_category" :enterprises="sort_category == 'all' ? $page.props.all_enterprises : sort_category == 'abe' ? $page.props.agri_based : $page.props.non_agri_based"/>
        </div>
    </div>
</template>

<script setup>
import InputError from '@/Components/InputError.vue';
import EnterpriseListPDF from '@/Components/PDFs/EnterpriseListPDF.vue';
import { Link, useForm, usePage } from '@inertiajs/vue3'
import Swal from 'sweetalert2';
import { nextTick, ref, watch } from 'vue';
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'
import InputLabel from '@/Components/InputLabel.vue';
import TextInput from '@/Components/TextInput.vue';
import SelectInput from '@/Components/SelectInput.vue';

const page = usePage();


const current_user = {
    name: page.props.auth.user.first_name + " " + page.props.auth.user.last_name,
    campus: page.props.auth.user.campus.campus
}

const isExporting = ref(false)
const add_enterprise_dialog = ref(false)
const edit_enterprise_dialog = ref(false)
const pdfSection = ref(null)

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
    enterprise: '',
    category: '',
})

const edit_enterprise_form = useForm({
    enterprise_id: '',
    enterprise: '',
    category: '',
})

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
  const reportTitle = 'EnterpriseReport'
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
    doc.output('dataurlnewwindow') // Stream view in new tab
    isExporting.value = false
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