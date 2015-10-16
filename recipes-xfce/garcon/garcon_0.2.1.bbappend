FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Add a menu category
SRC_URI += "file://xfce-opencv.directory \
            file://xfce-applications.menu"

do_install_append() {
    cp ${WORKDIR}/xfce-applications.menu ${D}/${sysconfdir}/xdg/menus
    cp ${WORKDIR}/xfce-opencv.directory ${D}/${datadir}/desktop-directories
}
