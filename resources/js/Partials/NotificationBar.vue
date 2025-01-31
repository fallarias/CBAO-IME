<template>
    <!-- clickable avatar icon -->
    <v-menu min-width="100px" rounded class="fidroams">
        <template v-slot:activator="{ props }">
            <v-btn v-bind="props" class="text-none" stacked aria-label="Notification">
                <v-badge color="error" content="2">
                    <v-icon size="30">mdi-bell</v-icon>
                </v-badge>
            </v-btn>
        </template>
        <v-card max-width="500px">
            <v-card-text>
                <v-list lines="two">
                    <v-list-item>
                        <v-list-item-title class="text-green-darken-3">
                            <p class="font-bold">You received a new submission!</p>
                        </v-list-item-title>
                        <v-list-item-subtitle class="mb-1 text-high-emphasis opacity-100">Applicant Cyra C. Cacho has submitted an application for Candidate Soldiers Registration.</v-list-item-subtitle>
                        <v-list-item-subtitle class="text-high-emphasis">4 days ago</v-list-item-subtitle>
                        <template v-slot:prepend>
                            <v-avatar color="grey-lighten-1">
                                <v-icon color="white">mdi-folder</v-icon>
                            </v-avatar>
                        </template>
                    </v-list-item>
                    <v-list-item>
                        <v-divider class="border-opacity-75 mb-5" :thickness="2"></v-divider>
                        <v-list-item-title class="text-green-darken-3">
                            <p class="font-bold">You received a new submission!</p>
                        </v-list-item-title>
                        <v-list-item-subtitle class="mb-1 text-high-emphasis opacity-100">Applicant Cyra C. Cacho has submitted an application for Candidate Soldiers Registration.</v-list-item-subtitle>
                        <v-list-item-subtitle class="text-high-emphasis">4 days ago</v-list-item-subtitle>
                        <template v-slot:prepend>
                            <v-avatar color="grey-lighten-1">
                                <v-icon color="white">mdi-folder</v-icon>
                            </v-avatar>
                        </template>
                    </v-list-item>
                </v-list>
            </v-card-text>
        </v-card>
    </v-menu>
</template>

<script setup>
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