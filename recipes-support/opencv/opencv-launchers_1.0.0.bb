DESCRIPTION = "OpenCV example launchers"
LICENSE = "MIT"
DEPENDS = "opencv"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRC_URI = "file://smile-det.desktop \
           file://face-det.desktop \
           file://bgfg.desktop \
           file://morphology.desktop \
           file://mser.desktop \
           file://skintone.desktop \
           file://motion.desktop \
           file://delaunay.desktop \
           file://farneback.desktop \
           file://polar.desktop \
           file://cannyedge.desktop \
           file://facedet-ex.desktop \
           file://framework.desktop \
           file://linedetection.desktop \
           file://motiondetection.desktop \
           file://opticalflow.desktop \
           "

S = "${WORKDIR}"

do_install() {
    install -d ${D}/${datadir}/applications
    install -m 0644 ${S}/smile-det.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/face-det.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/bgfg.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/morphology.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/mser.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/skintone.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/motion.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/farneback.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/polar.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/cannyedge.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/facedet-ex.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/framework.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/linedetection.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/motiondetection.desktop ${D}/${datadir}/applications
    install -m 0644 ${S}/opticalflow.desktop ${D}/${datadir}/applications
}
