import pyrax
import common

common.init_pyrax()

cs = pyrax.cloudservers

for image in cs.list_images():
    print image.id + ": " + image.name
