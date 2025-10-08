<script setup>
const props = defineProps({
  overall_total: {
    type: Number,
    default: 0,
  },
  agri_based_total: {
    type: Number,
    default: 0,
  },
  non_agri_based_total: {
    type: Number,
    default: 0,
  },
})
</script>

<template>
    <div>
        <v-row dense>
            <v-col cols="12" md="4">
                <v-card color="green-darken-1" variant="flat" class="px-6 py-8">
                    <v-row class="justify-center">
                        <v-col>
                            <p class="text-6xl font-bold">{{ props.overall_total }}</p>
                            <p class="text-sm mt-2">Income-generating enterprises</p>
                        </v-col>
                        <v-col>
                            <div class="text-4xl text-end">
                                <v-icon icon="mdi-domain" class="border-2 rounded-full pa-10"></v-icon>
                            </div>
                        </v-col>
                    </v-row>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card color="green-darken-3" variant="flat" class="px-6 py-8">
                    <v-row class="justify-center">
                        <v-col>
                            <p class="text-6xl font-bold">{{ props.agri_based_total }}</p>
                            <p class="text-sm mt-2">Agri-based enterprises</p>
                        </v-col>
                        <v-col>
                            <div class="text-4xl text-end">
                                <v-icon icon="mdi-sprout-outline" class="border-2 rounded-full pa-10"></v-icon>
                            </div>
                        </v-col>
                    </v-row>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card color="green-darken-4" variant="flat" class="px-6 py-8">
                    <v-row class="justify-center">
                        <v-col>
                            <p class="text-6xl font-bold">{{ props.non_agri_based_total }}</p>
                            <p class="text-sm mt-2">Non agri-based enterprises</p>
                        </v-col>
                        <v-col>
                            <div class="text-4xl text-end">
                                <v-icon icon="mdi-book-open-variant-outline" class="border-2 rounded-full pa-10"></v-icon>
                            </div>
                        </v-col>
                    </v-row>
                </v-card>
            </v-col>
        </v-row>
    </div>
</template>