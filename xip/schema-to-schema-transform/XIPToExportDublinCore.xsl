<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xip="http://www.tessella.com/XIP/v4" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
                xmlns:exdc="http://www.preservica.com/export/multi-record-dublin-core/v1" exclude-result-prefixes="xip oai_dc">
                
    <!--
        Preservica XIP to Dublin Core Export Transform
        (c) Preservica 2016
        26 The Quadrant
        Abingdon Science Park
        Abingdon
        OX14 3YS
        
        This transform takes each Collection, DeliverableUnit and Manifestation in an XIP document
        and transforms it to a record in the Dublin Core Export Schema.
        
        Appropriate XIP metadata values are mapped to Dublin Core fields, and in addition, any Dublin
        Core metadata in the Generic Metadata is imported in its entirety.
        
        Digital Files are not currently considered by this transform.
    -->
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <exdc:records>
            <xsl:for-each select="/xip:XIP/xip:Collections/xip:Collection">
                <exdc:record>
                    <exdc:metadata>
                        <dc:title><xsl:value-of select="xip:Title" /></dc:title>
                        <dc:type>Collection</dc:type>
                        <dc:identifier><xsl:value-of select="xip:CollectionRef" /></dc:identifier>
                        <xsl:if test="xip:ParentRef">
                            <dc:relation><xsl:value-of select="xip:ParentRef" /></dc:relation>
                        </xsl:if>
                        <xsl:apply-templates select="xip:Metadata/oai_dc:dc|xip:Metadata/dc:dc"/>
                    </exdc:metadata>
                </exdc:record>   
            </xsl:for-each>
            <xsl:for-each select="/xip:XIP/xip:DeliverableUnits/xip:DeliverableUnit">
                <exdc:record>
                    <exdc:metadata>
                        <dc:title><xsl:value-of select="xip:Title" /></dc:title>
                        <dc:type>DeliverableUnit</dc:type>
                        <dc:identifier><xsl:value-of select="xip:DeliverableUnitRef" /></dc:identifier>
                        <dc:description><xsl:value-of select="xip:ScopeAndContent" /></dc:description>
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
                        <xsl:apply-templates select="xip:Metadata/oai_dc:dc|xip:Metadata/dc:dc"/>
                    </exdc:metadata>
                </exdc:record>
            </xsl:for-each>
            <xsl:for-each select="/xip:XIP/xip:DeliverableUnits/xip:Manifestation">
                <exdc:record>
                    <exdc:metadata>
                        <dc:type>Manifestation</dc:type>
                        <dc:identifier><xsl:value-of select="xip:ManifestationRef" /></dc:identifier>
                        <dc:relation><xsl:value-of select="xip:DeliverableUnitRef" /></dc:relation>
                        <xsl:apply-templates select="xip:Metadata/oai_dc:dc|xip:Metadata/dc:dc"/>
                    </exdc:metadata>
                </exdc:record>
            </xsl:for-each>
        </exdc:records>
    </xsl:template>

    <xsl:template match="*"/>

    <xsl:template match="xip:Metadata/oai_dc:dc|xip:Metadata/dc:dc">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="dc:contributor|dc:coverage|dc:creator|dc:date|dc:description|dc:format|dc:identifier|dc:language|dc:publisher|dc:relation|dc:rights|dc:source|dc:subject|dc:title|dc:type">
        <xsl:element name="dc:{name()}">
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="node()[not(self::*)]">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
