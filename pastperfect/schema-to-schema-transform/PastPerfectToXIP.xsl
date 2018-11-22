<xsl:stylesheet version="1.0"
                xmlns:xip="http://www.tessella.com/XIP/v4"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:pp="http://www.preservica.com/pastperfect/v1"
				xmlns:xs="http://www.w3.org/1999/XSL/Transform"
        >
	<!-- PastPerfect generic (all 4 variants) transform to XIP. Copied from contentDM. -->
	
	
    <xsl:output method="xml" indent="yes"/>
    <xsl:preserve-space elements="*"/>
    <xsl:template match="/">
        <XIP xmlns="http://www.tessella.com/XIP/v4">
            <DeliverableUnits>
                <xsl:for-each select="*/export | */reportdata">
                    <xsl:variable name="deliverableUnitRef" select="generate-id()"/>
                    <xsl:variable name="duTitle" select="objectid"/>
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
                        <Metadata schemaURI="http://www.preservica.com/pastperfect/v1">
							<pp:PastPerfectMetadata>
                                <xsl:for-each select="*">
                                    <xsl:call-template name="addMetadataField"/>
                                </xsl:for-each>
							</pp:PastPerfectMetadata>
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
                    </Manifestation>
                </xsl:for-each>
            </DeliverableUnits>
            <Files>
				<!-- Files are filled in later from the cross reference file -->
            </Files>
        </XIP>
    </xsl:template>

    <xsl:template name="addMetadataField">
        <xsl:variable name="metadataelement" select="current()"/>
        <xsl:variable name="elementname" select="local-name()"/>
		<xsl:if test="$metadataelement != ''">
			<xsl:element name="pp:{$elementname}">
				<xsl:value-of select="$metadataelement"/>
			</xsl:element>
		</xsl:if>
    </xsl:template>

</xsl:stylesheet>

