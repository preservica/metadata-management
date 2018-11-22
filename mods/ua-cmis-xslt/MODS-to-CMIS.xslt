<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert Metadata Object Description Schema (MODS) metadata to
  Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  This transform creates groups for the MODS record information element, a second group for the
  items for the remaining MODS elements, and a third group if there are any MODS note elements in
  the original MODS metadata. The resulting Preservica CMIS metadata is of the form:
  
  <group>
    <title>Metadata Object Description - Record Information</title>
    <item>
      <name>Record Identifier</name>
      <value>archives/cushman/P07803</value>
	  <type>mods.recordIdentifier</type>
    </item>
    <item>
      <name>Record Origin</name>
      <value>Indiana University</value>
	  <type>recordOrigin</type>
    </item>
    ...
  </group>
  <group>
    <title>Metadata Object Description</title>
    <item>
      <name>Title</name>
      <value>Telescope Peak from Zabriskie Point</value>
	  <type>mods.title</type>
    </item>
    <item>
      <name>Creator Name</name>
      <value>Charles Weever</value>
	  <type>creatorName</type>
    </item>
    ...
  </group>
  <group>
    <title>Metadata Object Description - Notes</title>
    <item>
      <name>Note 1</name>
      <value>Addtional note text...</value>
	  <type>noteDescription</type>
    </item>
    <item>
      <name>Note 2</name>
      <value>Addtional note text...</value>
	  <type>noteDescription</type>
    </item>
    ...
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="mods">

  <xsl:output method='xml' indent='yes'/>

  <!--
    This template matches the root element of the MODS metadata.
    It outputs a group for the contained MODS reordInfo element,
    followed by up to fifteen items, depending on the contained
    MODS elements, as listed. If there is at least one MODS note
    element, a third group is created containing an item for each
    note.
  -->
  <xsl:template match="mods:mods">
    <xsl:apply-templates select="mods:recordInfo"/>
    <group>
      <title>Metadata Object Description</title>
      <xsl:apply-templates select="mods:titleInfo/mods:title"><xsl:with-param name="name">Title</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:name[mods:role/mods:roleTerm[text()='Creator']]/mods:namePart"><xsl:with-param name="name">Creator Name</xsl:with-param><xsl:with-param name="type">creatorName</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:typeOfResource"><xsl:with-param name="name">Type of Resource</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:originInfo/mods:dateCreated"><xsl:with-param name="name">Date Created</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:originInfo/mods:dateOther"><xsl:with-param name="name">Date Accumulated</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:language/mods:languageTerm"><xsl:with-param name="name">Language</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:physicalDescription/mods:extent"><xsl:with-param name="name">Extent and Media</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:physicalDescription/mods:form"><xsl:with-param name="name">Physical Form</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:physicalDescription/mods:note[@type='arrangement']"><xsl:with-param name="type">noteArragement</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:accessCondition[@type='access']"><xsl:with-param name="name">Conditions Governing Access</xsl:with-param><xsl:with-param name="type">accessConditionAccess</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:accessCondition[@type='use']"><xsl:with-param name="name">Conditions Governing Reproduction</xsl:with-param><xsl:with-param name="type">accessConditionUse</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:subject/mods:topic"><xsl:with-param name="name">Scope and Content</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:relatedItem[@type='host']"><xsl:with-param name="type">relatedItemHost</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:location/mods:physicalLocation[@type='original']"><xsl:with-param name="type">physicalLocation</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:relatedItem[@type != 'host']"><xsl:with-param name="type">relatedItemNotHost</xsl:with-param></xsl:apply-templates>
    </group>
    <xsl:if test="count(mods:note) &gt; 0">
      <group>
        <title>Metadata Object Description - Notes</title>
        <xsl:apply-templates select="mods:note"><xsl:with-param name="type">noteDescription</xsl:with-param></xsl:apply-templates>
      </group>
    </xsl:if>
  </xsl:template>

  <!--
    This template matches the MODS recordInfo element.
    It outputs a group containing up to four items, depending on the
    contained MODS elements, as listed.
  -->
  <xsl:template match="mods:recordInfo">
    <group>
      <title>Metadata Object Description - Record Information</title>
      <xsl:apply-templates select="mods:recordIdentifier"><xsl:with-param name="name">Record Identifier</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:recordOrigin"><xsl:with-param name="name">Record Origin</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:recordCreationDate"><xsl:with-param name="name">Record Creation Date</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="mods:descriptionStandard"><xsl:with-param name="name">Description Standard</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches various MODS elements, as listed in the match attribute.
    It outputs an item element: the name is passed in as a parameter of the template,
    and the value is the value of the MODS element.
  -->
  <xsl:template match="mods:recordIdentifier|mods:recordOrigin|mods:recordCreationDate|mods:descriptionStandard|mods:title|mods:typeOfResource
                       |mods:dateCreated|mods:dateOther|mods:languageTerm|mods:extent|mods:form|mods:topic">
    <xsl:param name="name"/>
    <item>
      <name><xsl:value-of select="$name"/></name>
      <value><xsl:value-of select="text()"/></value>
	  <type><xsl:value-of select="concat('mods.', local-name())"/></type>
    </item>
  </xsl:template>
  
  <xsl:template match="mods:namePart|mods:accessCondition">
    <xsl:param name="name"/>
	<xsl:param name="type"/>
    <item>
      <name><xsl:value-of select="$name"/></name>
      <value><xsl:value-of select="text()"/></value>
	  <type><xsl:value-of select="concat('mods.', $type)"/></type>
    </item>
  </xsl:template>

  <!--
    This template matches the MODS note and physicalLocation elements.
    It outputs an item element: if the MODS element has a displayLabel attribute,
    its value is used as the name, otherwise the name passed in as a parameter of
    the template is used. The value is the value of the MODS element.
  -->
  <xsl:template match="mods:note|mods:physicalLocation">
    <xsl:param name="name"/>
	<xsl:param name="type"/>
    <item>
      <name>
        <xsl:choose>
          <xsl:when test="string-length(@displayLabel) &gt; 0">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name"/>
          </xsl:otherwise>
        </xsl:choose>
      </name>
      <value><xsl:value-of select="text()"/></value>
	  <type><xsl:value-of select="concat('mods.', $type)"/></type>
    </item>
  </xsl:template>

  <!--
    This template matches the MODS relatedItem element.
    It outputs an item element: if the MODS element has a displayLabel attribute,
    its value is used as the name, otherwise the name passed in as a parameter of
    the template is used. The value is the value of the descendent MODS title element.
  -->
  <xsl:template match="mods:relatedItem">
    <xsl:param name="name"/>
	<xsl:param name="type"/>
    <item>
      <name>
        <xsl:choose>
          <xsl:when test="string-length(@displayLabel) &gt; 0">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name"/>
          </xsl:otherwise>
        </xsl:choose>
      </name>
      <value><xsl:value-of select="mods:titleInfo/mods:title/text()"/></value>
	  <type><xsl:value-of select="concat('mods.', $type)"/></type>
    </item>
  </xsl:template>

</xsl:stylesheet>
