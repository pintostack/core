#!/usr/bin/env python
"""
config generator
-----------------------------------
This script will generate an nginx configuration for a containers running in pintostack with the Jinja2 template engine.
"""
import jinja2
import json
import os

parameter_file = "/files/json-cache/running/default-consul.json"
template_file = "/files/nginx-upstream.conf.j2"
output_directory = "/etc/nginx/sites-enabled"

if __name__ == "__main__":
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
    # create the templates for all vhosts
    print("Create templates for all vhosts...")
    result = template.render(nodes=nodes)
    # print result
    f = open(os.path.join(output_directory, "default_site"), "w")
    f.write(result)
    f.close()
    print("DONE: New configuration created")
