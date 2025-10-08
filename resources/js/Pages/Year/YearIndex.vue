<script setup>
import ActionButton from '@/Components/ActionButton.vue';
import Breadcrumbs from '@/Components/Breadcrumbs.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import TextInput from '@/Components/TextInput.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { useFlashWatcher } from '@/Utils/useFlashWatcher';
import { useForm, usePage } from '@inertiajs/vue3';
import { ref } from 'vue';

const page = usePage()
const table_loading = ref(false)
const add_year_dialog = ref(false)

// add year
const add_year_form = useForm({
    year: ''
})

const submit = () => {
    add_year_form.post(route("years.store"), {
        onSuccess: () => {
            add_year_form.reset(); // Reset the form after successful submission
            add_year_dialog.value = false;
        },
    });
};
// end add year

// edit year
const edit_year_dialog = ref(false)
const edit_year_form = useForm({
    year_id: '',
    year: ''
})

const handle_edit_year = (year_id) => {
    const year = page.props.years.find(
        (y) => y.id === year_id
    )

    edit_year_form.year_id = year.id
    edit_year_form.year = year.year

    edit_year_dialog.value = true
}

const update = () => {
    edit_year_form.put(route("years.update", edit_year_form.year_id), {
        onSuccess: () => {
            edit_year_form.reset(); // Reset the form after successful submission
            edit_year_dialog.value = false;
        },
    });
};

const breadcrumbs_items = ref([
    {
        title: "Transaction",
        active: false,
    },
    {
        title: "Academic Years",
        active: true,
    },
]);

const headers = ref([
    {
        title: "#",
        align: "start",
        key: "number",
        sortable: false,
    },
    {
        title: "Year",
        align: "start",
        key: "year",
        sortable: true,
    },
    {
        title: "Actions",
        align: "end",
        key: "actions",
        sortable: false,
    },
]);

useFlashWatcher("years.display");
</script>

<template>
    <Head title="Years" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">
                Years
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
                                        mdi-calendar-blank-outline
                                    </v-icon>
                                    <span
                                        :class="
                                            $vuetify.display.smAndDown
                                                ? 'text-lg font-weight-semibold'
                                                : 'text-2xl font-weight-semibold'
                                        "
                                    >
                                        Academic Years
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
                                        text="Add Academic Year"
                                        variant="flat"
                                        color="green-darken-4"
                                        @click="add_year_dialog - true"
                                    ></v-btn>

                                    <!-- Icon-only button for small devices -->
                                    <v-btn
                                        v-else
                                        class="ms-2"
                                        icon
                                        variant="flat"
                                        color="green-darken-4"
                                        @click="add_year_dialog = true"
                                    >
                                        <v-icon
                                            size="18"
                                            class="font-weight-bold"
                                            >mdi-plus</v-icon
                                        >
                                    </v-btn>
                                </div>
                            </v-card-title>

                            <v-divider
                                class="border-opacity-75"
                                :thickness="2"
                            ></v-divider>

                            <v-data-table
                                :search="search"
                                :headers="headers"
                                :items="$page.props.years"
                                hover
                                :loading="table_loading"
                            >
                                <template v-slot:loading>
                                    <v-skeleton-loader
                                        type="table-row@5"
                                    ></v-skeleton-loader>
                                </template>

                                <template v-slot:item.number="{ item, index }">
                                    <div class="text-start">
                                        {{ index+1 }}
                                    </div>
                                </template>

                                <template v-slot:item.actions="{ item }">

                                    <!-- <div v-if="$page.props.auth.user.role == 'User'" class="float-end">
                                        <ActionButton @click="handle_edit_proposal(item.proposal_id)" :variant="'flat'" :color="'info'" :text="'Edit'" prepend-icon="mdi-file-edit-outline" :disabled="item.proposal_status != 'Pending'" />
                                    </div> -->

                                    <div class="text-end d-flex justify-end align-center gap-1">
                                        <ActionButton @click="handle_edit_year(item.id)" :variant="'flat'" :color="'warning'" :text="'Edit'" prepend-icon="mdi-pencil" />
                                        <ActionButton :variant="'flat'" :color="'error'" :text="'Delete'" prepend-icon="mdi-delete" />
                                    </div>
                                </template>
                            </v-data-table>
                        </v-card>
                    </div>
                </div>
            </div>

            <!-- modals  -->
             <div>
                <!-- add year  -->
                <v-dialog v-model="add_year_dialog" persistent max-width="600">
                    <v-card prepend-icon="mdi-cash-multiple" title="Add Academic Year" class="pa-2">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="submit">
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="year" value="Year" required="true"/>
                                            <TextInput
                                                id="year"
                                                type="number"
                                                class="mt-1 block w-full"
                                                v-model="add_year_form.year"
                                                autocomplete="year"
                                                placeholder="Enter year."
                                            />
                                            <InputError class="mt-2" :message="add_year_form.errors.year" />
                                        </div>
                                    </div>
                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="add_year_dialog = false"
                                        ></v-btn>

                                        <v-btn
                                            color="primary"
                                            text="Save"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': add_year_form.processing }"
                                            :loading="add_year_form.processing"
                                        ></v-btn>
                                    </div>
                                </form>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-dialog>

                <!-- edit year  -->
                <v-dialog v-model="edit_year_dialog" persistent max-width="600">
                    <v-card prepend-icon="mdi-cash-multiple" title="Add Academic Year" class="pa-2">
                        <v-card-text>
                            <div>
                                <form @submit.prevent="update">
                                    <div class="mb-4">
                                        <div>
                                            <InputLabel for="year" value="Year" required="true"/>
                                            <TextInput
                                                id="year"
                                                type="number"
                                                class="mt-1 block w-full"
                                                v-model="edit_year_form.year"
                                                autocomplete="year"
                                                placeholder="Enter year."
                                            />
                                            <InputError class="mt-2" :message="edit_year_form.errors.year" />
                                        </div>
                                    </div>
                                    <v-divider class="my-4"></v-divider>
                                    <div class="text-end">
                                        <v-btn
                                            text="Close"
                                            variant="plain"
                                            @click="edit_year_dialog = false"
                                        ></v-btn>

                                        <v-btn
                                            color="primary"
                                            text="Save Changes"
                                            variant="tonal"
                                            type="submit"
                                            :class="{ 'opacity-25': edit_year_form.processing }"
                                            :loading="edit_year_form.processing"
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