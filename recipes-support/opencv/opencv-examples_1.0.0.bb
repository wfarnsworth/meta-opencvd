DESCRIPTION = "OpenCV example programs based on The BDTI Quick-Start files"
HOMEPAGE = "http://www.embedded-vision.com/platinum-members/bdti/embedded-vision-training/documents/pages/OpenCVVMwareImage"
LICENSE = "Proprietary"
DEPENDS = "opencv"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "git://github.com/challinan/opencv-examples.git"
SRCREV = "${AUTOREV}"

EXAMPLE_PROGRAMS = " cannyedgedetect facedetector linedetection motiondetection opticalflow framework"

S = "${WORKDIR}/git"

EXTRA_CXX_MAKE_FLAGS = " \
        -I${STAGING_DIR_TARGET}/opencv2/. \
        -I${STAGING_DIR_TARGET}/opencv2/release \
        -I${STAGING_DIR_TARGET}/opencv2/include \
        -I${STAGING_DIR_TARGET}/opencv2/include/opencv \
        -I${STAGING_DIR_TARGET}/opencv2/modules/core/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/flann/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/imgproc/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/video/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/highgui/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/ml/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/calib3d/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/features2d/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/objdetect/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/legacy/include \
        -I${STAGING_DIR_TARGET}/opencv2/modules/contrib/include "

LXX_FLAGS= " -Wl,-O1 -Wl,--hash-style=gnu \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_core.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_flann.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_imgproc.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_highgui.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_ml.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_video.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_objdetect.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_features2d.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_calib3d.so.3.1.0 \
        ${STAGING_DIR_TARGET}/usr/lib64/libopencv_videoio.so.3.1.0 \
        -ldl -lm -lpthread -lrt -lz"

#        -ldl -lm -lpthread -lrt -lz -Wl,-rpath,${STAGING_DIR_TARGET}/usr/lib64"

do_compile() {
    bbnote "Entering do_compile"
    cd ${S}
    echo "Compiling for ${EXAMPLE_PROGRAMS}"
    for i in ${EXAMPLE_PROGRAMS}; do
        echo "Compiling for $i"
        ${CXX} ${TARGET_CXXFLAGS} ${LXX_FLAGS} ${EXTRA_CXX_MAKE_FLAGS} -o $i $i.cpp 
    done
}

FILES_${PN} = "${bindir}/${PN}/*"
FILES_${PN}-dbg += "${bindir}/${PN}/.debug/*"
#    ${bindir}/${PN}/cannyedgedetect \
#    ${bindir}/${PN}/facedetector \
#    ${bindir}/${PN}/framework \
#    ${bindir}/${PN}/linedetection \
#    ${bindir}/${PN}/motiondetection \
#    ${bindir}/${PN}/opticalflow"

# inherit autotools

do_install() {
    install -d ${D}/${bindir}/${PN}
    for i in ${EXAMPLE_PROGRAMS}; do
        install -m 0755 ${S}/$i ${D}/${bindir}/${PN}
    done
}
