<template>
    <div class="text-sm d-flex items-center">
        <p>You are here: </p>
        <v-breadcrumbs :items="items" active-color="green-darken-5">
            <template v-slot:divider>
                <v-icon icon="mdi-chevron-right"></v-icon>
            </template>
        </v-breadcrumbs>
    </div>
</template>

<script setup>

defineProps({
    items: {
        type: [Array, String],
        required: true,
    },
});
</script>