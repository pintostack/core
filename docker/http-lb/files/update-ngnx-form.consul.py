#!/usr/bin/env python
"""
config generator
-----------------------------------
This script will generate an nginx configuration for a containers running in pintostack with the Jinja2 template engine.
"""
import jinja2
import json
import os
import sys


parameter_file = "/files/json-cache/running/default-consul.json"
template_file = "/files/nginx-upstream.conf.j2"
output_directory = "/etc/nginx/sites-enabled"

class Node(object):
    def __init__(self, name, size=None):
        self.name = name
        self.children = []
        self.size = size

    def child(self, cname, size=None):
        child_found = [c for c in self.children if c.name == cname]
        if not child_found:
            _child = Node(cname, size)
            self.children.append(_child)
        else:
            _child = child_found[0]
        return _child

    def as_dict(self):
        res = {'name': self.name}
        if self.size is None:
            res['node'] = [c.as_dict() for c in self.children]
        else:
            res['info'] = self.size
        return res

if __name__ == "__main__":
    root = Node('root')
    # create Jinja2 template environment with the link to the current directory
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="."),
                             trim_blocks=True,
                             lstrip_blocks=True)
    # load template file
    template = env.get_template(template_file)
    # just make sure that the output directory exists
    if not os.path.exists(output_directory):
        os.mkdir(output_directory)
    print("Load common parameter set and define vhosts...")
    nodes = json.load(open(parameter_file))
    root.child("ngnxPort",str(sys.argv[1]))
    root.child("nodes",nodes)
    # create the templates for all vhosts
    print("Create templates for all vhosts...")
    result = template.render(root.as_dict())
    f = open(os.path.join(output_directory, "default_site"), "w")
    f.write(result)
    f.close()
    print("DONE: New configuration created")
