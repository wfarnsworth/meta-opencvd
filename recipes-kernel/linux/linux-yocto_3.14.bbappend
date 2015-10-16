FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://linux-add-printk.patch \
            file://add-boot-delay.cfg"
