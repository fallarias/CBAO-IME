<script setup>
import { onMounted, ref } from 'vue';

const props = defineProps({
    placeholder: {
        type: String,
        default: '',
    },
});

const model = defineModel({
    type: String,
    required: true,
});

const input = ref(null);

onMounted(() => {
    if (input.value.hasAttribute('autofocus')) {
        input.value.focus();
    }
});

defineExpose({ focus: () => input.value.focus() });
</script>

<template>
    <input
        class="rounded-md border border-gray-500 py-3 focus:border-teal-500 focus:ring-teal-500 disabled:bg-gray-100 disabled:text-gray-500 disabled:placeholder-gray-500" :placeholder="props.placeholder"
        v-model="model"
        ref="input"
    />
</template>
