# Who is Bestest?

This web-site will show the bestest people on Github. Just copy the
repository link and see who is the most active on this repo, optionally
you can send them their personal certificates of being the bestest.

## Application structure

* `app/controllers/web_controller.rb` - all the main app logic
  - `index` - just show the home page
  - `show` - show the search query results
  - `download` - download a specified certificate
  - `download_all` - download all certificates in a zip
* `app/libs/api/github/rest.rb` - library for retrieving the most active contributors
  of the given Github repository
* `app/libs/pdf/certificate.rb` - library for creating PDF certificates for contributors
* `spec/` - all the tests in the world

## Technology stack

* [Ruby on Rails] - most popular Ruby web-framework out there
* [Prawn] - PDF generating library
* [Rest-client] - library to send REST requests

[Ruby on Rails]: https://github.com/rails/rails
[Prawn]: https://github.com/prawnpdf/prawn
[Rest-client]: https://github.com/rest-client/rest-client

## Prerequisites

* Ruby v2.5+

* Docker (optionally)

## Deployment
For Heroku:

* Set `GITHUB_OAUTH_TOKEN` environment variable to your token that can
  be acquired [here][1]. It is used to increase per hour requests from
  60 for anonymous users up to 5000 and requires no checkboxes to be
  checked when setting. If not set or set incorrectly, defaults to
  anonymous usage.

* Choose heroku/ruby buildpack

* Deploy

[1]: https://github.com/settings/tokens

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
