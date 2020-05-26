

## Runner

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
