<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!--
  Stylesheet to convert Encoded Archival Description (EAD) metadata to
  Preservica simple CMIS metadata format.
  
  The Preservica simple CMIS metadata format defines a root element named metadata.
  This must contain a mandatory title and description element.
  It can then contain zero or more group or item elements:
  
  - an item element must contain a name and value element, and can also contain
    an optional type element,
  - a group element must contain a title element, and then one or more item or group elements
    (i.e. groups can be nested within other groups).
  
  This transform creates groups for the EAD header and the EAD archival description element;
  it also creates a sub-group for the EAD descriptive identification element within the archival
  description element. Other EAD elements are transformed to item elements within the appropriate
  group. The resulting Preservica CMIS metadata is of the form:
  
  <group>
    <title>Encoded Archival Description - Header</title>
    <item>
      <name>Identifier</name>
      <value>terr06</value>
	  <type>ead.eadid</type>
    </item>
    <item>
      <name>Title Proper of the Finding Aid</name>
      <value>MINNESOTA TERRITORIAL ARCHIVES</value>
	  <type>ead.titleproper</type>
    </item>
    ...
  </group>
  <group>
    <title>Encoded Archival Description</title>
    <group>
      <title>Encoded Archival Description - Identification</title>
      <item>
        <name>Unit Title</name>
        <value>Series Records of territorial governor</value>
		<type>ead.didunittitle</type>
      </item>
      <item>
        <name>Accumulation</name>
        <value>1852-1857</value>
		<type>ead.didaccumulation</type>
      </item>
      ...
    </group>
    <item>
      <name>Biography or History</name>
      <value>Full biography...</value>
	  <type>ead.bioghist</type>
    </item>
    <item>
      <name>Custodial History</name>
      <value>Full history...</value>
	  <type>ead.custodhist</type>
    </item>
    ...
  </group>
  
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="ead">

  <xsl:output method='xml' indent='yes'/>

  <!--
    This template matches the root element of the EAD metadata.
    It separately processes the EAD header and EAD archival description elements.
  -->
  <xsl:template match="ead:ead">
    <xsl:apply-templates select="ead:eadheader"/>
    <xsl:apply-templates select="ead:archdesc"/>
  </xsl:template>

  <!--
    This template matches the EAD header element.
    It outputs a group containing up to four items, depending on the contained
    EAD elements, as listed.
  -->
  <xsl:template match="ead:eadheader">
    <group>
      <title>Encoded Archival Description - Header</title>
      <xsl:apply-templates select="ead:eadid"><xsl:with-param name="name">Identifier</xsl:with-param><xsl:with-param name="type">eadid</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:filedesc/ead:titlestmt/ead:titleproper"><xsl:with-param name="name">Title Proper of the Finding Aid</xsl:with-param><xsl:with-param name="type">titleproper</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:profiledesc/ead:creation/ead:date"><xsl:with-param name="name">Creation Date</xsl:with-param><xsl:with-param name="type">creationdate</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:profiledesc/ead:descrules"><xsl:with-param name="name">Descriptive Rules</xsl:with-param><xsl:with-param name="type">descrules</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches the EAD archival description element.
    It outputs a sub-group for the inner EAD descriptive identification element,
    plus a list of up to seventeen items, depending on the contained EAD elements,
    as listed.
  -->
  <xsl:template match="ead:archdesc">
    <group>
      <title>Encoded Archival Description</title>
      <xsl:apply-templates select="ead:did"/>
      <xsl:apply-templates select="ead:bioghist/ead:p"><xsl:with-param name="name">Biography or History</xsl:with-param><xsl:with-param name="type">bioghist</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:custodhist/ead:p"><xsl:with-param name="name">Custodial History</xsl:with-param><xsl:with-param name="type">custodhist</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:acqinfo/ead:p"><xsl:with-param name="name">Acquisition Information</xsl:with-param><xsl:with-param name="type">acqinfo</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:scopecontent/ead:p"><xsl:with-param name="name">Scope and Content</xsl:with-param><xsl:with-param name="type">scopecontent</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:appraisal/ead:p"><xsl:with-param name="name">Appraisal Information</xsl:with-param><xsl:with-param name="type">appraisal</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:accruals/ead:p"><xsl:with-param name="name">Accruals</xsl:with-param><xsl:with-param name="type">accruals</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:arrangement/ead:p"><xsl:with-param name="name">Arrangement</xsl:with-param><xsl:with-param name="type">arrangement</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:accessrestrict/ead:p"><xsl:with-param name="name">Conditions Governing Access</xsl:with-param><xsl:with-param name="type">accessrestrict</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:userestrict/ead:p"><xsl:with-param name="name">Conditions Governing Use</xsl:with-param><xsl:with-param name="type">userestrict</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:phystech/ead:p"><xsl:with-param name="name">Physical Characteristics and Technical Requirements</xsl:with-param><xsl:with-param name="type">physdesc</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:otherfindaid/ead:p"><xsl:with-param name="name">Other Finding Aid</xsl:with-param><xsl:with-param name="type">otherfindaid</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:originalsloc/ead:p"><xsl:with-param name="name">Location of Originals</xsl:with-param><xsl:with-param name="type">originalsloc</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:altformavail/ead:p"><xsl:with-param name="name">Alternative Form Available</xsl:with-param><xsl:with-param name="type">altformavail</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:relatedmaterial/ead:p"><xsl:with-param name="name">Related Material</xsl:with-param><xsl:with-param name="type">relatedmaterial</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:bibliography/ead:p"><xsl:with-param name="name">Bibliography</xsl:with-param><xsl:with-param name="type">bibliography</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:odd/ead:note/ead:p"><xsl:with-param name="name">Other Descriptive Data</xsl:with-param><xsl:with-param name="type">odd</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:processinfo/ead:p"><xsl:with-param name="name">Processing Information</xsl:with-param><xsl:with-param name="type">processinfo</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches the EAD descriptive identification element.
    It outputs a group containing up to six items, depending on the
    contained EAD elements, as listed.
  -->
  <xsl:template match="ead:did">
    <group>
      <title>Encoded Archival Description - Identification</title>
      <xsl:apply-templates select="ead:unittitle"><xsl:with-param name="name">Unit Title</xsl:with-param><xsl:with-param name="type">didunittitle</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:unitdate[@label='Accumulation']"><xsl:with-param name="name">Accumulation</xsl:with-param><xsl:with-param name="type">didaccumulation</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:unitdate[@label='Created']"><xsl:with-param name="name">Created</xsl:with-param><xsl:with-param name="type">didcreated</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:origination[@label='Creator']"><xsl:with-param name="name">Creator</xsl:with-param><xsl:with-param name="type">didorigination</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:physdesc"><xsl:with-param name="name">Physical Description</xsl:with-param><xsl:with-param name="type">didphysdesc</xsl:with-param></xsl:apply-templates>
      <xsl:apply-templates select="ead:langmaterial"><xsl:with-param name="name">Language</xsl:with-param><xsl:with-param name="type">didlanguage</xsl:with-param></xsl:apply-templates>
    </group>
  </xsl:template>

  <!--
    This template matches various EAD elements, as listed in the match attribute.
    It outputs an item element: the name is passed in as a parameter of the template,
    and the value is the value of the EAD element.
  -->
  <xsl:template match="ead:eadid|ead:titleproper|ead:date|ead:descrules|ead:unittitle|ead:unitdate|ead:origination|ead:physdesc|ead:langmaterial|ead:p">
    <xsl:param name="name"/>
	<xsl:param name="type"/>
    <item>
      <name><xsl:value-of select="$name"/></name>
      <value><xsl:value-of select="text()"/></value>
	  <type><xsl:value-of select="concat('ead.', $type)"/></type>
    </item>
  </xsl:template>

</xsl:stylesheet>
