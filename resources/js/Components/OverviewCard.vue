<template>
    <v-card :color="`green-darken-${data.color}`" variant="flat" class="px-6 pt-8 pb-2">
        <v-row class="justify-center">
            <v-col>
                <p class="text-4xl font-bold">{{ data.total }}</p>
                <p class="text-sm mt-2">{{ data.title }}</p>
            </v-col>
            <v-col>
                <div class="text-3xl text-end">
                    <v-icon :icon="data.icon" class="border-2 rounded-full pa-10"></v-icon>
                </div>
            </v-col>
        </v-row>
        <div v-if="data.more_info == true">
            <v-divider :thickness="2" class="mt-2 border-opacity-25"></v-divider>
            <div class="flex items-center justify-center mt-2">
                <div class="text-center text-sm font-semibold mr-2">More Info</div>
                <v-icon icon="mdi-arrow-right-bold"></v-icon>
            </div>
        </div>
    </v-card>
</template>

<script>
export default {
    props: {
        data: {
            type: Array,
            required: true,
        },
    },
    methods: {
        onClick() {
            this.loading = true
            setTimeout(() => {
                this.loading = false
            }, 1000)
        }
    }
}
</script>