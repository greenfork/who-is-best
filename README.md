# Who is bestest?

This web-site will show the bestest people on Github. Just copy the
repository link and see who is the most active on this repo, optionally
you can send them their personal certificates of being the bestest.

## Prerequisites

* Ruby v2.5+

* Docker (optionally)

## Development
Start developing with this:

``` shell
$ git clone https://github.com/greenfork/who-is-bestest.git
$ cd who-is-bestest
$ bundle --without production
$ rails spec
$ rails server # visit localhost:3000
```

Or you can alternatively use docker:

``` shell
$ git clone https://github.com/greenfork/who-is-bestest.git
$ cd who-is-bestest
$ docker build -t who-is-bestest-img .
$ docker run --rm who-is-bestest-img rspec
$ docker run --rm -it -p 3000:3000 who-is-bestest-img # visit localhost:3000
```

## License

Copyright © 2019 Dmitriy Matveyev

Distributed under the MIT license, see LICENSE file.
