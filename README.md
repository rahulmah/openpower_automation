#openpower-automation

Quickstart
----------

To run openpower-automation first you need to install the prerequisite python
packages which will help to invoke tests through tox.

Install the python dependencies for tox
```shell
    $ easy_install tox==2.1.1
    $ easy_install pip
```

Initilize the following environment variable which will used while testing
```shell
    $ export OPENPOWER_HOST=<openbmc machine ip address>
    $ export OPENPOWER_PASSWORD=<openbmc username>
    $ export OPENPOWER_USERNAME=<openbmc password>

```

Run tests
```shell
    $ tox -e tests
```

How to test individual test
```shell
    One specific test
    $ tox -e custom -- -t '"DIMM0 no fault"' tests/test_sensors.robot

    No preset environment variables, one test case from one test suite
    $ OPENPOWER_HOST=x.x.x.x tox -- -t '"DIMM0 no fault"' tests/test_sensors.robot

    No preset environment variables, one test suite
    $ OPENPOWER_HOST=x.x.x.x tox -- tests/test_sensors.robot

    No preset environment variables, the entire test suite
    $ OPENPOWER_HOST=x.x.x.x tox -- tests
```

It can also be run by pasing variables from the cli...
```shell
    $  pybot -v OPENPOWER_HOST:<ip> -v OPENPOWER_USERNAME:root -v OPENPOWER_PASSWORD:0penBmc
```

python -m robot -v OPENPOWER_HOST:hostname -v OPENPOWER_USERNAME:username -v OPENPOWER_PASSWORD:password -v OPENPOWER_LPAR:lpar_host tests

