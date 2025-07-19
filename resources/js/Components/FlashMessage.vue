<template>
  <transition name="fade">
    <div
      v-if="visible"
      :class="[
        'fixed top-6 right-6 z-50 px-4 py-2 rounded shadow-lg text-sm',
        type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white'
      ]"
    >
      {{ message }}
    </div>
  </transition>
</template>

<script setup>
import { ref, watch } from 'vue'
import { usePage } from '@inertiajs/vue3'

const page = usePage()
const message = ref(null)
const type = ref('success')
const visible = ref(false)

watch(
  () => page.props.flash,
  (flash) => {
    if (flash.success) {
      message.value = flash.success
      type.value = 'success'
      showToast()
    } else if (flash.error) {
      message.value = flash.error
      type.value = 'error'
      showToast()
    }
  },
  { immediate: true }
)

function showToast() {
  visible.value = true
  setTimeout(() => {
    visible.value = false
    message.value = null
  }, 5000)
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
