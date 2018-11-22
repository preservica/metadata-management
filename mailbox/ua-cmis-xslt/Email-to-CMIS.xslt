<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert Preservica email metadata to Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  Because the email metadata schema does not define any substructure, this
  transform does not create any sub-groups by default; each element is transformed to an item
  within a single group element, for example:
  
  <group>
    <title>Email Metadata</title>
    <item>
      <name>From</name>
      <value>J. Doe</value>
    </item>
    <item>
      <name>Subject</name>
      <value>Email Title</value>
    </item>
    ...
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:e="http://www.tessella.com/mailbox/v1"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="e">

  <xsl:output method='xml' indent='yes'/>
  
  <!--
    This template matches the root element of the email metadata.
    A single group element is output, with the title 'Dublin Core Metadata'.
    Sub-elements are then added within the group (see next
    template definition).
  -->
  <xsl:template match="e:email">
    <group>
      <title>Email Metadata</title>
      <xsl:apply-templates />
    </group>
  </xsl:template>

  <!--
    This template matches relevant elements defined in the email metadata schema.
    For each matching element it outputs an item element: the name is the local name
    of the element (with the 1st letter capitalised), and the value is the
    value of the element.
	
	Note thatnot all fields defined in the schema are transformed by default.
    
    For example, the email element:
    
      <subject>Test</subject>
      
    will be transformed to:
    
      <item>
        <name>Subject</name>
        <value>Test</value>
        <type>email.email_subject</type>
      </item>
      
      The 'type' field should be the name of the field in a custom search indexer. The names
      returned in this transform will work with the sample indexer provided.
  -->
  <xsl:template match="e:to|e:from|e:cc|e:bcc|e:date|e:subject|e:size|e:priority|e:importance">
    <item>
      <name><xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/></name>
      <value><xsl:value-of select="."/></value>
      <type><xsl:value-of select="concat('email.email_', lower-case(local-name()))"/></type>
    </item>
  </xsl:template>

</xsl:stylesheet>
