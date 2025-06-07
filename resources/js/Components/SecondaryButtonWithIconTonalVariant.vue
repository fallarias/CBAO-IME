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
        class="block w-full px-4 py-2 text-start text-sm leading-5 bg-stone-100 rounded font-semibold text-green-700 transition duration-150 ease-in-out hover:bg-green-100 focus:bg-green-100 focus:outline-none"
    >
        <slot />
    </Link>
</template>
