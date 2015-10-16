DESCRIPTION = "Some utils for demos"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRC_URI = "file://kill-screen-saver.sh \
           file://x11vnc-startup.sh \
           "

S = "${WORKDIR}"

do_install() {
    install -d ${D}/${ROOT_HOME}
    install -m 0755 ${S}/kill-screen-saver.sh ${D}/${ROOT_HOME}
    install -m 0755 ${S}/x11vnc-startup.sh ${D}/${ROOT_HOME}
}

FILES_${PN} = "${ROOT_HOME}/*"
