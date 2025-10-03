<script setup>
defineProps({
    value: {
        type: String,
    },
    required: {
        type: Boolean,
        default: false,
    },
});
</script>

<template>
    <label class="block text-sm font-medium text-gray-700">
        <div v-if="value">{{ value }} <span v-if="required" class="text-red-500">*</span></div>
        <span v-else><slot /></span>
    </label>
</template>
