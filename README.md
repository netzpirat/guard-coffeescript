# Guard::CoffeeScript

![travis-ci](http://travis-ci.org/netzpirat/guard-coffeescript.png)

Guard::CoffeeScript compiles or validates your CoffeeScripts automatically when files are modified.

Tested on MRI Ruby 1.8.7, 1.9.2 and the latest versions of JRuby & Rubinius.

If you have any questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard`
(irc.freenode.net).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed.

Install the gem:

```bash
$ gem install guard-coffeescript
```

Add it to your `Gemfile`, preferably inside the development group:

```ruby
gem 'guard-coffeescript'
```

Add guard definition to your `Guardfile` by running this command:

```bash
$ guard init coffeescript
```

## JSON

The JSON library is also required but is not explicitly stated as a gem dependency. If you're on Ruby 1.8 you'll need
to install the `json` or `json_pure` gem. On Ruby 1.9, JSON is included in the standard library.

## CoffeeScript

Guard::CoffeeScript uses [Ruby CoffeeScript](https://github.com/josh/ruby-coffee-script/) to compile the CoffeeScripts,
that in turn uses [ExecJS](https://github.com/sstephenson/execjs) to pick the best runtime to evaluate the JavaScript.

### node.js

Please refer to the [CoffeeScript documentation](http://jashkenas.github.com/coffee-script/) for more information about
how to install the latest CoffeeScript version on node.js.

### JavaScript Core

JavaScript Core is only available on Mac OS X. To use JavaScript Core you don't have to install anything, because
JavaScript Core is packaged with Mac OS X.

### V8

To use CoffeeScript on V8, simple add `therubyracer` to your `Gemfile`. The Ruby Racer acts as a bridge between Ruby
and the V8 engine, that will be automatically installed by the Ruby Racer.

```ruby
group :development do
  gem 'therubyracer'
end
```

### Mozilla Rhino

If you're using JRuby, you can embed the Mozilla Rhino runtime by adding `therubyrhino` to your `Gemfile`:

```ruby
group :development do
  gem 'therubyrhino'
end
```

### Microsoft Windows Script Host

[Microsoft Windows Script Host](http://msdn.microsoft.com/en-us/library/9bbdkx3k.aspx) is available on any Microsoft
Windows operating systems.

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Guardfile

Guard::CoffeeScript can be adapted to all kind of projects. Please read the
[Guard documentation](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

### Standard Ruby gem

In a custom Ruby project you want to configure your `:input` and `:output` directories.

```ruby
guard 'coffeescript', :input => 'coffeescripts', :output => 'javascripts'
```

If your output directory is the same as the input directory, you can simply skip it:

```ruby
guard 'coffeescript', :input => 'javascripts'
```

### Rails app with the asset pipeline

With the introduction of the [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) in Rails 3.1 there is
no need to compile your CoffeeScripts with this Guard. However if you like to have instant validation feedback
(preferably with a Growl notification) directly after you save a change, then you may want to skip the generation
of the output file:

```ruby
guard 'coffeescript', :input => 'app/assets/javascripts', :noop => true
```

This give you a faster compilation feedback compared to making a subsequent request to your Rails application. If you
just want to be notified when an error occurs you can hide the success compilation message:

```ruby
guard 'coffeescript', :input => 'app/assets/javascripts', :noop => true, :hide_success => true
```

### Rails app without the asset pipeline

Without the asset pipeline you just define an input and output directory like within a normal Ruby project:

```ruby
guard 'coffeescript', :input => 'app/coffeescripts', :output => 'public/javascripts',
```

## Options

There following options can be passed to Guard::CoffeeScript:

```ruby
:input => 'coffeescripts'           # Relative path to the input directory.
                                    # A suffix `/(.+\.coffee)` will be added to this option.
                                    # default: nil

:output => 'javascripts'            # Relative path to the output directory.
                                    # default: the path given with the :input option

:noop => true                       # No operation: do not write an output file.
                                    # default: false

:bare => true                       # Compile without the top-level function wrapper.
                                    # Provide either a boolean value or an Array of filenames.
                                    # default: false

:shallow => true                    # Do not create nested output directories.
                                    # default: false

:hide_success => true               # Disable successful compilation messages.
                                    # default: false
```

### Output short notation

In addition to the standard configuration, this Guard has a short notation for configure projects with a single input
and output directory. This notation creates a watcher from the `:input` parameter that matches all CoffeeScript files
under the given directory and you don't have to specify a watch regular expression.

```ruby
guard 'coffeescript', :input => 'javascripts'
```

### Selective bare option

The `:bare` option can take a boolean value that indicates if all scripts should be compiled without the top-level
function wrapper.

```ruby
:bare => true
```

But you can also pass an Array of filenames that should be compiled without the top-level function wrapper. The path of
the file to compile is ignored, so the list of filenames should not contain any path information:

```ruby
:bare => %w{ a.coffee b.coffee }
```

In the above example, all `a.coffee` and `b.coffee` files will be compiled with option `:bare => true` and all other
files with option `:bare => false`.

### Nested directories

The Guard detects by default nested directories and creates these within the output directory. The detection is based on
the match of the watch regular expression:

A file

```bash
/app/coffeescripts/ui/buttons/toggle_button.coffee
```

that has been detected by the watch

```ruby
watch(%r{^app/coffeescripts/(.+\.coffee)$})
```

with an output directory of

```ruby
:output => 'public/javascripts/compiled'
```

will be compiled to

```bash
public/javascripts/compiled/ui/buttons/toggle_button.js
```

Note the parenthesis around the `.+\.coffee`. This enables Guard::CoffeeScript to place the full path that was matched
inside the parenthesis into the proper output directory.

This behavior can be switched off by passing the option `:shallow => true` to the Guard, so that all JavaScripts will be
compiled directly to the output directory.

### Multiple source directories

The Guard short notation

```ruby
guard 'coffeescript', :input => 'app/coffeescripts', :output => 'public/javascripts/compiled'
```

will be internally converted into the standard notation by adding `/(.+\.coffee)` to the `input` option string and
create a Watcher that is equivalent to:

```ruby
guard 'coffeescript', :output => 'public/javascripts/compiled' do
  watch(%r{^app/coffeescripts/(.+\.coffee)$})
end
```

To add a second source directory that will be compiled to the same output directory, just add another watcher:

```ruby
guard 'coffeescript', :input => 'app/coffeescripts', :output => 'public/javascripts/compiled' do
  watch(%r{lib/coffeescripts/(.+\.coffee)})
end
```

which is equivalent to:

```ruby
guard 'coffeescript', :output => 'public/javascripts/compiled' do
  watch(%r{app/coffeescripts/(.+\.coffee)})
  watch(%r{lib/coffeescripts/(.+\.coffee)})
end
```

## Development

- Source hosted at [GitHub](https://github.com/netzpirat/guard-coffeescript)
- Report issues and feature requests to [GitHub Issues](https://github.com/netzpirat/guard-coffeescript/issues)

Pull requests are very welcome! Make sure your patches are well tested.

For questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard`
(irc.freenode.net).

## Contributors

* [Aaron Jensen](https://github.com/aaronjensen)
* [Andrew Assarattanakul](https://github.com/vizjerai)
* [Jeremy Raines](https://github.com/jraines)
* [Patrick Ewing](https://github.com/hoverbird)

## Acknowledgment

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](https://github.com/guard) available for making the Guard ecosystem
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

