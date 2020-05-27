

## Supported targets
Configuration targets can be files of type `.yml`, `.yaml` and `.json`


## Runner
**SetupRunner** is the piece that is used to execute rules. It provides to the user a step-by-step process.

### Simple usage

```rb
setup = SetupFile.from_file! '../setup-file.json'
runner = SetupRunner.new setup
runner.run
```

SetupRunner class exposes an extension api to customize the setup process.

### Hooks
- `before_rule` invoked when the rule is ready to run. Can be used to modify rule properties.
- `after_rule` invoked when after rule execution. Can be used to perform advanced validations.
```rb
#
# Advanced rule customization
# Set rule option based on a http response.
#
runner.before_rule do |rule, request_skip|
  # request_skip can be used to skip current rule
  if rule.id === 'step-select-version'
    ruby_versions = open(ruby_stable_versions).read.split("\n")
    rule.options.select_options = ruby_versions
  end
end
```

```rb
#
# Advanced response validation.
# Checks connection to the server. 
#
runner.after_rule do |rule, result, request_redo|
  if rule.id === 'step-server-ip'
    ping_success = system("ping -c 1 -t 1 #{result}  > /dev/null")
    request_redo.call if (ping_success == false) &&
                         Prompt.new.yes?('Server not responding. Re-enter ip-adress?')
  end
end
```

### Yielded run

```rb
# Setup definitions
enviroment = 'development'
setup_file = SetupFile.from_file! '../setup-file.json'

# Top level Configurator object, abstract serializers;
# creates an in-memory configuration object based on  
# configuration files and the current environment
configurator = Configurator.new (setup_file.files, enviroment)

# Top level Runner object, abstract rule-strategies;
runner = SetupRunner.new setup_file

# Invoking the method passing a block;
# Iterate over completed rules
runner.run do |rule|
    # if rule has a write clause
    # appends data to file target
    configurator.write(rule)
end

# Write files based on environment
configurator.save()


```


### SetupFile
In-memory representation of _setup file_.
```rb
setupObject.meta # Setup Metadata Object
setupObject.rules # Setup Rules Array
setupObject.files # Setup Target Files Array
```

### SetupRule
Define when and how to configure certain fields.
```rb
setupRule.id # Rule Id
setupRule.execute # Execute condition
setupRule.type # Rule Type 
setupRule.title # Rule Title
setupRule.options # Specific rule options (choices, allowEmpty...)
setupRule.write # Write rule result to config files
```

### SetupTarget
Define setup target files
```rb
setupFile.env # Associate file with an specific environment
setupFile.path # Path to file
setupFile.alias # File alias;Used in read or write commands
```

### SetupMeta
Metadata about setup file
```rb
setupMeta.fileVersion # SetupFile version
setupMeta.appVersion # Application version
setupMeta.name # Applicaiton name
setupMeta.description # App description
setupMeta.asciiArt # enable ascii art
```
