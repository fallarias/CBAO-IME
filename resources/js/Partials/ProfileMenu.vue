<template>
    <!-- clickable avatar icon -->
    <v-menu min-width="100px" rounded class="fidroams">
        <template v-slot:activator="{ props }">
            <v-btn icon v-bind="props" aria-label="Profile">
                <v-avatar color="green-lighten-3">
                    <span style="font-size: 14px; font-weight: 800">CC</span>
                </v-avatar>
            </v-btn>
        </template>
        <v-card>
            <v-card-text>
                <div class="mx-auto">
                    <v-row>
                        <v-col cols="3">
                            <v-avatar color="green-darken-4" >
                                <span style="font-size: 14px; font-weight: 600">UA</span>
                            </v-avatar>
                        </v-col>
                        <v-col>
                            <h3>{{ name }}</h3>
                            <p style="font-size: 12px;">
                                {{ email_address }}
                            </p>
                        </v-col>
                    </v-row>
                    <v-divider class="border-opacity-75 my-3" :thickness="2"></v-divider>
                    <div class="mb-2">
                        <v-btn block variant="tonal" class="text-none" color="green-darken-4" prepend-icon="mdi-account" @click="logout" aria-label="Logout">View Profile</v-btn>
                    </div>
                    <div>
                        <LogoutButton :href="route('logout')" method="post" as="button">
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


const props = defineProps({
    name: {
        type: String,
    },
    email_address: {
        type: Boolean,
    },
    avatar: {
        type: String
    }
});
</script>