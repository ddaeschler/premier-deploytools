#!/usr/bin/env python
import pyrax
import common
import sys

def _print_server_info(server):
    pubIp = None
    privIp = None

    #look for v4 addresses
    for ip in server.networks['public']:
        if "." in ip:
            pubIp = ip

    for ip in server.networks['private']:
        if "." in ip:
            privIp = ip

    print "ID: ", server.id
    print "Status: ", server.status
    print "Admin password: ", server.adminPass

    if pubIp:
        print "Public IP: ", pubIp

    if privIp:
        print "Private IP: ", privIp


def main(argv):
    argLen = len(argv)

    if (argLen < 3):
        print "Usage: create-server.py NAME FLAVOR_ID IMAGE_NAME [ADDNL_VOLUME_NAME] [ADDNL_VOLUME_SIZE]"
        return 1

    name = argv[0]
    flavorId = argv[1]
    imageName = argv[2]
    addnlVolumeName = None
    addnlVolumeSize = None

    if argLen > 4:
        addnlVolumeName = argv[3]
        addnlVolumeSize = argv[4]

    common.init_pyrax()

    cs = pyrax.cloudservers

    #find the image the user wants to use
    foundImage = None
    for image in cs.list_images():
        if image.name == imageName:
            foundImage = image

    if not foundImage:
        print "Could not locate image " + imageName
        return 2

    if not name:
        print "Server name cannot be blank"
        return 3

    server = cs.servers.create(name, foundImage.id, flavorId)
    fullServer = pyrax.utils.wait_for_build(server)
    _print_server_info(fullServer)

    if addnlVolumeName:
        cbs = pyrax.cloud_blockstorage
        vol = cbs.create(name=addnlVolumeName, size=addnlVolumeSize, volume_type="SSD")
        pyrax.utils.wait_for_build(vol)
        vol.attach_to_instance(server, mountpoint="/dev/xvdb")

    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
