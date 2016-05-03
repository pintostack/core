from charms.reactive import when, when_not, set_state


@when_not('hdfsdn4pintostack.installed')
def install_hdfsdn4pintostack():
    # Do your setup here.
    #
    # If your charm has other dependencies before it can install,
    # add those as @when() clauses above., or as additional @when()
    # decorated handlers below
    #
    # See the following for information about reactive charms:
    #
    #  * https://jujucharms.com/docs/devel/developer-getting-started
    #  * https://github.com/juju-solutions/layer-basic#overview
    #
    set_state('hdfsdn4pintostack.installed')
