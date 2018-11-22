<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xip="http://www.tessella.com/XIP/v4" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="xip">

 <xsl:output method="xml" indent="yes"/>
 
 <xsl:template match="/">
  <records>
   <xsl:for-each select="/xip:XIP/xip:Collections/xip:Collection">
    <record>
     <metadata>
      <dc:title><xsl:value-of select="xip:Title" /></dc:title>
      <dc:type>Collection</dc:type>
      <dc:identifier><xsl:value-of select="xip:CollectionRef" /></dc:identifier>
      <xsl:if test="xip:ParentRef">
       <dc:relation><xsl:value-of select="xip:ParentRef" /></dc:relation>
      </xsl:if>
     </metadata>
    </record>   
   </xsl:for-each>
   <xsl:for-each select="/xip:XIP/xip:DeliverableUnits/xip:DeliverableUnit">
    <record>
     <metadata>
      <dc:title><xsl:value-of select="xip:Title" /></dc:title>
      <dc:type>DeliverableUnit</dc:type>
      <dc:identifier><xsl:value-of select="xip:DeliverableUnitRef" /></dc:identifier>
      <xsl:if test="xip:CoverageFrom">
       <xsl:if test="xip:CoverageTo">
        <dc:coverage>
         <xsl:value-of select="xip:CoverageFrom"/>
         <xsl:text> - </xsl:text>
         <xsl:value-of select="xip:CoverageTo"/>
        </dc:coverage>
       </xsl:if>
      </xsl:if>
      <xsl:if test="xip:ParentRef">
       <dc:relation>
        <xsl:text>ParentDeliverableUnit: </xsl:text>
        <xsl:value-of select="xip:ParentRef" />
       </dc:relation>
      </xsl:if>
      <xsl:if test="xip:CollectionRef">
       <dc:relation>
        <xsl:text>Collection: </xsl:text>
        <xsl:value-of select="xip:CollectionRef" />
       </dc:relation>
      </xsl:if>
     </metadata>
    </record>
   </xsl:for-each>
   <xsl:for-each select="/xip:XIP/xip:DeliverableUnits/xip:Manifestation">
    <record>
     <metadata>
      <dc:type>Manifestation</dc:type>
      <dc:identifier><xsl:value-of select="xip:ManifestationRef" /></dc:identifier>
      <dc:relation><xsl:value-of select="xip:DeliverableUnitRef" /></dc:relation>
     </metadata>
    </record>
   </xsl:for-each>
  </records>
 </xsl:template>
 
 <xsl:template match="*"/>
</xsl:stylesheet>
