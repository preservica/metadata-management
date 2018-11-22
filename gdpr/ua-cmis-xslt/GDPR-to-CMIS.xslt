<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert Preservica GDPR metadata to Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  Because the Preservica GDPR metadata schema does not define any substructure, this
  transform does not create any sub-groups by default; each GDPR element is transformed to an item
  within a single group element, for example:
  
  <group>
    <title>GDPR Metadata</title>
    <item>
      <name>Personal Data</name>
      <value>Needs Investigation</value>
    </item>
    <item>
      <name>Record Objected</name>
      <value>True</value>
    </item>
    ...
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gdpr="http://www.preservica.com/gdpr/v1"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="gdpr">

  <xsl:output method='xml' indent='yes'/>
  
  <!--
    This template matches the root element of the Preservica GDPR  metadata
  -->
  <xsl:template match="gdpr:gdpr">
    <group>
      <title>Preservica GDPR</title>
	        <xsl:apply-templates select="gdpr:personaldata"><xsl:with-param name="name">Personal Data</xsl:with-param></xsl:apply-templates>
	        <xsl:apply-templates select="gdpr:recordobjected"><xsl:with-param name="name">Record Objected</xsl:with-param></xsl:apply-templates>
	        <xsl:apply-templates select="gdpr:recordobjecteddate"><xsl:with-param name="name">Record Objected Date</xsl:with-param></xsl:apply-templates>
	        <xsl:apply-templates select="gdpr:recipientdisclosurecategory"><xsl:with-param name="name">Category of Recipient Disclosure</xsl:with-param></xsl:apply-templates>
	        <xsl:apply-templates select="gdpr:timelimitforerasure"><xsl:with-param name="name">Time Limit for Erasure</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches all elements defined in the  Preservica GDPR schema.
    For each matching element it outputs an item element: the name is the local name
    of the Preservica GDPR  element (with the 1st letter capitalised), and the value is the
    value of the Preservica GDPR element.
    
    For example, the Preservica GDPR element:
    
      <personaldata>Needs Investigation</personaldata>
      
    will be transformed to:
    
      <item>
        <name>Personal Data</name>
        <value>Needs Investigation</value>
        <type>gdpr.personaldata</type>
      </item>
      
      The 'type' field should be the name of the field in a custom search indexer. The names
      returned in this transform will work with the sample indexer provided. Adjust the value
      if you are using different search index term names. The prefix map works with the raw DC
      metadata and also the OAI wrapped version.
  -->
  <xsl:template match="gdpr:personaldata|gdpr:recordobjected|gdpr:recordobjecteddate|gdpr:recipientdisclosurecategory|gdpr:timelimitforerasure">
    <xsl:param name="name"/>
	<item>
      <name><xsl:value-of select="$name"/></name>
      <value><xsl:value-of select="text()"/></value>
      <type><xsl:value-of select="concat('gdpr.', lower-case(local-name()))"/></type>
    </item>
  </xsl:template>


</xsl:stylesheet>
