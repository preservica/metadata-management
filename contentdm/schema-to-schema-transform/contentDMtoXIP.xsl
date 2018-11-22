<xsl:stylesheet version="1.0"
                xmlns:xip="http://www.tessella.com/XIP/v4"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xs="http://www.w3.org/1999/XSL/Transform"
        >

    <xsl:output method="xml" indent="yes"/>
    <xsl:preserve-space elements="*"/>
    <xsl:template match="/">
        <XIP xmlns="http://www.tessella.com/XIP/v4">
            <DeliverableUnits>
                <xsl:for-each select="metadata/record">
                    <xsl:variable name="deliverableUnitRef" select="generate-id()"/>
                    <xsl:variable name="duTitle" select="title"/>
                    <DeliverableUnit status="new">
                        <DeliverableUnitRef>
                            <xsl:value-of select="$deliverableUnitRef"/>
                        </DeliverableUnitRef>
                        <CatalogueReference>
                            <xsl:value-of select="$duTitle"/>
                        </CatalogueReference>
                        <ScopeAndContent>
                            <xsl:value-of select="$duTitle"/>
                        </ScopeAndContent>
                        <Title>
                            <xsl:value-of select="$duTitle"/>
                        </Title>
                        <TypeRef>1</TypeRef>
                        <Metadata schemaURI="http://purl.org/dc/elements/1.1/">
                            <dc xmlns="http://purl.org/dc/elements/1.1/">
                                <xsl:for-each select="contributor|coverage|creator|date|description|format|identifier|language|publisher|relation|rights|source|subject|title|type">
                                    <xsl:call-template name="addDCMetadata"/>
                                </xsl:for-each>
                            </dc>
                        </Metadata>
                    </DeliverableUnit>
                    <!--Internally generated ids used later and replaced with longer UUIDs-->
                    <!--Because each element will generate the same id these can be re-made later for referencing-->
                    <xsl:variable name="manifestationMasterRef" select="generate-id()"/>

                    <Manifestation status="new">
                    <DeliverableUnitRef><xsl:value-of select="$deliverableUnitRef"/></DeliverableUnitRef>
                    <ManifestationRef><xsl:value-of select="$manifestationMasterRef"/></ManifestationRef>
                    <ManifestationRelRef>1</ManifestationRelRef>
                    <Originality>true</Originality>
                    <Active>true</Active>
                    <!--Copies all structure/page elements-->
                    <xsl:if test="structure">
                        <xsl:for-each select="structure/page">
                            <xsl:call-template name="addmanifestationfile">
                                <xsl:with-param name="fileMasterRef" select="generate-id(.)"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                        <!--Copies files saved only at the record level-->
                        <xsl:if test="count(structure/page) = 0">
                        <xsl:call-template name="addmanifestationfile">
                            <xsl:with-param name="fileMasterRef" select="generate-id(.)"/>
                        </xsl:call-template>
                    </xsl:if>
                    </Manifestation>
                </xsl:for-each>
            </DeliverableUnits>
            <Files>
                <xsl:for-each select="metadata/record">
                    <xsl:variable name="duId" select="identifier"/>

                    <!--Copies all structure/page elements-->
                    <xsl:if test="structure/page">
                        <xsl:for-each select="structure/page">
                            <xsl:call-template name="addtypefile">
                                <xsl:with-param name="fileMasterRef" select="generate-id(.)"/>
                                <xsl:with-param name="pagemetadata" select="pagemetadata/contributor | pagemetadata/coverage | pagemetadata/creator | pagemetadata/date | pagemetadata/description | pagemetadata/identifier | pagemetadata/language | pagemetadata/publisher | pagemetadata/relation | pagemetadata/rights | pagemetadata/source | pagemetadata/subject | pagemetadata/title | pagemetadata/type"/>
                                <xsl:with-param name="fileName" select="concat($duId, '_', pagetitle)"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                    <!--Copies files saved only at the record level-->
                    <xsl:if test="count(structure/page) = 0">
                        <xsl:call-template name="addtypefile">
                            <xsl:with-param name="fileMasterRef" select="generate-id(.)"/>
                            <xsl:with-param name="pagemetadata" select="contributor|coverage|creator|date|description|identifier|language|publisher|relation|rights|source|subject|title|type"/>
                            <xsl:with-param name="fileName" select="$duId"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </Files>
        </XIP>
    </xsl:template>

    <xsl:template name="addmanifestationfile">
        <xsl:param name="fileMasterRef"/>
        <ManifestationFile xmlns="http://www.tessella.com/XIP/v4" status="new">
            <FileRef>
                <xsl:value-of select="$fileMasterRef"/>
            </FileRef>
            <Path>/</Path>
        </ManifestationFile>
    </xsl:template>

    <xsl:template name="addtypefile">
        <xsl:param name="fileMasterRef"/>
        <xsl:param name="pagemetadata"/>
        <xsl:param name="fileName"/>
        <File xmlns="http://www.tessella.com/XIP/v4" status="new">
            <FileRef>
                <xsl:value-of select="$fileMasterRef"/>
            </FileRef>
            <WorkingPath>/</WorkingPath>
            <FileName>
                <xsl:value-of select="$fileName"/>
            </FileName>
            <Extant>true</Extant>
            <Directory>false</Directory>
            <Metadata schemaURI="http://purl.org/dc/elements/1.1/">
                <dc xmlns="http://purl.org/dc/elements/1.1/">
                    <xsl:for-each select="$pagemetadata">
                        <xsl:call-template name="addDCMetadata"/>
                    </xsl:for-each>
                    <dc:format></dc:format>
                </dc>
            </Metadata>
        </File>
    </xsl:template>

    <xsl:template name="addDCMetadata">
        <xsl:variable name="metadataelement" select="current()"/>
        <xsl:variable name="elementname" select="local-name()"/>
        <xsl:element name="dc:{$elementname}">
            <xsl:value-of select="$metadataelement"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

