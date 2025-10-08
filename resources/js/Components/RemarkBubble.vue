<script setup>
const props = defineProps({
    remark: {
        type: Array,
        default: null,
    },
});
</script>

<template>
    <!-- <div class="text-center text-xs text-disabled mb-3">Oct. 2, 2025 11:40 AM</div> -->
     <div class="text-center text-sm text-gray-500 my-3" v-if="props.remark.length === 0">
        There are no remarks for this proposal. 
     </div>
     <div  v-else>

         <div v-for="(remark, index) in props.remark" :key="index" class="flex items-start gap-2.5 my-2">
             <img
                 class="w-8 h-8 rounded-full"
                 :src="`/storage/uploads/avatar/${remark.remarked_by_avatar}`"
                 alt="Jese image"
             />
             <div
                 class="flex flex-col w-full max-w-[320px] leading-1.5 px-4 py-2 border-gray-200 bg-gray-100 rounded-e-xl rounded-es-xl"
             >
                 <div class="flex items-center space-x-2 rtl:space-x-reverse">
                     <span
                         class="text-sm font-semibold text-gray-900"
                         >{{ remark.remarked_by }}</span
                     >
                 </div>
                 <p class="text-sm font-normal py-2.5 text-gray-900">
                     {{ remark.remark }}
                 </p>
                 <span class="text-xs font-normal text-gray-500 dark:text-gray-400">{{ remark.remark_date }}</span>
             </div>
     </div>
        <!-- <button
            id="dropdownMenuIconButton"
            data-dropdown-toggle="dropdownDots"
            data-dropdown-placement="bottom-start"
            class="inline-flex self-center items-center p-2 text-sm font-medium text-center text-gray-900 bg-white rounded-lg hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-50"
            type="button"
        >
            <svg
                class="w-4 h-4 text-gray-500"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="currentColor"
                viewBox="0 0 4 15"
            >
                <path
                    d="M3.5 1.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Zm0 6.041a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Zm0 5.959a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Z"
                />
            </svg>
        </button>
        <div
            id="dropdownDots"
            class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow-sm w-40"
        >
            <ul
                class="py-2 text-sm text-gray-700"
                aria-labelledby="dropdownMenuIconButton"
            >
                <li>
                    <a
                        href="#"
                        class="block px-4 py-2 hover:bg-gray-100"
                        >Reply</a
                    >
                </li>
                <li>
                    <a
                        href="#"
                        class="block px-4 py-2 hover:bg-gray-100"
                        >Forward</a
                    >
                </li>
                <li>
                    <a
                        href="#"
                        class="block px-4 py-2 hover:bg-gray-100"
                        >Copy</a
                    >
                </li>
                <li>
                    <a
                        href="#"
                        class="block px-4 py-2 hover:bg-gray-100"
                        >Report</a
                    >
                </li>
                <li>
                    <a
                        href="#"
                        class="block px-4 py-2 hover:bg-gray-100"
                        >Delete</a
                    >
                </li>
            </ul>
        </div> -->
    </div>

    
    
    <slot />
</template>
