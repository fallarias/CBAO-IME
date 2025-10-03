<script setup>
defineProps({
  modelValue: String,
})

const emit = defineEmits(['update:modelValue'])
</script>

<template>
    <div class="w-full">
        <div class="relative">
            <select
                :value="modelValue"
                @change="emit('update:modelValue', $event.target.value)"
                class="w-full bg-transparent placeholder:text-teal-400 text-teal-700 text-sm border border-teal-200 rounded pl-3 pr-8 py-4 transition duration-300 ease focus:outline-none focus:border-teal-400 hover:border-teal-400 shadow-sm focus:shadow-md appearance-none cursor-pointer [&::-ms-expand]:hidden"
            >
                <slot />
            </select>
            <!-- <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.2"
                stroke="currentColor"
                class="h-5 w-5 ml-1 absolute top-3.5 right-2.5 text-teal-700 pointer-events-none"
            >
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M8.25 15 12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                />
            </svg> -->
        </div>
    </div>
</template>
