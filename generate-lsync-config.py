#!/usr/bin/env python

#usage: generate-lsync-config.py ipaddress

from string import Template

def main(argv):
    argLen = len(argv)

    if (argLen < 1):
        print "Usage: generate-lsync-config.py IPADDRESS"
        return 1

    ipaddress = argv[0]

    data = None
    with open ("lsyncd.conf.template", "r") as myfile:
        data = myfile.read()

    tmp = Template(data)

    print tmp.substitute(ipaddress=ipaddress)

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
