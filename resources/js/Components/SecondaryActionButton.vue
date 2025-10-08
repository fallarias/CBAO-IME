<script setup>
defineProps({
    icon: {
        type: String,
        default: null,
    },
});
</script>

<template>
    <v-btn
        color="light-green-darken-4"
        rounded="0"
        variant="outlined"
        class="me-2"
        :prepend-icon="props.icon"
    >
        <slot />
    </v-btn>
</template>
