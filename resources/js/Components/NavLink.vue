<script setup>
import {computed} from 'vue';
import {Link} from '@inertiajs/vue3'
const props = defineProps({
    href: {
        type: String,
        required: true,
    },
    active: {
        type: Boolean,
    },
    icon: {
        type: String
    }
});

const classes = computed(() =>
    props.active
        ? 'border-start: 3px solid #1B5E20; background-color: #E8F5E9; border-radius: 5px; color: #1B5E20; font-size: 14px;'
        : 'tw-inline-flex tw-items-center tw-px-1 tw-pt-1 tw-border-b-2 tw-border-transparent tw-text-sm tw-font-medium tw-leading-5 tw-text-gray-500 hover:tw-text-gray-700 hover:tw-border-gray-300 focus:tw-outline-none focus:tw-text-gray-700 focus:tw-border-gray-300 tw-transition tw-duration-150 tw-ease-in-out'
);
</script>

<template>
    <Link :href="href" style="text-decoration: none; color: #616161">
        <v-list-item :href="href" :style="classes" link>
            <template v-slot:prepend>
                <v-icon style="font-size: 14px">{{ icon }}</v-icon>
            </template>
            <slot/>
        </v-list-item>
    </Link>
</template>
