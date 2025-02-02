# Project Resource Definition SOP

## Overview
This SOP defines the procedure for defining Custom Configuration Files for Project Resources in the PIFSC Resource Inventory (PRI) database as well as removing the resource definitions.  The Git Info Module (GIM) parses these configuration files to load project resource information into the PRI database.  

## Resources
-   [GIM Documentation](./PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md)
-   [PRI Database Documentation](../../docs/PIFSC%20Resource%20Inventory%20Database%20Documentation.md)
-   [Add or Remove Project SOP](../../docs/PIFSC%20Resource%20Inventory%20-%20Add%20or%20Remove%20Project%20SOP.md)

## Procedure
-   ### Defining Resources
    -   Copy the [PRI.config.template.txt](../../docs/PRI.config.template.txt) template file to the root directory of your project's repository
        -   Rename the file to PRI.config
    -   Use the [data_generator_template.xlsx](../../docs/data_generator_template.xlsx) to define the information for your project's resource(s) by filling out the columns with the corresponding information.  
        -   \*\*Note: The column comments provide guidance on what the acceptable/desired values are for each column
    -   Copy the corresponding resource information from the "JSON generator" column and paste it into the PRI.config file between the enclosing brackets ([])
        -   For projects with multiple resources each value enclosed with curly braces ({}) must be delimited by a comma character (,)
        -   An example [PRI.config](../../PRI.config) file is defined for the PRI project that has multiple resources defined
        -   A JSON schema ([json_schema.json](../../docs/json_schema.json)) is available to validate the generated JSON configuration file
    -   Commit the PRI.config file and push the change to the version control server
-   ### Removing Resources
    -   Remove the PRI.config file from the root directory of the repository, commit and push the change to the version control server
