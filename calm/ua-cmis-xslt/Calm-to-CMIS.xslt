<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert CALM Catalogue metadata to Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  This transform creates a single group for the CALM metadata, and contains two items,
  the CALM RefNo and the CALM Title. The resulting Preservica CMIS metadata is of the form:
  
  <group>
    <title>Catalogue</title>
    <item>
      <name>Reference Number</name>
      <value>100/200/300/ref</value>
	  <type>cakn.CalmRefNo</type>
    </item>
    <item>
      <name>Title</name>
      <value>Catalogue item title</value>
	  <type>calm.CalmTitle</type>
    </item>
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:catalogue="http://www.tessella.com/catalogue/calm/v1"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="catalogue">

  <xsl:output method='xml' indent='yes'/>

  <!--
    This template matches the root element of the CALM metadata.
    It outputs a group for the metadata, and then two contained items.
  -->
  <xsl:template match="catalogue:catalogue">
    <group>
        <title>Catalogue</title>
        <xsl:apply-templates select="catalogue:RefNo"><xsl:with-param name="name">Reference Number</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="catalogue:Title"><xsl:with-param name="name">Title</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches two CALM metadata elements, as listed in the match attribute.
    It outputs an item element: the name is passed in as a parameter of the template,
    and the value is the value of the CALM element.
  -->
  <xsl:template match="catalogue:RefNo|catalogue:Title">
    <xsl:param name="name"/>
    <item>
      <name><xsl:value-of select="$name"/></name>
      <value><xsl:value-of select="text()"/></value>
	  <type><xsl:value-of select="concat('calm.Calm', local-name())"/></type>
    </item>
  </xsl:template>

</xsl:stylesheet>
