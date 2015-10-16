FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# This desktop background file contains AMD and Mentor logos
SRC_URI += "file://xfce-blue.jpg"

# This project's makefiles copy the images
do_install_prepend() {
    echo "Overwriting background image"
    cp ${WORKDIR}/xfce-blue.jpg ${S}/backgrounds
}
