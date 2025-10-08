<script setup>
import InputError from "@/Components/InputError.vue";
import EnterpriseListPDF from "@/Components/PDFs/EnterpriseListPDF.vue";
import { Link, useForm, usePage, Head, router } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { computed, ref, watch } from "vue";
import jsPDF from "jspdf";
import html2canvas from "html2canvas";
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import Breadcrumbs from "@/Components/Breadcrumbs.vue";
import { VPdfViewer } from "@vue-pdf-viewer/viewer";
import ExportSearchWrapper from "@/Components/ExportSearchWrapper.vue";
import ExportButton from "@/Components/ExportButton.vue";
import SearchBar from "@/Components/SearchBar.vue";
import FilterWrapper from "@/Components/FilterWrapper.vue";
import SelectInput from "@/Components/SelectInput.vue";
import InputLabel from "@/Components/InputLabel.vue";
import TextInput from "@/Components/TextInput.vue";
import FileDropInput from "@/Components/FileDropInput.vue";
import RemarkBubble from "@/Components/RemarkBubble.vue";
import ActionButton from "@/Components/ActionButton.vue";
import { generatePDF } from "@/Utils/PDFGenerator";
import PDFLayout from "@/Components/PDFs/PDFLayout.vue";
import ExcelLayout from "@/Components/Excels/ExcelLayout.vue";
import { exportExcel } from "@/Utils/ExcelGenerator";
import { useFlashWatcher } from "@/Utils/useFlashWatcher";

const page = usePage();

const search = ref('');
const remarks_bubble_dialog = ref(false);
const add_proposal_dialog = ref(false);
const table_loading = ref(false);
const view_project_file_dialog = ref(false);
const approve_proposal_dialog = ref(false);
const decline_proposal_dialog = ref(false);
const submit_new_proposal_dialog = ref(false);
const edit_proposal_dialog = ref(false);
const file_preview = ref(null);
const remarks_proposal_id = ref(null);
const remarks_list = ref(null); 

// pdf section
const current_user = {
  name: `${page.props.auth.user.first_name} ${page.props.auth.user.last_name}`,
  campus: page.props.auth.user.campus.campus,
  role: page.props.auth.user.role
};

const pdfSection = ref(null);
const isExporting = ref(false);
const pdf_headers = ['#', 'Campus', 'Project Title', 'Project Category', 'Proposal Status', 'Added/Submitted By', 'Evaluated By']

const export_pdf_report = () => {
  generatePDF({
    reportTitle: "List of Proposals",
    isExporting,
    currentUser: current_user,
    headers: pdf_headers,
    orientation: 'l',
    rows: filteredProposals.value.map((item, index) => [
      index + 1,
      item.campus,
      item.project_title,
      item.proposal_category,
      item.proposal_status,
      `${item.submitted_by.name} | ${item.submitted_by.datetime}`,
      `${item.evaluated_by?.name ? `${item.evaluated_by.name} | ${item.evaluated_by.datetime}` : "Under Review"}`
    ]),
  });
};

// const export_pdf_report = () => {
//   generatePDF({
//     pdfSection,
//     reportTitle: "List of Proposals",
//     isExporting,
//     currentUser: current_user,
//     orientation: "l", // Landscape mode
//     width_size: 277
//   });
// };
// end of pdf section

// excel section
// Excel headers
const excel_headers = [
  '#',
  'Campus',
  'Project Title',
  'Project Category',
  'Proposal Status',
  'Added/Submitted By',
  'Evaluated By'
];

// Export handler
const export_excel_report = () => {
  // Use .value because it's a computed ref
  const excelData = filteredProposals.value.map((p, index) => ({
    '#': p.number || index + 1,
    'Campus': p.campus || '-',
    'Project Title': p.project_title || '-',
    'Project Category': p.proposal_category || '-',
    'Proposal Status': p.proposal_status || '-',
    'Added/Submitted By': p.submitted_by
      ? `${p.submitted_by.name} | ${p.submitted_by.datetime}`
      : '-',
    'Evaluated By': p.evaluated_by.name
      ? `${p.evaluated_by.name || '-'} | ${p.evaluated_by.datetime || '-'}`
      : 'Under Review'
  }));

  exportExcel(excelData, excel_headers, "List_of_Proposals");
};
// end of excel section

const filter = ref({
  campus: '',
  status: ''
})

const handle_proposal_action = (proposal_id, action) => {
    proposal_action.proposal_id = proposal_id
    proposal_action.action = action

    if (action == 'Approved') {
        approve_proposal_dialog.value = true;
    } else {
        decline_proposal_dialog.value = true;
    }
}

// view remarks bubble dialog
const view_remarks_bubble_dialog = (id) => {
    remarks_proposal_id.value = id;
    
    // filter remarks for this proposal
    remarks_list.value = page.props.proposals.find(p => p.proposal_id === id)
        ? page.props.proposals.find(p => p.proposal_id === id).remarks
        : []

    remarks_bubble_dialog.value = true;
};

// Handle file select
const handle_proposal_file_change = (e) => {
    const file = e.target.files[0];
    if (file) {
        submit_new_proposal.proposal_file = file;
        file_preview.value = {
            name: file.name,
            size: (file.size / 1024 / 1024).toFixed(2) + " MB",
            progress: 0,
        };
    }
};

// Handle file select
const handle_edit_proposal_file_change = (e) => {
    const file = e.target.files[0];
    if (file) {
        edit_proposal_form.proposal_file = file;
        file_preview.value = {
            name: file.name,
            size: (file.size / 1024 / 1024).toFixed(2) + " MB",
            progress: 0,
        };
    }
};

const project_file_path = ref("");
const handle_view_project_file = (file_path, proposal_id) => {
    project_file_path.value = file_path;
    remarks_proposal_id.value = proposal_id;
    view_project_file_dialog.value = true;
};

const handle_edit_proposal = (proposal_id) => {
    const proposal = page.props.proposals.find(
        (p) => p.proposal_id === proposal_id
    )

    edit_proposal_form.proposal_id = proposal.proposal_id
    edit_proposal_form.campus_id = proposal.campus_id
    edit_proposal_form.proposal_title = proposal.project_title
    // edit_proposal_form.proposal_file = proposal.project_file.path
    edit_proposal_form.proposal_category = proposal.proposal_category

    edit_proposal_dialog.value = true
}

const submit_new_proposal = useForm({
    user_id: "",
    campus_id: "",
    proposal_title: "",
    proposal_file: "",
    proposal_category: "",
});

const edit_proposal_form = useForm({
    proposal_id: "",
    user_id: "",
    campus_id: "",
    proposal_title: "",
    proposal_file: "",
    proposal_category: "",
});

const add_proposal_remark = useForm({
    proposal_id: "",
    user_id: page.props.auth.user.id,
    remark: "",
});

const proposal_action = useForm({
    proposal_id: "",
    action: "",
});

const breadcrumbs_items = ref([
    {
        title: "Transaction",
        active: false,
    },
    {
        title: "Proposal",
        active: true,
    },
]);

const proposals_header = ref([
    {
        title: "#",
        align: "start",
        key: "number",
        sortable: false,
    },
    {
        title: "Project Title",
        align: "start",
        key: "project_title",
        sortable: true,
    },
    {
        title: "Project File",
        align: "start",
        key: "project_file",
        sortable: true,
    },
    {
        title: "Campus",
        align: "start",
        key: "campus",
        sortable: true,
    },
    {
        title: "Submitted By",
        align: "start",
        key: "submitted_by",
        sortable: false,
    },
    {
        title: "Proposal Status",
        align: "center",
        key: "proposal_status",
        sortable: false,
    },
    {
        title: "Proposal Remarks",
        align: "center",
        key: "proposal_remarks",
        sortable: false,
    },
    {
        title: "Evaluated By",
        align: "start",
        key: "evaluated_by",
        sortable: false,
    },
    {
        title: "Actions",
        align: "end",
        key: "actions",
        sortable: false,
    },
]);

const proposals = ref([
    {
        number: 1,
        project_title: "Smart Water System",
        project_file: "smart_water_system.pdf",
        campus: "Echague Campus",
        submitted_by: "Alice Johnson",
        proposal_status: "Pending",
        actions: "",
    },
    {
        number: 2,
        project_title: "Eco-Friendly Packaging",
        project_file: "eco_packaging.pdf",
        campus: "Ilagan Campus",
        submitted_by: "Bob Smith",
        proposal_status: "Pending",
        actions: "",
    },
    {
        number: 3,
        project_title: "AI Chatbot for Schools",
        project_file: "ai_chatbot_schools.pdf",
        campus: "Cauayan Campus",
        proposal_status: "Approved",
        submitted_by: "Carol Lee",
        actions: "",
    },
    {
        number: 4,
        project_title: "Blockchain Voting System",
        project_file: "blockchain_voting.pdf",
        campus: "San Mateo Campus",
        proposal_status: "Declined",
        submitted_by: "David Kim",
        actions: "",
    },
    {
        number: 5,
        project_title: "Solar Microgrid Design",
        project_file: "solar_microgrid.pdf",
        campus: "Echague Campus",
        submitted_by: "Eve Torres",
        proposal_status: "Pending",
        actions: "",
    },
]);

// add new proposal
const submit = () => {
    submit_new_proposal.post(route("proposal.store"), {
        forceFormData: true, // Ensure FormData is used for file uploads
        onProgress: (event) => {
            if (file_preview.value) {
                file_preview.value.progress = Math.round(
                    (event.loaded / event.total) * 100
                );
            }
        },
        onSuccess: () => {
            file_preview.value = null;
            submit_new_proposal.reset(); // Reset the form after successful submission
            submit_new_proposal_dialog.value = false;
        },
    });
};

// add new remark to the proposal
const submit_remark = () => {
    add_proposal_remark.proposal_id = remarks_proposal_id.value;
    
    add_proposal_remark.post(route("proposal.add_remark", add_proposal_remark.proposal_id), {
        onSuccess: () => {
            add_proposal_remark.reset(); // Reset the form after successful submission
            remarks_bubble_dialog.value = false;
        },
    });
};

// edit proposal
const edit_proposal = () => {
    // Ensure FormData is sent, even if no new file is uploaded
    // edit_proposal_form.transform((data) => {
    //     const formData = new FormData();

    //     formData.append('proposal_title', data.proposal_title);
    //     formData.append('proposal_category', data.proposal_category);

    //     // Only append proposal_file if user uploaded a new one
    //     if (data.proposal_file instanceof File) {
    //         formData.append('proposal_file', data.proposal_file);
    //     }

    //     return formData;
    // });

    console.log(edit_proposal_form.proposal_title)
    edit_proposal_form.post(route("proposal.update", edit_proposal_form.proposal_id), {
        forceFormData: true, // ensure FormData is used
        onProgress: (event) => {
            if (file_preview.value) {
                file_preview.value.progress = Math.round(
                    (event.loaded / event.total) * 100
                );
            }
        },
        onSuccess: () => {
            file_preview.value = null;
            edit_proposal_form.reset();
            edit_proposal_dialog.value = false;
        },
    });
};


// evaluate proposal (approve or decline)
const evaluate_proposal = () => {
    proposal_action.put(route("proposal.evaluate", proposal_action.proposal_id), {
        onSuccess: () => {

            proposal_action.reset(); // Reset the form after successful submission
            
            approve_proposal_dialog.value = false;
            decline_proposal_dialog.value = false;
        },
    });
}

const proposals_list = ref(page.props.proposals)

const filteredProposals = computed(() => {
  return proposals_list.value.filter((proposal) => {
    // ✅ Campus filter
    const campusMatch =
      !filter.value.campus ||
      proposal.campus_id === parseInt(filter.value.campus)

    // ✅ Status filter
    const statusMatch =
      !filter.value.status ||
      proposal.proposal_status === filter.value.status

    // ✅ Must match both filters
    return campusMatch && statusMatch
  })
})


// watch(
//   () => page.props.flash,
//   (flash) => {
//     if (flash?.success) {
//       Swal.fire({
//         icon: 'success',
//         title: 'Success',
//         text: flash.success,
//         confirmButtonColor: '#3085d6',
//         didOpen: () => {
//           const confirmBtn = Swal.getConfirmButton()
//           if (confirmBtn) confirmBtn.style.color = "white" // ✅ custom text color
//         }
//       })

//       router.get(route('proposal.display'))
//     } else if (flash?.error) {
//       Swal.fire({
//         icon: 'error',
//         title: 'Error',
//         text: flash.error,
//         confirmButtonColor: '#d33',
//         didOpen: () => {
//           const confirmBtn = Swal.getConfirmButton()
//           if (confirmBtn) confirmBtn.style.color = "white" // ✅ custom text color
//         }
//       })
//     }
//   },
//   { immediate: true }
// )

useFlashWatcher("proposal.display");
</script>

<template>
    <Head title="Proposals" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">
                Proposals
            </h2>
        </template>

        <div>
            <div class="mx-4 sm:px-6 lg:px-8">
                <div>
                    <Breadcrumbs :items="breadcrumbs_items" />
                </div>

                <div
                    class="overflow-hidden bg-white shadow-sm sm:rounded-lg border border-stone-200"
                >
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
                                        Project Proposals
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
                                        text="Submit New Proposal"
                                        variant="flat"
                                        color="green-darken-4"
                                        @click="
                                            submit_new_proposal_dialog = true
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
                                            submit_new_proposal_dialog = true
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

                            <div class="filter-sort-wrapper mb-4">
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
                            </div>

                            <v-divider
                                class="border-opacity-75"
                                :thickness="2"
                            ></v-divider>

                            <v-data-table
                                :search="search"
                                :headers="proposals_header"
                                :items="filteredProposals"
                                hover
                                :loading="table_loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader
                                        type="table-row@5"
                                    ></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{ item }">
                                    <div class="text-start">
                                        {{ item.number }}
                                    </div>
                                </template>

                                <template v-slot:item.project_file="{ item }">
                                    <div>
                                        <p
                                            class="hover:text-blue-500 hover:font-bold hover:underline hover:cursor-pointer text-blue-500 font-bold"
                                            @click="handle_view_project_file(item.project_file.path, item.proposal_id)"
                                        >
                                            View File
                                        </p>
                                    </div>
                                </template>

                                <template v-slot:item.submitted_by="{ item }">
                                    <div class="text-start py-4">
                                        <p
                                            class="text-xs font-bold text-uppercase text-gray-500"
                                        >
                                            Submitted By
                                        </p>
                                        <p class="my-1">
                                            {{ item.submitted_by.datetime }}
                                        </p>
                                        <p
                                            class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600"
                                        >
                                            {{ item.submitted_by.name }}
                                        </p>
                                    </div>
                                </template>

                                <template
                                    v-slot:item.proposal_status="{ item }"
                                >
                                    <div class="text-center">
                                        <v-chip
                                            class="ma-2"
                                            label
                                            :color="
                                                item.proposal_status ===
                                                'Pending'
                                                    ? 'amber-darken-4'
                                                    : item.proposal_status ===
                                                      'Approved'
                                                    ? 'green'
                                                    : item.proposal_status ===
                                                      'Declined'
                                                    ? 'red-darken-4'
                                                    : 'grey'
                                            "
                                        >
                                            {{ item.proposal_status }}
                                        </v-chip>
                                    </div>
                                </template>

                                <template v-slot:item.evaluated_by="{ item }">
                                    <div class="text-start py-4" v-if="item.evaluated_by.name != null && item.evaluated_by.datetime != null">
                                        <p
                                            class="text-xs font-bold text-uppercase text-gray-500"
                                        >
                                            Evaluated By
                                        </p>
                                        <p class="my-1">
                                            {{ item.evaluated_by.datetime }}
                                        </p>
                                        <p
                                            class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600"
                                        >
                                            {{ item.evaluated_by.name }}
                                        </p>
                                    </div>

                                    <div v-else class="text-start py-4 text-xs font-bold text-uppercase text-gray-500">
                                        Not yet evaluated (Under Review)
                                    </div>
                                </template>

                                <!-- view or add remarks button -->
                                <template
                                    v-slot:item.proposal_remarks="{ item }"
                                >
                                    <div class="text-center">
                                        <v-btn
                                            color="light-green-darken-4"
                                            rounded="0"
                                            variant="outlined"
                                            @click="view_remarks_bubble_dialog(item.proposal_id)" density="comfortable"
                                            class="me-2 text-xs"
                                            icon="mdi-comment-outline"
                                            
                                        >
                                        <!-- :icon="$page.props.auth.user.role == 'User' ? 'mdi-comment-outline' : 'mdi-comment-plus-outline'" -->
                                            <!-- <div v-if="$page.props.auth.user.role == 'User'">
                                                View Remarks
                                            </div>
                                            <div v-else>
                                                Add Remarks
                                            </div> -->
                                            <template v-if="$page.props.auth.user.role == 'User'" v-slot:append>
                                                <v-badge
                                                    :color="item.remarks.length > 0 ? 'error' : 'warning'"
                                                    :content="item.remarks.length"
                                                    inline
                                                ></v-badge>
                                            </template>

                                        </v-btn>
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">

                                    <!-- <div v-if="$page.props.auth.user.role == 'User'" class="float-end">
                                        <ActionButton @click="handle_edit_proposal(item.proposal_id)" :variant="'flat'" :color="'info'" :text="'Edit'" prepend-icon="mdi-file-edit-outline" :disabled="item.proposal_status != 'Pending'" />
                                    </div> -->

                                    <div class="text-end d-flex justify-end align-center gap-1">
                                        <ActionButton @click="handle_edit_proposal(item.proposal_id)" :variant="'flat'" :color="'info'" :text="'Edit'" prepend-icon="mdi-file-edit-outline" :disabled="item.proposal_status != 'Pending'" />
    
                                        <div v-if="$page.props.auth.user.role != 'User'" class="text-end d-flex justify-end align-center gap-1">
                                            <ActionButton @click="handle_proposal_action(item.proposal_id, 'Approved')" :variant="'flat'" :color="'success'" :text="'Approve'" prepend-icon="mdi-check" :disabled="item.proposal_status != 'Pending'" />
    
                                            <ActionButton @click="handle_proposal_action(item.proposal_id, 'Declined')" :variant="'flat'" :color="'error'" :text="'Decline'" prepend-icon="mdi-exclamation" :disabled="item.proposal_status != 'Pending'" />
                                        </div>
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>
                </div>
            </div>

            <div>
                <!-- submit new proposal  -->
                <div>
                    <v-dialog
                        v-model="submit_new_proposal_dialog"
                        persistent
                        max-width="600"
                    >
                        <v-card
                            prepend-icon="mdi-cash-multiple"
                            title="Submit Project Proposal"
                            class="pa-2"
                        >
                            <v-card-text>
                                <div>
                                    <form @submit.prevent="submit">
                                        <div v-if="$page.props.auth.user.role != 'User'" class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Campus"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <SelectInput v-model="submit_new_proposal.campus_id">
                                                    <option value="" disabled selected>
                                                        Select Campus
                                                    </option>
                                                    <option v-for="campus in $page.props.campuses" :key="campus.id" :value="campus.id">
                                                        {{ campus.campus }}
                                                    </option>
                                                </SelectInput>
                                                <InputError
                                                    class="mt-2"
                                                    :message="submit_new_proposal.errors.campus_id"
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Project Title"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <TextInput
                                                    v-model="
                                                        submit_new_proposal.proposal_title
                                                    "
                                                    class="w-full"
                                                    :placeholder="'Enter proposal title'"
                                                />
                                                <InputError
                                                    class="mt-2"
                                                    :message="
                                                        submit_new_proposal
                                                            .errors
                                                            .proposal_title
                                                    "
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Category"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <SelectInput v-model="submit_new_proposal.proposal_category">
                                                    <option
                                                        value=""
                                                        disabled
                                                        selected
                                                    >
                                                        Select Category
                                                    </option>
                                                    <option value="Agri-based">Agri-based</option>
                                                    <option value="Non agri-based">Non agri-based</option>
                                                </SelectInput>
                                                <InputError
                                                    class="mt-2"
                                                    :message="submit_new_proposal.errors.proposal_category"
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4">
                                            <div>
                                                <InputLabel
                                                    value="Project File (PDF only)"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <FileDropInput
                                                    class="w-full"
                                                    file_limitation="application/pdf"
                                                    @change="handle_proposal_file_change"
                                                >
                                                <p class="mb-2 text-sm text-gray-500 text-centyer">
                                                    <span class="font-semibold">Click to upload</span> or drag
                                                    and drop
                                                </p>
                                                <p class="text-xs text-gray-500">PDF only, maximum of 10 MB</p>
                                                </FileDropInput>
                                            </div>
                                            <!-- File Preview with Progress -->
                                            <div
                                                v-if="file_preview"
                                                class="mt-3 p-3 border rounded bg-gray-50"
                                            >
                                                <div
                                                    class="flex items-center justify-between mb-1"
                                                >
                                                    <span class="text-sm truncate">{{ file_preview.name }}</span>
                                                    <span class="text-xs text-gray-500">{{ file_preview.size }}</span>
                                                </div>
                                                <div
                                                    class="h-2 bg-gray-200 rounded"
                                                >
                                                    <div
                                                        class="h-2 bg-green-500 rounded"
                                                        :style="{
                                                            width:
                                                                file_preview.progress +
                                                                '%',
                                                        }"
                                                    ></div>
                                                </div>
                                                <div
                                                    class="text-right text-xs mt-1"
                                                >
                                                    {{ file_preview.progress }}%
                                                </div>
                                            </div>
                                            <InputError
                                                class="mt-2"
                                                :message="submit_new_proposal.errors.proposal_file"
                                            />
                                        </div>
                                        <v-divider class="my-4"></v-divider>
                                        <div class="text-end">
                                            <v-btn
                                                text="Close"
                                                variant="plain"
                                                @click="submit_new_proposal_dialog = false"
                                            ></v-btn>

                                            <v-btn
                                                color="primary"
                                                text="Submit"
                                                variant="tonal"
                                                type="submit"
                                                :loading="submit_new_proposal.processing"
                                            ></v-btn>
                                        </div>
                                    </form>
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>

                <!-- edit proposal  -->
                <div>
                    <v-dialog
                        v-model="edit_proposal_dialog"
                        persistent
                        max-width="600"
                    >
                        <v-card
                            prepend-icon="mdi-file-edit-outline"
                            title="Edit Project Proposal"
                            class="pa-2"
                        >
                            <v-card-text>
                                <div>
                                    <form @submit.prevent="edit_proposal">
                                        <div v-if="$page.props.auth.user.role != 'User'" class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Campus"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <SelectInput v-model="edit_proposal_form.campus_id">
                                                    <option value="" disabled selected>
                                                        Select Campus
                                                    </option>
                                                    <option v-for="campus in $page.props.campuses" :key="campus.id" :value="campus.id">
                                                        {{ campus.campus }}
                                                    </option>
                                                </SelectInput>
                                                <InputError
                                                    class="mt-2"
                                                    :message="edit_proposal_form.errors.campus_id"
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Project Title"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <TextInput
                                                    v-model="
                                                        edit_proposal_form.proposal_title
                                                    "
                                                    class="w-full"
                                                    :placeholder="'Enter proposal title'"
                                                />
                                                <InputError
                                                    class="mt-2"
                                                    :message="
                                                        edit_proposal_form
                                                            .errors
                                                            .proposal_title
                                                    "
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4 w-full">
                                            <div>
                                                <InputLabel
                                                    value="Category"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <SelectInput v-model="edit_proposal_form.proposal_category">
                                                    <option
                                                        value=""
                                                        disabled
                                                        selected
                                                    >
                                                        Select Category
                                                    </option>
                                                    <option value="Agri-based">Agri-based</option>
                                                    <option value="Non agri-based">Non agri-based</option>
                                                </SelectInput>
                                                <InputError
                                                    class="mt-2"
                                                    :message="edit_proposal_form.errors.proposal_category"
                                                />
                                            </div>
                                        </div>
                                        <div class="mb-4">
                                            <div>
                                                <InputLabel
                                                    value="Project File (PDF only)"
                                                    required="true"
                                                    class="mb-1"
                                                />
                                                <FileDropInput
                                                    class="w-full"
                                                    file_limitation="application/pdf"
                                                    @change="handle_edit_proposal_file_change"
                                                >
                                                <p class="mb-2 text-sm text-gray-500 text-center">
                                                    <span class="font-semibold">Click to change uploaded file</span> or drag
                                                    and drop
                                                </p>
                                                <p class="text-xs text-gray-500">PDF only, maximum of 10 MB</p>
                                                </FileDropInput>
                                            </div>
                                            <!-- File Preview with Progress -->
                                            <div
                                                v-if="file_preview"
                                                class="mt-3 p-3 border rounded bg-gray-50"
                                            >
                                                <div
                                                    class="flex items-center justify-between mb-1"
                                                >
                                                    <span class="text-sm truncate">{{ file_preview.name }}</span>
                                                    <span class="text-xs text-gray-500">{{ file_preview.size }}</span>
                                                </div>
                                                <div
                                                    class="h-2 bg-gray-200 rounded"
                                                >
                                                    <div
                                                        class="h-2 bg-green-500 rounded"
                                                        :style="{
                                                            width:
                                                                file_preview.progress +
                                                                '%',
                                                        }"
                                                    ></div>
                                                </div>
                                                <div
                                                    class="text-right text-xs mt-1"
                                                >
                                                    100%
                                                </div>
                                            </div>
                                            <InputError
                                                class="mt-2"
                                                :message="edit_proposal_form.errors.proposal_file"
                                            />
                                        </div>
                                        <v-divider class="my-4"></v-divider>
                                        <div class="text-end">
                                            <v-btn
                                                text="Cancel"
                                                variant="plain"
                                                @click="edit_proposal_dialog = false"
                                            ></v-btn>

                                            <v-btn
                                                color="primary"
                                                text="Save Changes"
                                                variant="tonal"
                                                type="submit"
                                                :loading="edit_proposal_form.processing"
                                            ></v-btn>
                                        </div>
                                    </form>
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>

                <!-- view project file pdf  -->
                <div>
                    <v-dialog v-model="view_project_file_dialog" fullscreen>
                        <v-card>
                            <div
                                id="title"
                                class="sticky top-0 bg-white z-10 shadow-sm"
                            >
                                <div
                                    class="mx-4 my-4 flex justify-between items-center"
                                >
                                    <!-- Left: Project Proposal Text -->
                                    <p class="font-medium text-xl flex-grow">
                                        Project Proposal
                                    </p>

                                    <!-- Right: Close Button -->
                                    <div class="ml-4">
                                        <v-btn
                                            color="light-green-darken-4"
                                            rounded="0"
                                            variant="outlined"
                                            @click="view_remarks_bubble_dialog(remarks_proposal_id)"
                                            class="me-2"
                                            :prepend-icon="$page.props.auth.user.role == 'User' ? 'mdi-comment-outline' : 'mdi-comment-plus-outline'"
                                        >
                                            <div v-if="$page.props.auth.user.role == 'User'">
                                                View Remarks
                                            </div>
                                            <div v-else>
                                                Add Remarks
                                            </div>
                                        </v-btn>
                                        <v-btn
                                            color="blue-darken-4"
                                            rounded="0"
                                            variant="outlined"
                                            @click="
                                                view_project_file_dialog = false
                                            "
                                        >
                                            Close
                                        </v-btn>
                                    </div>
                                </div>
                            </div>

                            <v-card-text>
                                <div :style="{ width: '100%', height: '100%' }">
                                    <VPdfViewer
                                        :src="project_file_path"
                                    />
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>

                <!-- remarks bubble  -->
                <div>
                    <v-dialog
                        v-model="remarks_bubble_dialog"
                        persistent
                        max-width="500"
                    >
                        <v-card
                            prepend-icon="mdi-comment-outline"
                            title="Remarks"
                            class="pa-2"
                        >
                            <v-card-text>
                                <form @submit.prevent="submit_remark">
                                    <div>
                                        <RemarkBubble :remark="remarks_list">
                                            <div v-if="$page.props.auth.user.role == 'User'" class="text-center mt-8 text-gray-400 text-xs italic">
                                                You can't reply to this conversation.
                                            </div>
                                            <div v-else class="flex justify-space-between align-center mt-8">
                                                <textarea v-model="add_proposal_remark.remark" id="chat" rows="1" class="block mx-4 p-2.5 w-full text-sm text-gray-900 bg-white rounded-lg border border-gray-300 focus:ring-teal-500 focus:border-teal-500" placeholder="Your message..."></textarea>
                                                <v-btn variant="plain" icon="mdi-send" type="submit" color="teal-darken-3" :loading="add_proposal_remark.processing"></v-btn>
                                                <!-- <button :loa type="submit" class="inline-flex justify-center p-2 text-teal-600 rounded-full cursor-pointer">
                                                    <svg class="w-5 h-5 rotate-90 rtl:-rotate-90" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="teal" viewBox="0 0 18 20">
                                                        <path d="m17.914 18.594-8-18a1 1 0 0 0-1.828 0l-8 18a1 1 0 0 0 1.157 1.376L8 18.281V9a1 1 0 0 1 2 0v9.281l6.758 1.689a1 1 0 0 0 1.156-1.376Z"/>
                                                    </svg>
                                                    <span class="sr-only">Send message</span>
                                                </button> -->
                                            </div>
                                        </RemarkBubble>
                                    </div>

                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="
                                                remarks_bubble_dialog = false
                                            "
                                        ></v-btn>
                                    </div>
                                </form>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>

                <!-- approve proposal  -->
                <div>
                    <v-dialog
                        v-model="approve_proposal_dialog"
                        persistent
                        max-width="500"
                    >
                        <v-card
                            prepend-icon="mdi-file-document-alert-outline"
                            title="Approve Project Propoosal?"
                            class="pa-2"
                        >
                            <v-card-text>
                                <form @submit.prevent="evaluate_proposal">
                                    <div class="flex justify-space-between">
                                        <div>
                                            <v-icon
                                                color="warning"
                                                icon="mdi-information"
                                                size="40"
                                            ></v-icon>
                                        </div>
                                        <div class="ms-4">
                                            Are you sure you want to approve
                                            this project proposal?
                                        </div>
                                    </div>

                                    <div class="mt-4">
                                        <div
                                            class="flex items-center p-4 mb-4 text-sm text-yellow-800 border border-yellow-300 rounded-lg bg-yellow-50"
                                            role="alert"
                                        >
                                            <svg
                                                class="shrink-0 inline w-4 h-4 me-3"
                                                aria-hidden="true"
                                                xmlns="http://www.w3.org/2000/svg"
                                                fill="currentColor"
                                                viewBox="0 0 20 20"
                                            >
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"
                                                />
                                            </svg>
                                            <span class="sr-only">Info</span>
                                            <div>
                                                <span class="font-medium"
                                                    >NOTE:</span
                                                >
                                                Once you approve this project
                                                proposal,
                                                <span class="font-medium"
                                                    >you will not be able to
                                                    cancel your action.</span
                                                >
                                                The buttons will be disabled
                                                after approval, and no further
                                                changes can be made.
                                            </div>
                                        </div>
                                    </div>

                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="No, close"
                                            variant="plain"
                                            @click="
                                                approve_proposal_dialog = false
                                            "
                                        ></v-btn>

                                        <v-btn
                                            color="info"
                                            text="Yes, approve"
                                            variant="tonal"
                                            type="submit"
                                            :loading="proposal_action.processing"
                                        ></v-btn>
                                    </div>
                                </form>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>

                <!-- decline proposal  -->
                <div>
                    <v-dialog
                        v-model="decline_proposal_dialog"
                        persistent
                        max-width="500"
                    >
                        <v-card
                            prepend-icon="mdi-file-document-alert-outline"
                            title="Decline Project Propoosal?"
                            class="pa-2"
                        >
                            <v-card-text>
                                <form @submit="evaluate_proposal">
                                    <div class="flex justify-space-between">
                                        <div>
                                            <v-icon
                                                color="error"
                                                icon="mdi-information"
                                                size="40"
                                            ></v-icon>
                                        </div>
                                        <div class="ms-4">
                                            Are you sure you want to decline
                                            this project proposal?
                                        </div>
                                    </div>

                                    <div class="mt-4">
                                        <div
                                            class="flex items-center p-4 mb-4 text-sm text-yellow-800 border border-yellow-300 rounded-lg bg-yellow-50"
                                            role="alert"
                                        >
                                            <svg
                                                class="shrink-0 inline w-4 h-4 me-3"
                                                aria-hidden="true"
                                                xmlns="http://www.w3.org/2000/svg"
                                                fill="currentColor"
                                                viewBox="0 0 20 20"
                                            >
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"
                                                />
                                            </svg>
                                            <span class="sr-only">Info</span>
                                            <div>
                                                <span class="font-medium"
                                                    >NOTE:</span
                                                >
                                                Once you decline this project
                                                proposal,
                                                <span class="font-medium"
                                                    >you will not be able to
                                                    cancel your action.</span
                                                >
                                                The buttons will be disabled
                                                after approval, and no further
                                                changes can be made.
                                            </div>
                                        </div>
                                    </div>

                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="No, close"
                                            variant="plain"
                                            @click="
                                                decline_proposal_dialog = false
                                            "
                                        ></v-btn>

                                        <v-btn
                                            color="error"
                                            text="Yes, decline"
                                            variant="tonal"
                                            type="submit"
                                            :loading="proposal_action.processing"
                                        ></v-btn>
                                    </div>
                                </form>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>
            </div>

            <!-- pdf reports here  -->
             <!-- <PDFLayout v-show="isExporting" ref="pdfSection" :current_user="current_user" :headers="pdf_headers" title="List of Proposals">
                <tr v-for="(item, index) in filteredProposals" :key="index">
                    <td class="px-6 pb-3 whitespace-nowrap text-sm font-medium text-gray-900">{{ index + 1 }}.</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.campus }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.project_title }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.proposal_category }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.proposal_status }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">{{ item.submitted_by.name }} | {{ item.submitted_by.datetime }}</td>
                    <td class="px-6 pb-3 whitespace-nowrap text-sm text-gray-500">
                        <div v-if="item.proposal_status == 'Pending'">Not yet evaluated (Under review)</div>
                        <div v-else>
                            {{ item.submitted_by.name }} | {{ item.submitted_by.datetime }}
                        </div>
                    </td>
                </tr>
             </PDFLayout> -->

             <!-- excel reports here  -->
             <!-- <ExcelLayout
                ref="excelSection"
                :headers="['#', 'Campus', 'Project Title', 'Project Category', 'Proposal Status', 'Added/Submitted By', 'Evaluated By']"
                :data="filteredProposals"
                title="List of Proposals"
            /> -->
        </div>
    </AuthenticatedLayout>
</template>

<script>
export default {
    // from the database
    // props: {
    //     enterprises: {
    //         type: Array,
    //         required: true,
    //     },
    // },
    data() {
        return {
            search: "",
            header: [
                {
                    title: "#",
                    align: "start",
                    key: "number",
                    sortable: false,
                },
                {
                    title: "Campus",
                    align: "center",
                    key: "campus",
                    sortable: true,
                },
                {
                    title: "Actions",
                    align: "end",
                    key: "actions",
                    sortable: false,
                },
            ],
            enterprises: [
                // {
                //   number: 1,
                //   id: 1,
                //   enterprise: 'Carabao Stud Farm',
                //   type: 'Agri-based'
                // },
                // {
                //   number: 2,
                //   id: 2,
                //   enterprise: 'Fishpond Rental',
                //   type: 'Agri-based'
                // },
                // {
                //   number: 3,
                //   id: 3,
                //   enterprise: 'HVC CBAO',
                //   type: 'Agri-based'
                // },
                // {
                //   number: 4,
                //   id: 4,
                //   enterprise: 'ID Lanyard/Lace',
                //   type: 'Non agri-based'
                // },
                // {
                //   number: 5,
                //   id: 5,
                //   enterprise: 'PE Uniform',
                //   type: 'Non agri-based'
                // },
            ],

            breadcrumbs_items: [
                {
                    title: "Transaction",
                    active: false,
                },
                {
                    title: "Proposal",
                    active: true,
                },
            ],
        };
    },
};
</script>
