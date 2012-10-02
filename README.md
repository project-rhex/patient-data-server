Patient Data Server
=========

This project provides a reference server for the RHEx. It will allow for the creation of patients using HITSP C32
documents and then expose the data in a granular fashion. Clients will be able to retrieve data in HTML, XML and JSON
formats. Finally, this server will restrict access using OAuth and OpenID.

Environment
-----------

This project currently uses Ruby 1.9.3 and is built using [Bundler](http://gembundler.com/). To get all of the
dependencies for the project, first install bundler:

    gem install bundler

Then run bundler to grab all of the necessary gems:

    bundle install

The Patient Data Server relies on a MongoDB [MongoDB](http://www.mongodb.org/) running a minimum of version 2.2.0 or
higher. To get and install MongoDB refer to:

    http://www.mongodb.org/display/DOCS/Quickstart

Getting Started
---------------

There are synthetic sample patients that can be loaded into the server via a rake task

    bundle exec rake hdata:load_c32_files

The server can be run as a typical Ruby on Rails application by running

    bundle exec rails server

License
-------

Copyright 2012 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Project Practices
=================

Please try to follow our [Coding Style Guides](http://github.com/eedrummer/styleguide). Additionally, we will be using
git in a pattern similar to [Vincent Driessen's workflow](http://nvie.com/posts/a-successful-git-branching-model/).
While feature branches are encouraged, they are not required to work on the project.