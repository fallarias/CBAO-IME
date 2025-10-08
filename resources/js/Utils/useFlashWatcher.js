import { watch } from "vue";
import Swal from "sweetalert2";
import { router, usePage } from "@inertiajs/vue3";

export function useFlashWatcher(redirectRoute = null) {
    const page = usePage();

    watch(
        () => page.props.flash,
        (flash) => {
            if (flash?.success) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: flash.success,
                    confirmButtonColor: "#3085d6",
                    didOpen: () => {
                        const confirmBtn = Swal.getConfirmButton();
                        if (confirmBtn) confirmBtn.style.color = "white";
                    },
                }).then(() => {
                    if (redirectRoute) {
                        router.get(route(redirectRoute));
                    }
                });
            } if (flash?.info) {
                Swal.fire({
                    icon: "info",
                    title: "Info",
                    text: flash.info,
                    confirmButtonColor: "#3085d6",
                    didOpen: () => {
                        const confirmBtn = Swal.getConfirmButton();
                        if (confirmBtn) confirmBtn.style.color = "white";
                    },
                }).then(() => {
                    if (redirectRoute) {
                        router.get(route(redirectRoute));
                    }
                });
            } if (flash?.warning) {
                Swal.fire({
                    icon: "warning",
                    title: "Warning",
                    text: flash.warning,
                    confirmButtonColor: "#3085d6",
                    didOpen: () => {
                        const confirmBtn = Swal.getConfirmButton();
                        if (confirmBtn) confirmBtn.style.color = "white";
                    },
                }).then(() => {
                    if (redirectRoute) {
                        router.get(route(redirectRoute));
                    }
                });
            } else if (flash?.error) {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: flash.error,
                    confirmButtonColor: "#d33",
                    didOpen: () => {
                        const confirmBtn = Swal.getConfirmButton();
                        if (confirmBtn) confirmBtn.style.color = "white";
                    },
                });
            }
        },
        { immediate: true }
    );
}