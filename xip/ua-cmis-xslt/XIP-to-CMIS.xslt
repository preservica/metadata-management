<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert XIP metadata for collections, deliverable units and files to
  Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  This transform creates a root metadata element for the collection / deliverable unit / file
  being transformed. The main element values of the XIP entity are then output as item elements;
  for files, the file properties are put in a group within the main metadata element. If the
  XIP entity contains additional descriptive metadata, this is handled by a separate XSLT transform
  included within this main transform (that typically outputs a group structure for the descriptive
  metadata).
  
  For an XIP collection (containing MODS descriptive metadata in this example), the resulting
  Preservica CMIS metadata is of the form:
  
  <metadata>
    <title>Collection Title</title>
    <description>Collection Code</description>
    <group>
      <title>Metadata Object Description - Record Information</title>
      ...
    </group>
    ...
  </metadata>
  
  For an XIP deliverable unit (containing MODS descriptive metadata in this example), the resulting
  Preservica CMIS metadata is of the form:
  
  <metadata>
    <title>Deliverable Unit Title</title>
    <description>Scope and Content Value</description>
    <item>
      <name>Digital Surrogate</name>
      <value>false</value>
    </item>
    <item>
      <name>Catalogue Reference</name>
      <value>Cat ref value</value>
    </item>
    <item>
      <name>Coverage From</name>
      <value>2007-01-01</value>
    </item>
    <item>
      <name>Coverage To</name>
      <value>2017-12-31</value>
    </item>
    <group>
      <title>Metadata Object Description - Record Information</title>
      ...
    </group>
    ...
  </metadata>
  
  For an XIP file, the resulting Preservica CMIS metadata is of the form:
  
  <metadata>
    <title>example.jpg</title>
    <description>example.jpg</description>
    <item>
      <name>Extant</name>
      <value>true</value>
    </item>
    <item>
      <name>Directory</name>
      <value>false</value>
    </item>
    <item>
      <name>File Size</name>
      <value>156118</value>
    </item>
    <item>
      <name>Last Modified Date</name>
      <value>2015-06-24</value>
    </item>
    <group>
      <title>Properties</title>
      <item>
        <name>Samples Per Pixel</name>
        <value>3</value>
      </item>
      <item>
        <name>Byte Order</name>
        <value>big-endian</value>
      </item>
      ...
    </group>
  </metadata>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xip="http://www.tessella.com/XIP/v4"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:catalogue="http://www.tessella.com/catalogue/calm/v1"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="xip oai_dc dc ead mods catalogue">

  <xsl:output method='xml' indent='yes'/>

  <!-- Root template -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Override default template for text nodes -->
  <xsl:template match="text()|@*"/>

  <!--
    This template matches the XIP Collection element.
    It outputs a metadata element, with the title set to the Collection Title,
    and the description set to the Collection Code. Any remaining elements
    within the XIP Collection are then processed by other templates.
  -->
  <xsl:template match="xip:Collection">
    <metadata>
      <title><xsl:value-of select="xip:Title"/></title>
      <description><xsl:value-of select="xip:CollectionCode"/></description>
      <xsl:apply-templates/>
    </metadata>
  </xsl:template>

  <!--
    This template matches the XIP DeliverableUnit element.
    It outputs a metadata element, with the title set to the DeliverableUnit Title,
    and the description set by calling the template named deliverableUnitDescription
    (see below for details). Any remaining elements within the XIP DeliverableUnit
    are then processed by other templates.
  -->
  <xsl:template match="xip:DeliverableUnit">
    <metadata>
      <title>
        <xsl:value-of select="xip:Title"/>
      </title>
      <description>
        <xsl:call-template name="deliverableUnitDescription">
          <xsl:with-param name="defaultDescription" select="xip:ScopeAndContent"/>
        </xsl:call-template>
      </description>
      <xsl:apply-templates/>
    </metadata>
  </xsl:template>

  <!--
    This template matches the XIP File element.
    It outputs a metadata element; if the XIP File contains a Title element, the title
    and description are set to this value, otherwise they are set to the value of the
    FileName element. Any remaining elements within the XIP File (except for FileProperty
    elements) are then processed by other templates. A separate group (titled Properties)
    is output to contain the transformed FileProperty elements within the File.
  -->
  <xsl:template match="xip:File">
    <metadata>
      <xsl:choose>
        <xsl:when test="xip:Title and not(xip:Title = '')">
          <title><xsl:value-of select="xip:Title"/></title>
          <description><xsl:value-of select="xip:FileName"/></description>
        </xsl:when>
        <xsl:otherwise>
          <title><xsl:value-of select="xip:FileName"/></title>
          <description></description>
        </xsl:otherwise>
      </xsl:choose>
      <group>
        <title>File Details</title>
        <xsl:apply-templates select="*[not(self::xip:FileProperty) and not(self::xip:EmbeddedBitstream) and not(self::xip:Metadata)]"/>
      </group>
      <xsl:apply-templates select="xip:Metadata" />
      <group>
        <title>Properties</title>
        <xsl:apply-templates select="xip:FileProperty"/>
      </group>
    </metadata>
  </xsl:template>

  <!--
    This template matches various XIP elements, as listed in the match attribute.
    It outputs an item element: the name is the local name of the XIP element (with the 
    1st letter capitalised), and the value is the value of the XIP element.
  -->
  <xsl:template match="xip:DigitalSurrogate|xip:Extant|xip:Directory|xip:FileSize|xip:CatalogueReference">
    <item>
      <name><xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/></name>
      <value><xsl:value-of select="."/></value>
	   <type><xsl:value-of select="concat('xip.', lower-case(local-name()))"/></type>
    </item>
  </xsl:template>

  <!--
    This template matches various XIP elements that store date values, as listed in the match attribute.
    It outputs an item element: the name is the local name of the XIP element (with the 1st letter
    capitalised), and the value is the value of the XIP element in ISO8601 date format (yyyy-MM-dd).
  -->
  <xsl:template match="xip:CoverageFrom|xip:CoverageTo|xip:LastModifiedDate">
    <item>
      <name><xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/></name>
      <value><xsl:value-of select="format-dateTime(., '[Y0001]-[M01]-[D01]')"/></value>
	   <type><xsl:value-of select="concat('xip.', lower-case(local-name()))"/></type>
    </item>
  </xsl:template>

  <!--
    This template matches the XIP FileProperty element.
    It outputs an item element: the name is the value of the FilePropertyName element, and the value
    is the value of the XIP Value element.
  -->
  <xsl:template match="xip:FileProperty">
    <item>
      <name><xsl:value-of select="xip:FilePropertyName"/></name>
      <value><xsl:value-of select="xip:Value"/></value>
	   <type>xip.fileproperties</type>
    </item>
  </xsl:template>

  <!--
    This template matches the XIP Identifier element.
    Collection, DeliverableUnit and File elements can optionally contain one or more Identifier elements.
    It outputs an item element: the name is the value of the type attribute of the Identifier element, and
    the value is the value of the XIP Identifier element.
  -->
  <xsl:template match="xip:Identifier">
    <item>
      <name><xsl:value-of select="@type"/></name>
      <value><xsl:value-of select="."/></value>
	   <type><xsl:value-of select="concat('xip.', local-name())"/></type>
    </item>
  </xsl:template>

  <!--
    This is a named template, called from the template that matches the XIP DeliverableUnit element (above).
    It tests for the existence of a number of different descriptive metadata elements from the EAD, MODS and
    Simple Dublin Core schemas: if one of these exists, it is output as the deliverable unit description,
    otherwise the default value, passed in as a parameter of the template, is output instead.
    The <xsl:choose> structure can be extended with additional options if other descriptive metadata schemas
    are used that also contain a potential description field.
  -->
  <xsl:template name="deliverableUnitDescription">
    <xsl:param name="defaultDescription"/>
    <xsl:choose>
      <xsl:when test="xip:Metadata/ead:ead/ead:archdesc/ead:did/ead:unittitle">
        <xsl:value-of select="xip:Metadata/ead:ead/ead:archdesc/ead:did/ead:unittitle"/>
      </xsl:when>
      <xsl:when test="xip:Metadata/mods:mods/mods:titleInfo/mods:title">
        <xsl:value-of select="xip:Metadata/mods:mods/mods:titleInfo/mods:title"/>
      </xsl:when>
      <xsl:when test="xip:Metadata/oai_dc:dc/dc:title">
        <xsl:value-of select="xip:Metadata/oai_dc:dc/dc:title"/>
      </xsl:when>
      <xsl:when test="xip:Metadata/dc:dc/dc:title">
        <xsl:value-of select="xip:Metadata/dc:dc/dc:title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$defaultDescription"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    This template matches the XIP Metadata element.
    Collection, DeliverableUnit and File elements can optionally contain one or more Metadata elements.
    The processing of the descriptive metadata itself is delegated to a separate transform (see below).
  -->
  <xsl:template match="xip:Metadata">
    <xsl:apply-templates/>
  </xsl:template>

  <!--
    Transforms for decsriptive metadata contained within XIP are listed here. An <xsl:include> element
    should be added for any new transforms; note that the name in the href attribute must match the
    name of the file as it is uploaded into Preservica. (Any transforms listed here that are not uploaded
    into Preservica are ignored.)
  -->
  <xsl:include href="DC-to-CMIS.xslt"/>
  <xsl:include href="EAD-to-CMIS.xslt"/>
  <xsl:include href="MODS-to-CMIS.xslt"/>
  <xsl:include href="Calm-to-CMIS.xslt"/>
  <xsl:include href="Email-to-CMIS.xslt"/>
  <xsl:include href="GDPR-to-CMIS.xslt"/>

</xsl:stylesheet>
