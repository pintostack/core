
## Dependencies

* Ansible >= 1.9

## Variables

Here is a list of all the default variables for this role, which are also available in `defaults/main.yml`.

```
# swap file path
swap_file_path: /swapfile
# swap file size (512M, 1G)
swap_file_size: 512M
# Configures how often your system swaps data out of RAM to the
# swap space. This is a value between 0 and 100 that represents a percentage
swap_swappiness: 10
# This setting configures how much the system will
# choose to cache inode and dentry information over other data
swap_vfs_scache_pressure: 50
```

## Handlers

These are the handlers that are defined in `handlers/main.yml`.

* `restart swap`

## Example playbook

```
- hosts: all
  sudo: yes
  roles:
    - franklinkim.swap
  vars:
    swap_file_size: 512M
```


## License
Copyright (c) We Are Interactive under the MIT license.
