<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
                xmlns:xip="http://www.tessella.com/XIP/v4"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:premis="info:lc/xmlns/premis-v2"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:ead="urn:isbn:1-931666-22-9"
                exclude-result-prefixes="fn xdt">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Output MODS descriptive metadata "as is" -->
    <xsl:template match="mods:mods">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Output Dublin Core descriptive metadata as-is -->
    <xsl:template match="dc:*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="oai_dc:*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Output EAD descriptive metadata as-is -->
    <xsl:template match="ead:*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xip:FileProperty">
        <xip:FileProperty>
            <xip:PropertyRef>
                <xsl:value-of select="normalize-space(./xip:PropertyRef)"/>
            </xip:PropertyRef>
            <xip:FilePropertyName>
                <xsl:value-of select="normalize-space(./xip:FilePropertyName)"/>
            </xip:FilePropertyName>
            <xip:Value>
                <xsl:value-of select="normalize-space(./xip:Value)"/>
            </xip:Value>
        </xip:FileProperty>
    </xsl:template>

    <!-- Event template -->
    <xsl:template match="xip:AccessionEvent|xip:IdentificationEvent|xip:ValidationEvent|xip:PropertyExtractionEvent">
        <xsl:param name="identifier"/>
        <xsl:param name="eventType"/>
        <premis:event>
            <premis:eventIdentifier>
                <premis:eventIdentifierType>local</premis:eventIdentifierType>
                <premis:eventIdentifierValue>EVT-<xsl:value-of select="$identifier"/>
                </premis:eventIdentifierValue>
            </premis:eventIdentifier>
            <premis:eventType>
                <xsl:value-of select="$eventType"/>
            </premis:eventType>
            <premis:eventDateTime>
                <xsl:value-of select="normalize-space(./xip:EventDate)"/>
            </premis:eventDateTime>
            <premis:eventOutcomeInformation>
                <premis:eventOutcome>success</premis:eventOutcome>
            </premis:eventOutcomeInformation>
            <premis:linkingAgentIdentifier>
                <premis:linkingAgentIdentifierType>local</premis:linkingAgentIdentifierType>
                <premis:linkingAgentIdentifierValue>AGT-<xsl:value-of select="$identifier"/>
                </premis:linkingAgentIdentifierValue>
            </premis:linkingAgentIdentifier>
        </premis:event>
    </xsl:template>

    <xsl:template match="xip:EventAgent" mode="supplier">
        <xsl:param name="identifier"/>
        <premis:agent>
            <premis:agentIdentifier>
                <premis:agentIdentifierType>local</premis:agentIdentifierType>
                <premis:agentIdentifierValue>AGT-<xsl:value-of select="$identifier"/>
                </premis:agentIdentifierValue>
            </premis:agentIdentifier>
            <premis:agentName>
                <xsl:value-of select="normalize-space(./text())"/>
            </premis:agentName>
            <premis:agentType>supplier</premis:agentType>
        </premis:agent>
    </xsl:template>

    <xsl:template match="xip:EventAgent" mode="software">
        <xsl:param name="identifier"/>
        <premis:agent>
            <premis:agentIdentifier>
                <premis:agentIdentifierType>local</premis:agentIdentifierType>
                <premis:agentIdentifierValue>AGT-<xsl:value-of select="$identifier"/>
                </premis:agentIdentifierValue>
            </premis:agentIdentifier>
            <premis:agentName>
                <xsl:value-of select="normalize-space(./xip:Name)"/><xsl:text> </xsl:text><xsl:value-of
                    select="normalize-space(./xip:Version)"/>
            </premis:agentName>
            <premis:agentType>software</premis:agentType>
        </premis:agent>
    </xsl:template>

    <!-- Template to generate Dublin Core metadata for collections and deliverable units. -->
    <xsl:template name="dublinCoreMetadata">
        <xsl:choose>
            <xsl:when test="self::xip:Collection">
                <dc:title>
                    <xsl:value-of select="xip:Title"/>
                </dc:title>
                <dc:type>Collection</dc:type>
                <dc:identifier>
                    <xsl:value-of select="xip:CollectionRef"/>
                </dc:identifier>
                <xsl:if test="xip:ParentRef">
                    <dc:relation>
                        <xsl:value-of select="xip:ParentRef"/>
                    </dc:relation>
                </xsl:if>
            </xsl:when>
            <xsl:when test="self::xip:DeliverableUnit">
                <dc:title>
                    <xsl:value-of select="xip:Title"/>
                </dc:title>
                <dc:type>DeliverableUnit</dc:type>
                <dc:identifier>
                    <xsl:value-of select="xip:DeliverableUnitRef"/>
                </dc:identifier>
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
                        <xsl:value-of select="xip:ParentRef"/>
                    </dc:relation>
                </xsl:if>
                <xsl:if test="xip:CollectionRef">
                    <dc:relation>
                        <xsl:text>Collection: </xsl:text>
                        <xsl:value-of select="xip:CollectionRef"/>
                    </dc:relation>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Descriptive metadata for a deliverable unit or collection. -->
    <xsl:template name="descriptiveMetadata">
        <xsl:param name="objectId"/>
        <mets:dmdSec>
            <xsl:attribute name="ID">DMD-<xsl:value-of select="normalize-space($objectId)"/>
            </xsl:attribute>
            <mets:mdWrap>
                <xsl:choose>
                    <xsl:when test="./xip:Metadata/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods">
                        <xsl:attribute name="MDTYPE">MODS</xsl:attribute>
                        <mets:xmlData>
                            <xsl:apply-templates
                                    select="./xip:Metadata/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods"/>
                        </mets:xmlData>
                    </xsl:when>
                    <xsl:when test="./xip:Metadata/ead:*">
                        <xsl:attribute name="MDTYPE">EAD</xsl:attribute>
                        <mets:xmlData>
                            <xsl:apply-templates select="./xip:Metadata/ead:*"/>
                        </mets:xmlData>
                    </xsl:when>
                    <xsl:when test="./xip:Metadata/dc:*">
                        <xsl:attribute name="MDTYPE">DC</xsl:attribute>
                        <mets:xmlData>
                            <xsl:apply-templates select="./xip:Metadata/dc:*"/>
                        </mets:xmlData>
                    </xsl:when>
                    <xsl:when test="./xip:Metadata/oai_dc:*">
                        <xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
                        <mets:xmlData>
                            <xsl:apply-templates select="./xip:Metadata/oai_dc:*"/>
                        </mets:xmlData>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- If no descriptive metadata found, make up our own Dublin Core metadata -->
                        <xsl:attribute name="MDTYPE">DC</xsl:attribute>
                        <mets:xmlData>
                            <xsl:call-template name="dublinCoreMetadata"/>
                        </mets:xmlData>
                    </xsl:otherwise>
                </xsl:choose>
            </mets:mdWrap>
        </mets:dmdSec>
    </xsl:template>

    <xsl:template name="accessionAdminMetadata">
        <mets:amdSec>
            <xsl:attribute name="ID">AMD-<xsl:value-of select="normalize-space(./xip:AccessionRef)"/>
            </xsl:attribute>
            <mets:digiprovMD>
                <xsl:attribute name="ID">DIG-<xsl:value-of select="normalize-space(./xip:AccessionRef)"/>
                </xsl:attribute>
                <mets:mdWrap MDTYPE="PREMIS">
                    <mets:xmlData>
                        <premis:premis version="2.0">
                            <!-- Accession object -->
                            <premis:object xsi:type="premis:representation">
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>AccessionRef+</premis:objectIdentifierType>
                                    <premis:objectIdentifierValue><xsl:value-of select="normalize-space(./xip:AccessionRef)"/>:1</premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:preservationLevel>
                                    <premis:preservationLevelValue>digital (other)</premis:preservationLevelValue>
                                </premis:preservationLevel>
                            </premis:object>

                            <!-- Accession event -->
                            <xsl:apply-templates select="./xip:AccessionEvent">
                                <xsl:with-param name="identifier">-AE-<xsl:value-of
                                        select="normalize-space(./xip:AccessionRef)"/>
                                </xsl:with-param>
                                <xsl:with-param name="eventType">accession</xsl:with-param>
                            </xsl:apply-templates>

                            <!-- Accession agent -->
                            <xsl:apply-templates select="./xip:AccessionEvent/xip:EventAgent" mode="supplier">
                                <xsl:with-param name="identifier">-AE-<xsl:value-of
                                        select="normalize-space(./xip:AccessionRef)"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </premis:premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:digiprovMD>
        </mets:amdSec>
    </xsl:template>

    <xsl:template name="manifestationAdminMetadata">
        <mets:amdSec>
            <xsl:attribute name="ID">AMD-<xsl:value-of select="normalize-space(./xip:ManifestationRef)"/></xsl:attribute>
            <mets:digiprovMD>
                <xsl:attribute name="ID">DIG-<xsl:value-of select="normalize-space(./xip:ManifestationRef)"/></xsl:attribute>
                <mets:mdWrap MDTYPE="PREMIS">
                    <mets:xmlData>
                        <premis:premis version="2.0">

                            <!-- Manifestation object -->
                            <premis:object xsi:type="premis:representation">
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>ManifestationRef</premis:objectIdentifierType>
                                    <premis:objectIdentifierValue>
                                        <xsl:value-of select="normalize-space(./xip:ManifestationRef)"/>
                                    </premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:preservationLevel>
                                    <premis:preservationLevelValue>digital (other)</premis:preservationLevelValue>
                                </premis:preservationLevel>

                                <!-- Relationship to parent deliverable unit -->
                                <premis:relationship>
                                    <premis:relationshipType>instantiation</premis:relationshipType>
                                    <premis:relationshipSubType>manifestationOf</premis:relationshipSubType>
                                    <premis:relatedObjectIdentification>
                                        <premis:relatedObjectIdentifierType>DeliverableUnitRef</premis:relatedObjectIdentifierType>
                                        <premis:relatedObjectIdentifierValue>
                                            <xsl:value-of select="normalize-space(./xip:DeliverableUnitRef)"/>
                                        </premis:relatedObjectIdentifierValue>
                                        <premis:relatedObjectSequence>0</premis:relatedObjectSequence>
                                    </premis:relatedObjectIdentification>
                                </premis:relationship>

                                <!-- Relationship to containing submission -->
                                <premis:relationship>
                                    <premis:relationshipType>derivation</premis:relationshipType>
                                    <premis:relationshipSubType>containedInSubmission</premis:relationshipSubType>
                                    <premis:relatedObjectIdentification>
                                        <premis:relatedObjectIdentifierType>AccessionRef</premis:relatedObjectIdentifierType>
                                        <premis:relatedObjectIdentifierValue>
                                            <xsl:value-of select="normalize-space(//xip:Control/xip:AccessionRef)"/>
                                        </premis:relatedObjectIdentifierValue>
                                        <premis:relatedObjectSequence>0</premis:relatedObjectSequence>
                                    </premis:relatedObjectIdentification>
                                </premis:relationship>
                            </premis:object>
                        </premis:premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:digiprovMD>
        </mets:amdSec>
    </xsl:template>

    <xsl:template name="fileAdminMetadata">
        <xsl:param name="includeStreams"/>
        <mets:amdSec>
            <xsl:attribute name="ID">AMD-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:attribute>
            <!-- techMD section for file PREMIS object -->
            <mets:techMD>
                <xsl:attribute name="ID">TECH-<xsl:value-of select="normalize-space(./xip:FileRef)"/>-1</xsl:attribute>
                <mets:mdWrap MDTYPE="PREMIS">
                    <mets:xmlData>
                        <premis:premis version="2.0">
                            <!-- File PREMIS object -->
                            <premis:object xsi:type="premis:file">
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>FileRef</premis:objectIdentifierType>
                                    <premis:objectIdentifierValue>
                                        <xsl:value-of select="normalize-space(./xip:FileRef)"/>
                                    </premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>DOMID</premis:objectIdentifierType>
                                    <!-- <xsl:value-of select="code:getContentDomId(./xip:FileRef)"/> -->
                                    <premis:objectIdentifierValue>DOMID.</premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:objectCharacteristics>
                                    <xsl:choose>
                                        <xsl:when test="./xip:Directory = 'true'">
                                            <premis:compositionLevel>1</premis:compositionLevel>
                                            <premis:format>
                                                <premis:formatDesignation>
                                                    <premis:formatName></premis:formatName>
                                                </premis:formatDesignation>
                                            </premis:format>
                                            <premis:objectCharacteristicsExtension>
                                                <premis:directory>true</premis:directory>
                                            </premis:objectCharacteristicsExtension>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <premis:compositionLevel>1</premis:compositionLevel>
                                            <xsl:for-each select="./xip:FixityInfo">
                                                <premis:fixity>
                                                    <xsl:if test="number(normalize-space(./xip:FixityAlgorithmRef))=1">
                                                        <premis:messageDigestAlgorithm>MD5</premis:messageDigestAlgorithm>
                                                    </xsl:if>
                                                    <xsl:if test="number(normalize-space(./xip:FixityAlgorithmRef))=2">
                                                        <premis:messageDigestAlgorithm>SHA-1</premis:messageDigestAlgorithm>
                                                    </xsl:if>
                                                    <xsl:if test="number(normalize-space(./xip:FixityAlgorithmRef))=3">
                                                        <premis:messageDigestAlgorithm>SHA-256</premis:messageDigestAlgorithm>
                                                    </xsl:if>
                                                    <xsl:if test="number(normalize-space(./xip:FixityAlgorithmRef))=4">
                                                        <premis:messageDigestAlgorithm>SHA-512</premis:messageDigestAlgorithm>
                                                    </xsl:if>
                                                    <premis:messageDigest>
                                                        <xsl:value-of select="normalize-space(./xip:FixityValue)"/>
                                                    </premis:messageDigest>
                                                </premis:fixity>
                                            </xsl:for-each>
                                            <premis:size>
                                                <xsl:value-of select="normalize-space(./xip:FileSize)"/>
                                            </premis:size>
                                            <premis:format>
                                                <premis:formatRegistry>
                                                    <premis:formatRegistryName>PRONOM</premis:formatRegistryName>
                                                    <premis:formatRegistryKey>
                                                        <xsl:value-of
                                                                select="normalize-space(./xip:FormatInfo[1]/xip:FormatPUID)"/>
                                                    </premis:formatRegistryKey>
                                                </premis:formatRegistry>
                                            </premis:format>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </premis:objectCharacteristics>
                                <xsl:variable name="fileRef" select="normalize-space(./xip:FileRef)"/>
                                <!-- TODO Can't we just use the xip:WorkingPath element here?
                                      We need to deal with multiple manifestation having the same fileRef -->
                                <xsl:variable name="pathElements"
                                              select="//xip:ManifestationFile[xip:FileRef/text()=$fileRef]/xip:Path"/>
                                <xsl:variable name="path" select="$pathElements[last()]"/>
                                <premis:originalName>
                                    <xsl:value-of select="$path"/>
                                    <xsl:if test="(string-length($path) > 0) and (substring($path, string-length($path)) != '\') and (substring($path, string-length($path)) != '/')">/</xsl:if>
                                    <xsl:value-of select="normalize-space(./xip:FileName)"/>
                                </premis:originalName>
                            </premis:object>

                            <xsl:if test="number($includeStreams) = 1">
                                <!-- TODO: PREMIS object for each embedded bitstream in file -->
                            </xsl:if>
                        </premis:premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:techMD>

            <!-- techMD section for file properties -->
            <xsl:if test="count(./xip:FileProperty) > 0">
                <mets:techMD>
                    <xsl:attribute name="ID">TECH-<xsl:value-of select="normalize-space(./xip:FileRef)"/>-2</xsl:attribute>
                    <mets:mdWrap MDTYPE="OTHER">
                        <mets:xmlData>
                            <xsl:apply-templates select="./xip:FileProperty"/>
                            <xsl:if test="number($includeStreams) = 1">
                                <!-- TODO: decide on correct handling of properties of embedded bitstreams -->
                            </xsl:if>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:techMD>
            </xsl:if>

            <!-- digiprovMD section for file PREMIS events / agents -->
            <mets:digiprovMD>
                <xsl:attribute name="ID">DIG-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:attribute>
                <mets:mdWrap MDTYPE="PREMIS">
                    <mets:xmlData>
                        <premis:premis version="2.0">

                            <!-- Repeat of (mandatory elements of) file object; required by PREMIS schema -->
                            <premis:object xsi:type="premis:file">
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>FileRef</premis:objectIdentifierType>
                                    <premis:objectIdentifierValue>
                                        <xsl:value-of select="normalize-space(./xip:FileRef)"/>
                                    </premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:objectIdentifier>
                                    <premis:objectIdentifierType>DOMID</premis:objectIdentifierType>
                                    <!-- <xsl:value-of select="code:getContentDomId(./xip:FileRef)"/> -->
                                    <premis:objectIdentifierValue>DOMID.</premis:objectIdentifierValue>
                                </premis:objectIdentifier>
                                <premis:objectCharacteristics>
                                    <premis:compositionLevel>1</premis:compositionLevel>
                                    <premis:format>
                                        <premis:formatDesignation>
                                            <premis:formatName></premis:formatName>
                                        </premis:formatDesignation>
                                    </premis:format>
                                </premis:objectCharacteristics>
                            </premis:object>

                            <!-- Events -->
                            <xsl:apply-templates select="./xip:IdentificationEvent">
                                <xsl:with-param name="identifier">-IE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                                <xsl:with-param name="eventType">formatIdentification</xsl:with-param>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="./xip:ValidationEvent">
                                <xsl:with-param name="identifier">-VE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                                <xsl:with-param name="eventType">validation</xsl:with-param>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="./xip:PropertyExtractionEvent">
                                <xsl:with-param name="identifier">-PEE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                                <xsl:with-param name="eventType">propertyExtraction</xsl:with-param>
                            </xsl:apply-templates>

                            <xsl:if test="number($includeStreams) = 1">
                                <!-- TODO: PREMIS events for each embedded bitstream in file -->
                            </xsl:if>

                            <!-- Agents -->
                            <xsl:apply-templates select="./xip:IdentificationEvent/xip:EventAgent" mode="software">
                                <xsl:with-param name="identifier">-IE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="./xip:ValidationEvent/xip:EventAgent" mode="software">
                                <xsl:with-param name="identifier">-VE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="./xip:PropertyExtractionEvent/xip:EventAgent" mode="software">
                                <xsl:with-param name="identifier">-PEE-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:with-param>
                            </xsl:apply-templates>

                            <xsl:if test="number($includeStreams) = 1">
                                <!-- TODO: PREMIS agents for each embedded bitstream in file -->
                            </xsl:if>
                        </premis:premis>
                    </mets:xmlData>
                </mets:mdWrap>
            </mets:digiprovMD>
        </mets:amdSec>
    </xsl:template>

    <!-- File section -->
    <xsl:template name="fileSec">
        <xsl:param name="includeStreams"/>
        <xsl:if test="count(//xip:Files/xip:File) > 0">
            <mets:fileSec>
                <mets:fileGrp ID="FGRP01" USE="preservation">
                    <xsl:for-each select="//xip:Files/xip:File">
                        <mets:file>
                            <xsl:attribute name="ADMID">AMD-<xsl:value-of select="normalize-space(./xip:FileRef)"/></xsl:attribute>
                            <xsl:attribute name="ID">file<xsl:value-of select="position()"/></xsl:attribute>
                            <xsl:attribute name="SIZE">
                                <xsl:value-of select="normalize-space(./xip:FileSize)"/>
                            </xsl:attribute>
                            <xsl:if test="./xip:Directory != 'true'">
                                <xsl:attribute name="CHECKSUMTYPE">
                                    <xsl:if test="number(normalize-space(./xip:FixityInfo[1]/xip:FixityAlgorithmRef))=1">MD5</xsl:if>
                                    <xsl:if test="number(normalize-space(./xip:FixityInfo[1]/xip:FixityAlgorithmRef))=2">SHA-1</xsl:if>
                                    <xsl:if test="number(normalize-space(./xip:FixityInfo[1]/xip:FixityAlgorithmRef))=3">SHA-256</xsl:if>
                                    <xsl:if test="number(normalize-space(./xip:FixityInfo[1]/xip:FixityAlgorithmRef))=4">SHA-512</xsl:if>
                                </xsl:attribute>
                                <xsl:attribute name="CHECKSUM">
                                    <xsl:value-of select="normalize-space(./xip:FixityInfo[1]/xip:FixityValue)"/>
                                </xsl:attribute>
                            </xsl:if>
                            <mets:FLocat LOCTYPE="OTHER" OTHERLOCTYPE="DOMID" xlink:type="simple">
                                <!-- <xsl:value-of select="code:getContentDomId(./xip:FileRef)"/> -->
                                <xsl:attribute name="xlink:href">DOMID.</xsl:attribute>
                            </mets:FLocat>
                            <xsl:if test="number($includeStreams) = 1">
                                <xsl:for-each select="./xip:EmbeddedBitstream">
                                    <mets:stream>
                                        <xsl:attribute name="streamType">
                                            <xsl:value-of select="./xip:FormatInfo/xip:FormatName"/>
                                        </xsl:attribute>
                                    </mets:stream>
                                </xsl:for-each>
                            </xsl:if>
                        </mets:file>
                    </xsl:for-each>
                </mets:fileGrp>
            </mets:fileSec>
        </xsl:if>
    </xsl:template>

    <!-- Main template -->
    <xsl:template match="/">
        <mets:mets xmlns:mets="http://www.loc.gov/METS/"
                   xmlns:xlink="http://www.w3.org/1999/xlink"
                   xmlns:premis="info:lc/xmlns/premis-v2"
                   xmlns:xip="http://www.tessella.com/XIP/v4"
                   xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/mets.xsd info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-0.xsd">
            <mets:metsHdr>
                <!-- <xsl:attribute name="CREATEDATE"><xsl:value-of select="fn:current-dateTime()"/></xsl:attribute> -->
                <mets:agent ROLE="CREATOR" TYPE="OTHER">
                    <mets:name>XIP to METS transform</mets:name>
                </mets:agent>
            </mets:metsHdr>

            <!-- Descriptive metadata -->
            <xsl:for-each select=".//xip:Collection">
                <xsl:call-template name="descriptiveMetadata">
                    <xsl:with-param name="objectId" select="./xip:CollectionRef"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select=".//xip:DeliverableUnit">
                <xsl:call-template name="descriptiveMetadata">
                    <xsl:with-param name="objectId" select="./xip:DeliverableUnitRef"/>
                </xsl:call-template>
            </xsl:for-each>

            <!-- Administrative metadata: accessions, manifestations and files. -->
            <xsl:for-each select=".//xip:Accession">
                <xsl:call-template name="accessionAdminMetadata"/>
            </xsl:for-each>


            <xsl:for-each select=".//xip:Manifestation">
                <xsl:call-template name="manifestationAdminMetadata"/>
            </xsl:for-each>


            <xsl:for-each select=".//xip:File">
                <xsl:call-template name="fileAdminMetadata"/>
            </xsl:for-each>


            <!-- Files -->
            <xsl:call-template name="fileSec"/>

            <!-- Structure map -->
            <mets:structMap>
                <mets:div>

                    <xsl:for-each select=".//xip:Accession">
                        <mets:div TYPE="submission">
                            <xsl:attribute name="ADMID">AMD-<xsl:value-of select="normalize-space(./xip:AccessionRef)"/></xsl:attribute>
                            <xsl:for-each select="//xip:Files/xip:File">
                                <mets:fptr>
                                    <xsl:attribute name="FILEID">file<xsl:value-of select="position()"/></xsl:attribute>
                                </mets:fptr>
                            </xsl:for-each>
                        </mets:div>
                    </xsl:for-each>

                    <xsl:for-each select=".//xip:Collection">
                        <mets:div TYPE="collection">
                            <xsl:attribute name="DMDID">DMD-<xsl:value-of select="normalize-space(./xip:CollectionRef)"/></xsl:attribute>
                            <!-- <xsl:if test="code:getLatestAuditVersion(./xip:CollectionRef, 4) > 1">
                             <xsl:attribute name="ADMID">AMD-<xsl:value-of select="normalize-space(./xip:CollectionRef)"/></xsl:attribute>
                            </xsl:if> -->
                        </mets:div>
                    </xsl:for-each>

                    <xsl:for-each select=".//xip:DeliverableUnit">
                        <mets:div TYPE="deliverable unit">
                            <xsl:attribute name="DMDID">DMD-<xsl:value-of select="normalize-space(./xip:DeliverableUnitRef)"/></xsl:attribute>
                            <!-- <xsl:if test="code:getLatestAuditVersion(./xip:DeliverableUnitRef, 7) > 1">
                              <xsl:attribute name="ADMID">AMD-<xsl:value-of select="normalize-space(./xip:DeliverableUnitRef)"/></xsl:attribute>
                            </xsl:if> -->
                        </mets:div>
                    </xsl:for-each>

                    <xsl:for-each select=".//xip:Manifestation">
                        <mets:div TYPE="manifestation">
                            <xsl:variable name="manifestationRef">
                                <xsl:value-of select="normalize-space(./xip:ManifestationRef)"/>
                            </xsl:variable>
                            <xsl:attribute name="ADMID">AMD-<xsl:value-of select="$manifestationRef"/></xsl:attribute>
                            <xsl:for-each select="//xip:Files/xip:File">
                                <xsl:if test="//xip:Manifestation[xip:ManifestationRef = $manifestationRef]/xip:ManifestationFile/xip:FileRef = ./xip:FileRef">
                                    <mets:fptr>
                                        <xsl:attribute name="FILEID">file<xsl:value-of select="position()"/>
                                        </xsl:attribute>
                                    </mets:fptr>
                                </xsl:if>
                            </xsl:for-each>
                        </mets:div>
                    </xsl:for-each>

                </mets:div>
            </mets:structMap>

        </mets:mets>
    </xsl:template>
</xsl:stylesheet>
