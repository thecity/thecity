# The City Ruby Gem

[![Gem Version](https://badge.fury.io/rb/thecity.png)](http://badge.fury.io/rb/thecity)
[![Dependency Status](https://gemnasium.com/thecity/thecity.png)](https://gemnasium.com/thecity/thecity)
[![Build Status](https://travis-ci.org/thecity/thecity.png?branch=master)](https://travis-ci.org/thecity/thecity)
[![Coverage Status](https://coveralls.io/repos/thecity/thecity/badge.png?branch=master)](https://coveralls.io/r/thecity/thecity?branch=master)

A Ruby interface to the The City API. For more information about The City platform, see [http://api.onthecity.org][api info]

[api info]: http://api.onthecity.org

## Installation
    gem install thecity

## Configuration
The City API requires you to authenticate via OAuth, so you'll need to
register your application with The City under the Admin | API panel.

Your new application will be assigned a key/secret pair (app_id/app_secret). You'll need
to configure these values before you make a request or else you'll get the
error:

    Bad Authentication data

You can pass configuration options as a block to `TheCity::API::Client.new`.

```ruby
client = TheCity::API::Client.new do |config|
  config.app_id        = "YOUR_APP_ID"
  config.app_secret    = "YOUR_APP_SECRET"
  config.access_token  = "OAUTH_ACCESS_TOKEN"
end
```

or

```ruby
client = TheCity::API::Client.new
client.app_id        = "YOUR_APP_ID"
client.app_secret    = "YOUR_APP_SECRET"
client.access_token  = "OAUTH_ACCESS_TOKEN"
```

Alternately, you can set the following environment variables:

    THECITY_APP_ID
    THECITY_APP_SECRET
    THECITY_ACCESS_TOKEN
    THECITY_SUBDOMAIN

## Usage Examples
All examples require an authenticated TheCity client with a valid access_token. See the section on <a
href="#configuration">configuration</a>.

After configuration, requests can be made like so:

**Get the authenticated user (current user)**

```ruby
client.me
```
**Post a topic**

```ruby
client.post_topic(:group_id => 1234567, :title => 'Mr. Watson, come here', :body => 'I want to see you.')
```
**Fetch the groups the current user belongs to**

```ruby
client.my_groups
```

For more usage examples, please see the full [documentation][].

## Documentation
[http://rdoc.info/github/thecity/thecity][documentation]

[documentation]: http://rdoc.info/github/thecity/thecity

## Announcements
You should [follow @thecity][follow] [and @thecity_status][follow_status] on Twitter for announcements and updates about
this library.

[follow]: https://twitter.com/thecity
[follow_status]: https://twitter.com/thecity_status

## The City Builder API Developer Group
For more in depth discussiong regarding The City app platform and APIs, please join [the 'API' group on Builders][builders group].

[builders group]: https://builders.onthecity.org/groups/api

## Apps Wiki
Does your church or organization use this gem? Add it to the [apps
wiki][apps]!

[apps]: https://github.com/robertleib/thecity/wiki/apps

## Advanced Configuration

### Middleware
The Faraday middleware stack is fully configurable and is exposed as a
`Faraday::Builder` object. You can modify the default middleware in-place:

```ruby
client.middleware.insert_after TheCity::Response::RaiseError, CustomMiddleware
```

A custom adapter may be set as part of a custom middleware stack:

```ruby
client.middleware = Faraday::Builder.new(
  &Proc.new do |builder|
    # Specify a middleware stack here
    builder.adapter :some_other_adapter
  end
)
```

## Contributing to thecity gem

### Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing specs.

[issues]: https://github.com/robertleib/thecity/issues
[gist]: https://gist.github.com/

### Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Preferably, add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Add documentation for your feature or bug fix.
8. Run `bundle exec rake yard`.
9. Commit and push your changes.
10. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Copyright
Copyright (c) 2013 Robert Leib.
See [LICENSE][] for details.

[license]: LICENSE.md
