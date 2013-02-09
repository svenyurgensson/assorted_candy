## Assorted Candy (aka: All Sorts Of Staff)

This is a collection of Ruby extensions and utilities I've been carting around from project to project.
Some are taken from the Facets project (I just don't want to include that whole gem in my codebases).
Others gathered from blog posts, repositories and snippets founded in the web.
This is not something kind of valid gem though.

## Usage

The library does not automatically require anything, so you can pick and choose which extensions get added, by requiring them individually, e.g.:

    require 'null_object/null_object'
    require 'core/multi_block'

and so on.

My own approach where to place this library in rails project:

    app/
    config/
    db/
    gems/
        assorted_candy/ # <-- here
    ...

and require it in my Gemfile as:

    gem 'assorted_candy', path: 'gems/assorted_candy'

As you can see I just clone this repository into project's tree and treat it as ordinary
library. Don't miss that you should explicitely require particular ruby files.

## Cautions

Some of established minilibs adds a method(s) to Kernel which might be considered bad practice.
So use it wisely.

## Contribute

I would appreciate any participation in the project. Any additions, fixes and ideas are welcome!

### How to contribute:

* Fork the project on Github
* Create a topic branch for your changes
* Ensure that the changes in your branch are as atomic as possible
* Create a pull request on Github

### License

This ruby gem is under MIT License. Copyright 2013 Yury Batenko jurbat@gmail.com
