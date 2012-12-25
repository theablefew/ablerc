ablerc
======

Add "rc" capabilities into your ruby libraries

Installation
------

```ruby
gem 'ablerc'
```

Usage
------

Add an ablerc.rb file to the root of your project. 

If you use the option DSL you will be able to generate stub rc files and validate option values. However, you're free to 
simply provide an `rc_file_name` and any option defined in that rc file will be available to you. 

The scheme will control how your application's options are loaded and in what order.

```ruby
Ablerc.setup do 
  # The name of the file to be used for the configuration of this app
  # Include a dot if you expect hidden file behavior. 
  rc_file_name = '.ablerc'
  
  # Describes the order in which configuration files are loaded. 
  # Default is <tt>:global</tt>, <tt>:user</tt>, <tt>:local</tt> which 
  # will search for <tt>rc_file_name</tt> in these directories:
  #   /etc/.ablerc
  #   ~/.ablerc
  #  ./.ablerc
  #
  # Configuration options cascade and override previously loaded options. 
  scheme :global, :user, :local
  
  # Describe the options available
  # 
  # ==== Parameters
  # * <tt>name</tt>  - A valid name for the option
  # * <tt>behaviors</tt>  - Behaviors used to for this option
  # * <tt>block</tt>   - A proc that should be run against the option value.
  # ==== Options
  # * <tt>allow</tt>  - The option value must be in this list
  # * <tt>boolean</tt>  - The option will accept <tt>true</tt>, <tt>false</tt>, <tt>0</tt>, <tt>1</tt>
  option :username, :description => "Your github username", :disabled => true
  option :color, :allow => [:red, :green, :blue], :default => :red
  option :save_on_exit, :boolean
  option :seven_digit_number do |number|
    number =~ ^\d{7}$
  end
  option :memory_limit, :default => '10G', :description => 'If memory usage exceeds 10G the internet reboots'
end
```

Accessing Configuration Options
----------
Options defined in the rc file are accessed through the `#configuration` method. All uncommented key-pair values within the rc file are parsed and made available through `#configuration` (or the alias `#config`), regardless of if you're using
the options DSL to define specific options. 


```ruby
Ablerc.configuration.username 
#=> "esmarkowski"

Ablerc.configuration 
#=> {username: 'esmarkowski', color: 'red', save_on_exit: true, seven_digit_number: '1234567'}
```

Options DSL
----------

### option(:name, behaviors = {})

| Option Behaviors | Description |
| ------------ | ------------ |
| `:allow`  | An array of valid values. |
|  `:refuse` | An array of invalid values. |
|  `:boolean` | Only allows option to accept true, false, 1 or 0 |
|  `:default` | The default value of this option |
|  `:description` | Printed above the option as a comment |
|  `:disabled`  | Controls if option is commented out in rc file |


Providing Stub Configuration Files
----------
If you're using the option DSL you can expose `Ablerc.stub.generate` via
a rake task. `Ablerc.stub.generate` 
accepts an optional scheme argument if you wish to place the rc file in a specific context. 

```ruby
namespace :your_app do
  task :stub
    Ablerc.stub.generate :local
  end
end
```

Running this task will place your rc file in the local context (`./.ablerc`) and describe available options.

```conf
# Your github username.
#username = ''

# color accepts :red, :blue or :green
#color = 'red'

# save_on_exit accepts true, false, 1 or 0
#save_on_exit = false

#seven_digit_number = ''

# If memory usage exceeds 10G the internet reboots
memory_limit = 10G
```

License
-------
MIT License. Copyright 2012 The Able Few, LLC. http://theablefew.com
