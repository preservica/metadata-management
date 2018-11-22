# metadata-management

This repository contains examples of XML and XSLT files that can be used to control adding/viewing/editing/indexing of metadata in Preservica

## Getting started

The repository is organised by metadata schema (EAD, MODS, DublinCore, etc..).

Under each metadata schema, the same structure is presented:

* bulk-edit contains examples of XML documents specifying those terms to be white listed or black listed when performing a bulk metadata edit (see [section 8.7 of the System User Guide](https://usergroup.preservica.com/documentation/ce/5.10/html/SystemUserGuide.html#SectionMetadataBulkEdit)).
* custom-indexer contains examples of XML Documents that allows custom metadata fields to be usable as search filters within Preservica Explorer (see [section 11 of the System Administration Guide](https://usergroup.preservica.com/documentation/ce/5.10/html/SystemAdministrationGuide.html#CustomSearchIndices)).
* explorer-viewer-editor contains examples of XML transforms (XSLT files) that control which metadata field are viewable and editable in Preservica Explorer (see [section 5.1.2 of the System Administration Guide](https://usergroup.preservica.com/documentation/ce/5.10/html/SystemAdministrationGuide.html#SectionXMLTransforms)).
* schema-to schema-transform contains examples of XML transforms (XSLT files) that transform from the specified metadata schema to another metadata schema. These transforms can be used when exporting packages out of Preservica in a non-XIP schema (see [section 5.1.2 of the System Administration Guide](https://usergroup.preservica.com/documentation/ce/5.10/html/SystemAdministrationGuide.html#SectionXMLTransforms)).
* ua-cmis-xslt contains examples of XML transforms (XSLT files) that control the metadata fields to display in universal access (see [section 7.2 of the Getting Started with Universal Access Guide](https://usergroup.preservica.com/documentation/Other%20Documentation/Technical/Getting%20Started%20with%20Universal%20Access.pdf)).
* xml-fragment-template contains examples of XML documents that can be used to provide a standard template to add blocks of additional metadata to an object in Preservica Explorer (see [section 5.1.3 of the System Administration Guide](https://usergroup.preservica.com/documentation/ce/5.10/html/SystemAdministrationGuide.html#XMLDocuments)).


## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

We recommend that you use the XML/XSLT files contributed by Preservica as starting point for your customisation.

Ensure that you follow the repository structure when submitting new files. 

Files contributed should include inline comments as well as a short description at the top explaining how the file differentiate from other contributed files in the same section. The same comment should be added to the pull request.

## Deployment

Simply download the XML/XSLT file of your choice and upload it onto your Preservica instance via Administration > Schema Management  

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Support

Support for this project is provided by its community of contributors. Preservica Ltd/Inc does not officially support any of the code included in this project. Users can choose to use any code included in this project at their own risk.
