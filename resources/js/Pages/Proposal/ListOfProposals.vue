<script setup>
import InputError from "@/Components/InputError.vue";
import EnterpriseListPDF from "@/Components/PDFs/EnterpriseListPDF.vue";
import { Link, useForm, usePage, Head } from "@inertiajs/vue3";
import Swal from "sweetalert2";
import { nextTick, ref, watch } from "vue";
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

const page = usePage();

const remarks_bubble_dialog = ref(false);
const add_proposal_dialog = ref(false);
const table_loading = ref(false);
const view_project_file_dialog = ref(false);
const approve_proposal_dialog = ref(false);
const decline_proposal_dialog = ref(false);
const submit_new_proposal_dialog = ref(false);
const file_preview = ref(null);

// view remarks bubble dialog
const view_remarks_bubble_dialog = (id) => {
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

const project_file_path = ref("");
const handle_view_project_file = (file_path) => {
    // Logic to handle viewing the project file
    // For example, you can set the source of a PDF viewer component
    // or open the file in a new tab
    console.log("Viewing project file:", file_path);
    project_file_path.value = file_path;
    view_project_file_dialog.value = true;
};

const submit_new_proposal = useForm({
    user_id: "",
    campus_id: "",
    proposal_title: "",
    proposal_file: "",
    proposal_category: "",
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

const submit = () => {
    console.log("Form submitted:", submit_new_proposal);
    // Logic to handle form submission
    // You can use Inertia's form submission methods here
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
            // Handle success (e.g., show a success message, reset form, etc.)
            Swal.fire({
                icon: "success",
                title: "Proposal Submitted",
                text: "Your project proposal has been submitted successfully.",
            });
            file_preview.value = null;
            submit_new_proposal.reset(); // Reset the form after successful submission
            submit_new_proposal_dialog.value = false;
        },
        onError: (errors) => {
            // Handle errors (e.g., show error messages)
            console.error("Form submission errors:", errors);
            Swal.fire({
                icon: "error",
                title: "Submission Failed",
                text: "There were errors submitting your proposal. Please check the form and try again.",
            });
        },
    });
    // console.log('Form submitted:', submit_new_proposal);
    // Close the dialog after submission
};
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
                                        />
                                        <ExportButton
                                            :text="'Print to PDF'"
                                            icon="mdi-printer"
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
                                        <SelectInput
                                            class="max-w-sm min-w-[200px]"
                                        >
                                            <option value="" disabled selected>
                                                Filter by Campus
                                            </option>
                                            <option value="all">
                                                All Campuses
                                            </option>
                                            <option value="echague">
                                                Echague Campus
                                            </option>
                                        </SelectInput>
                                        <SelectInput
                                            class="max-w-sm min-w-[200px]"
                                        >
                                            <option value="" disabled selected>
                                                Filter by Status
                                            </option>
                                            <option value="all">
                                                All Status
                                            </option>
                                            <option value="pending">
                                                Pending
                                            </option>
                                            <option value="approved">
                                                Approved
                                            </option>
                                            <option value="declined">
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
                                v-model:search="search"
                                :filter-keys="['name']"
                                :headers="proposals_header"
                                :items="$page.props.proposals"
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
                                            class="hover:text-blue-500 hover:font-bold hover:underline hover:cursor-pointer"
                                            @click="handle_view_project_file(item.project_file.path)"
                                        >
                                            {{ item.project_file.title }} |
                                            <span
                                                class="text-blue-500 font-bold"
                                                >View</span
                                            >
                                            <br />
                                            <!-- <span class="text-small text-gray-500 hidden hover:block">View Record</span> -->
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

                                <template v-slot:item.actions="{ item }">
                                    <div
                                        v-if="
                                            $page.props.auth.user.role ==
                                            'Admin'
                                        "
                                        class="text-end"
                                    >
                                        <v-btn
                                            variant="flat"
                                            :disabled="
                                                item.proposal_status !=
                                                'Pending'
                                            "
                                            color="success"
                                            class="mr-2 text-none"
                                            prepend-icon="mdi-check"
                                            @click="
                                                approve_proposal_dialog = true
                                            "
                                            >Approve</v-btn
                                        >
                                        <v-btn
                                            variant="flat"
                                            :disabled="
                                                item.proposal_status !=
                                                'Pending'
                                            "
                                            color="error"
                                            class="mr-2 text-none"
                                            prepend-icon="mdi-exclamation"
                                            @click="
                                                decline_proposal_dialog = true
                                            "
                                            >Decline</v-btn
                                        >
                                    </div>
                                    <div v-else class="float-end">
                                        <div
                                            v-if="
                                                item.proposal_status ==
                                                'Pending'
                                            "
                                        >
                                            <p
                                                class="text-xs font-bold text-uppercase text-gray-500"
                                            >
                                                Currently under review
                                            </p>
                                        </div>
                                        <div v-else class="text-start py-4">
                                            <p
                                                class="text-xs font-bold text-uppercase text-gray-500"
                                            >
                                                {{ item.proposal_status }} By
                                            </p>
                                            <p class="my-1">
                                                2025-07-18 at 04:21 PM
                                            </p>
                                            <p
                                                class="border-l-4 ps-1 border-emerald-600 text-xs font-bold text-uppercase text-emerald-600"
                                            >
                                                John Doe
                                            </p>
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
                                                />
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
                                            @click="view_remarks_bubble_dialog(1)"
                                            class="me-2"
                                            prepend-icon="mdi-comment-plus-outline"
                                        >
                                            <div>
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
                                <form>
                                    <div>
                                        <RemarkBubble>
                                            <div class="flex justify-space-between align-center mt-8">

                                                <textarea id="chat" rows="1" class="block mx-4 p-2.5 w-full text-sm text-gray-900 bg-white rounded-lg border border-gray-300 focus:ring-teal-500 focus:border-teal-500" placeholder="Your message..."></textarea>
                                                <button type="submit" class="inline-flex justify-center p-2 text-teal-600 rounded-full cursor-pointer">
                                                    <svg class="w-5 h-5 rotate-90 rtl:-rotate-90" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="teal" viewBox="0 0 18 20">
                                                        <path d="m17.914 18.594-8-18a1 1 0 0 0-1.828 0l-8 18a1 1 0 0 0 1.157 1.376L8 18.281V9a1 1 0 0 1 2 0v9.281l6.758 1.689a1 1 0 0 0 1.156-1.376Z"/>
                                                    </svg>
                                                    <span class="sr-only">Send message</span>
                                                </button>
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
                                <form>
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
                                <form>
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
                                        ></v-btn>
                                    </div>
                                </form>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                </div>
            </div>
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
