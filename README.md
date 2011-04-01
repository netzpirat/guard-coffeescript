# Guard::CoffeeScript

Guard::CoffeeScript compiles you CoffeeScripts automatically when files are modified. It is tested on Ruby 1.8.7 & 1.9.2.

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-coffeescript

Add it to your `Gemfile`, preferably inside the development group:

    gem 'guard-coffeescript'

Add guard definition to your `Guardfile` by running this command:

    guard init coffeescript

## JSON

The json library is also required but is not explicitly stated as a gem dependency. If you're on Ruby 1.8 you'll need
to install the json or json_pure gem. On Ruby 1.9, json is included in the standard library.

## CoffeeScript

Guard::CoffeeScript uses [Ruby CoffeeScript](http://github.com/josh/ruby-coffee-script/) to compile the CoffeeScripts,
that in turn uses [ExecJS](https://github.com/sstephenson/execjs) to pick the best runtime to evaluate the JavaScript.

### node.js

Please refer to the [CoffeeScript documentation](http://jashkenas.github.com/coffee-script/) for more information about
how to install the latest CoffeeScript version on node.js.

### JavaScript Core

JavaScript Core is only available on Mac OS X. To use JavaScript Core you don't have to install anything, because
JavaScript Core is packaged with Mac OS X.

### V8

To use CoffeeScript on V8, simple add `therubyracer` to your Gemfile. The Ruby Racer acts as a bridge between Ruby
and the V8 engine, that will be automatically installed by the Ruby Racer.

    group :development do
      gem 'therubyracer'
    end

### Mozilla Rhino

If you're using JRuby, you can embed the Mozilla Rhino runtime by adding `therubyrhino` to your Gemfile:

    group :development do
      gem 'therubyrhino'
    end

### Microsoft Windows Script Host

[Microsoft Windows Script Host](http://msdn.microsoft.com/en-us/library/9bbdkx3k.aspx) is available on any Microsoft
Windows operating systems.

## Usage

Please read the [Guard usage documentation](http://github.com/guard/guard#readme).

## Guardfile

Guard::CoffeeScript can be adapted to all kind of projects. Please read the
[Guard documentation](http://github.com/guard/guard#readme) for more information about the Guardfile DSL.

### Standard ruby gems

    guard 'coffeescript' do
      watch(%r{coffeescripts/(.+\.coffee)})
    end

### Rails app

    guard 'coffeescript', :output => 'public/javascripts/compiled' do
      watch(%r{app/coffeescripts/(.+\.coffee)})
    end


## Options

There following options can be passed to Guard::CoffeeScript:

    :output => 'javascripts'            # Relative path to the output directory
    :bare => true                       # Compile without the top-level function wrapper
    :shallow => true                    # Do not create nested output directories

### Nested directories

The guard detects by default nested directories and creates these within the output directory. The detection is based on the match of the watch regular expression:

A file

    /app/coffeescripts/ui/buttons/toggle_button.coffee

that has been detected by the watch

    watch(%r{app/coffeescripts/(.+\.coffee)})

with an output directory of

    :output => 'public/javascripts/compiled'

will be compiled to

    public/javascripts/compiled/ui/buttons/toggle_button.js


Note the parenthesis around the `.+\.coffee`. This enables guard-coffeescript to place the full path that was matched inside the parenthesis into the proper output directory.

This behaviour can be switched off by passing the option `:shallow => true` to the guard, so that all JavaScripts will be compiled directly to the output directory.

## Development

- Source hosted at [GitHub](http://github.com/netzpirat/guard-coffeescript)
- Report issues/Questions/Feature requests on [GitHub Issues](http://github.com/netzpirat/guard-coffeescript/issues)

Pull requests are very welcome! Make sure your patches are well tested.

## Acknowledgment

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](http://github.com/guard) avaiable for making the Guard ecosystem
so much growing and comprehensive.

## License

(The MIT License)

Copyright (c) 2010 - 2011 Michael Kessler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

