<script setup>
import { Link } from '@inertiajs/vue3';

defineProps({
    href: {
        type: String,
        required: true,
    },
});
</script>

<template>
    <Link
        :href="href"
        class="block w-full px-4 py-2 text-start text-sm leading-5 bg-green-700 rounded font-semibold text-white transition duration-150 ease-in-out hover:bg-green-800 focus:bg-green-800 focus:outline-none"
    >
        <slot />
    </Link>
</template>
