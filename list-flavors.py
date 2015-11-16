import pyrax
import common

common.init_pyrax()

cs = pyrax.cloudservers

for flav in cs.list_flavors():
    print flav.id + ": " + flav.name
