<template>
    <v-text-field
        density="compact"
        label="Search"
        prepend-inner-icon="mdi-magnify"
        variant="solo-filled"
        flat
        hide-details
        single-line
        class="border"
        :style="{
            minWidth: '200px',
            width: $vuetify.display.smAndDown ? '100%' : '300px',
        }"
    ></v-text-field>
</template>
