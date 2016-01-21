# (c) 2016, Artyom Astafurov <artyom.astafurov@dataart.com>
#
# Contains helper functions to manipulate strings, lists and maps in context fo jinja2 filters for Ansible
# Distributed under MIT license
#
from __future__ import absolute_import

import collections
import string
from ansible import errors

# Return list produced from string
def split(a, sep):
    res = [str(word) for word in string.split(a,sep)]
    return res

# return zookeeper hosts and ids map from a list of ZK hosts
def to_zk(a):
    res = [{str("host"): str(h), str("id"): i } for i, h in enumerate(a)]
    return res

# return index of string in list
def index_of(a, b):
    return a.index(b)

# del \n from index_of
def del_n(zoo_id):
    return zoo_id.replace("\n","")

class FilterModule(object):
    ''' Ansible jinja2 filters '''

    def filters(self):
        return {
            'split': split,
            'to_zk': to_zk,
            'index_of': index_of,
            'del_n': del_n,
        }
