<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert Simple Dublin Core metadata to Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  Because the Simple Dublin Core metadata schema does not define any substructure, this
  transform does not create any sub-groups by default; each DC element is transformed to an item
  within a single group element, for example:
  
  <group>
    <title>Dublin Core Metadata</title>
    <item>
      <name>Creator</name>
      <value>J. Doe</value>
    </item>
    <item>
      <name>Publisher</name>
      <value>Preservica Ltd.</value>
    </item>
    ...
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="oai_dc dc">

  <xsl:output method='xml' indent='yes'/>
  
  <!--
    This template matches the root element of the Dublin Core metadata.
    Since the Simple DC schema does not define a single root element,
    this template matches two commonly-used root elements: the dc element
    defined in either the OAI_DC schema, or the Simple DC schema itself.
    A single group element is output, with the title 'Dublin Core Metadata'.
    Other Simple DC elements are then added within the group (see next
    template definition).
  -->
  <xsl:template match="oai_dc:dc|dc:dc">
    <group>
      <title>Dublin Core Metadata</title>
      <xsl:apply-templates>
        <xsl:with-param name="root-ns" select="fn:namespace-uri()"/>
      </xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches all elements defined in the Simple Dublin Core schema.
    For each matching element it outputs an item element: the name is the local name
    of the Simple DC element (with the 1st letter capitalised), and the value is the
    value of the Simple DC element.
    
    For example, the Simple DC element:
    
      <subject>Test</subject>
      
    will be transformed to:
    
      <item>
        <name>Subject</name>
        <value>Test</value>
        <type>oai_dc.subject</type>
      </item>
      
      The 'type' field should be the name of the field in a custom search indexer. The names
      returned in this transform will work with the sample indexer provided. Adjust the value
      if you are using different search index term names. The prefix map works with the raw DC
      metadata and also the OAI wrapped version.
  -->
  <xsl:template match="dc:contributor|dc:coverage|dc:creator|dc:date|dc:description|dc:format|dc:identifier|dc:language|dc:publisher|dc:relation|dc:rights|dc:source|dc:subject|dc:title|dc:type">
    <xsl:param name="root-ns"/>
      <xsl:variable name="prefix">
        <xsl:choose>
          <xsl:when test="$root-ns = 'http://purl.org/dc/elements/1.1/'">dc.</xsl:when>
          <xsl:when test="$root-ns = 'http://www.openarchives.org/OAI/2.0/oai_dc/'">oai_dc.</xsl:when>
          <xsl:otherwise>dc_custom.</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>	
    <item>
      <name><xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/></name>
      <value><xsl:value-of select="."/></value>
      <type><xsl:value-of select="concat($prefix, lower-case(local-name()))"/></type>
    </item>
  </xsl:template>

</xsl:stylesheet>
