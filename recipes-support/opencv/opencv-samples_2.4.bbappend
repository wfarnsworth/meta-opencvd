do_install_append() {
    install -d ${D}/${datadir}/opencv/samples/data
    install -m 0644 ${S}/data/*/*.xml ${D}/${datadir}/opencv/samples/data/
}

FILES_${PN} += "${datadir}/opencv/samples/data/*.xml"
