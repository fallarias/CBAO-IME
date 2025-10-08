<script setup>
const props = defineProps({
    color: {
        type: String,
        default: 'info'
    },
    variant: {
        type: String,
        default: 'flat'
    },
    text: {
        type: String
    }
})
</script>

<template>
    <v-btn
        :variant="variant"
        :color="color"
        class="text-none"
    >
        {{ text }}
    </v-btn>
</template>