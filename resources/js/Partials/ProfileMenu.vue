<template>
    <!-- clickable avatar icon -->
    <v-menu min-width="100px" rounded class="fidroams">
        <template v-slot:activator="{ props }">
            <v-btn icon v-bind="props" aria-label="Profile">
                <v-avatar color="green-lighten-3">
                    <span style="font-size: 14px; font-weight: 800">{{ name.first_name[0] }}{{ name.last_name[0] }}</span>
                </v-avatar>
            </v-btn>
        </template>
        <v-card>
            <v-card-text>
                <div class="mx-auto">
                    <v-row>
                        <v-col cols="3">
                            <v-avatar color="green-darken-4" >
                                <span style="font-size: 14px; font-weight: 600">{{ name.first_name[0] }}{{ name.last_name[0] }}</span>
                            </v-avatar>
                        </v-col>
                        <v-col>
                            <h3>{{ name.first_name }} {{ name.last_name }}</h3>
                            <p style="font-size: 12px;">
                                {{ email_address }}
                            </p>
                        </v-col>
                    </v-row>
                    <v-divider class="border-opacity-75 my-3" :thickness="2"></v-divider>
                    <div class="mb-2">
                        <SecondaryButtonWithIconTonalVariant :href="route('profile.edit')">
                            <v-icon icon="mdi-account" class="mr-3"></v-icon>
                            View Profile
                        </SecondaryButtonWithIconTonalVariant>
                    </div>
                    <div>
                        <LogoutButton @click="handle_logout" as="button">
                            <v-icon icon="mdi-logout" class="mr-3"></v-icon>
                            Logout
                        </LogoutButton>
                    </div>
                </div>
            </v-card-text>
        </v-card>
    </v-menu>
</template>

<script setup>
import LogoutButton from '@/Components/LogoutButton.vue';
import SecondaryButtonWithIconTonalVariant from '@/Components/SecondaryButtonWithIconTonalVariant.vue';
import Swal from 'sweetalert2';
import { router } from '@inertiajs/vue3';

const props = defineProps({
    name: {
        type: Object,
        required: true,
    },
    email_address: {
        type: Boolean,
    },
    avatar: {
        type: String
    }
});

const handle_logout = () => {
    Swal.fire({
        title: 'Logging you out...',
        text: 'Please wait a moment.',
        icon: 'info',
        showConfirmButton: false,
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading()
            router.post(route('logout'), {}, {
                onFinish: () => {
                    Swal.close() // ✅ close Swal once logout request finishes
                }
            })
        }
    })
    
};
</script>