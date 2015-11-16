import pyrax

def init_pyrax():
    pyrax.set_setting("identity_type", "rackspace")
    pyrax.set_credential_file('credentials.conf')
