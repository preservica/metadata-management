<xsl:stylesheet version="1.0"
                xmlns:xip="http://www.tessella.com/XIP/v4"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
        >
    <xsl:output method="xml" indent="yes"/>
    <xsl:preserve-space elements="*"/>

    <xsl:template match="/">
        <xip:XIP>
            <xip:DeliverableUnits>
                <xsl:apply-templates select="mets:mets/mets:structMap"/>
            </xip:DeliverableUnits>
            <!--All files are copied to the XIP, regardless of whether there is a corresponding reference in the structMap. They are removed in Preservica. -->
            <xip:Files>
                <xsl:apply-templates select="mets:mets/mets:fileSec/mets:fileGrp/mets:file" mode="getTypeFile"/>
            </xip:Files>
        </xip:XIP>
    </xsl:template>

    <xsl:template match="mets:mets/mets:structMap">
        <xsl:apply-templates select="mets:div" mode="createDeliverableUnit"/>
        <xsl:apply-templates select="mets:div" mode="createManifestationNode"/>
    </xsl:template>

    <xsl:template match="mets:div" mode="createDeliverableUnit">
        <xip:DeliverableUnit status="new">
            <xsl:variable name="deliverableUnitRef" select="@ID"/>
            <xsl:variable name="label" select="@LABEL"/>

            <xsl:variable name="parentDeliverableUnitRef" select="parent::mets:div/@ID"/>
            <xip:DeliverableUnitRef>
                <xsl:value-of select="$deliverableUnitRef"/>
            </xip:DeliverableUnitRef>
            <!--Only add parentRef when its is not empty-->
            <xsl:if test="$parentDeliverableUnitRef != ''">
                <xip:ParentRef>
                    <xsl:value-of select="$parentDeliverableUnitRef"/>
                </xip:ParentRef>
            </xsl:if>
            <xip:CatalogueReference>
                <xsl:value-of select="$label"/>
            </xip:CatalogueReference>
            <xip:ScopeAndContent>
                <xsl:value-of select="$label"/>
            </xip:ScopeAndContent>
            <xip:Title>
                <xsl:value-of select="$label"/>
            </xip:Title>
            <xip:TypeRef>1</xip:TypeRef>
            <!--Matches mets:dmdSec nodes with a matching ID-->
            <xsl:apply-templates select="/mets:mets/mets:dmdSec[@ID = current()/@DMDID]"/>
            <!--Matches mets:amdSec nodes with a matching ID-->
            <xsl:apply-templates select="/mets:mets/mets:amdSec[@ID = current()/@ADMID]"/>

            <!--Matches mets:xmlData nodes with a grandparent with a matching ID-->
            <xsl:apply-templates select="//mets:xmlData[../../@ID = current()/@DMDID]"/>
            <!--Matches mets:xmlData nodeswith a grandparent with a matching ID-->
            <xsl:apply-templates select="//mets:xmlData[../../@ID = current()/@ADMID]"/>
        </xip:DeliverableUnit>
        <xsl:apply-templates select="mets:div" mode="createDeliverableUnit"/>
    </xsl:template>

    <xsl:template match="mets:div" mode="createManifestationNode">
        <xip:Manifestation status="new">
            <xsl:variable name="deliverableUnitRef" select="@ID"/>
            <xip:DeliverableUnitRef>
                <xsl:value-of select="$deliverableUnitRef"/>
            </xip:DeliverableUnitRef>
            <xip:ManifestationRef>
                <xsl:value-of select="generate-id()"/>
            </xip:ManifestationRef>
            <xip:ManifestationRelRef>1</xip:ManifestationRelRef>
            <xip:Originality>true</xip:Originality>
            <xip:Active>true</xip:Active>
            <xsl:apply-templates select="mets:fptr"/>
        </xip:Manifestation>
        <xsl:apply-templates select="mets:div" mode="createManifestationNode"/>
    </xsl:template>

    <xsl:template match="mets:fptr">
        <xsl:param name="fileMasterRef"  select="@FILEID"/>
        <xip:ManifestationFile status="new">
            <xip:FileRef>
                <xsl:value-of select="$fileMasterRef"/>
            </xip:FileRef>
            <xip:Path>
                <xsl:apply-templates  select="//mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID = current()/@FILEID]" mode="getFilePathString"/>
            </xip:Path>
        </xip:ManifestationFile>
    </xsl:template>

    <xsl:template match="mets:mets/mets:fileSec/mets:fileGrp/mets:file" mode="getTypeFile">
        <xsl:param name="fileMasterRef" select="@ID"/>

        <xip:File status="new">
            <xip:FileRef>
                <xsl:value-of select="$fileMasterRef"/>
            </xip:FileRef>
            <xip:WorkingPath>
                <xsl:apply-templates select="mets:FLocat" mode="getPathMode"/>
            </xip:WorkingPath>
            <xip:FileName>
                <xsl:apply-templates select="mets:FLocat" mode="getFileNameMode"/>
            </xip:FileName>
            <xip:Extant>true</xip:Extant>
            <xip:Directory>false</xip:Directory>
            <!--Matches mets:dmdSec nodes with a matching ID-->
            <xsl:apply-templates select="/mets:mets/mets:dmdSec[@ID = current()/@DMDID]/*/mets:mdWrap/mets:xmlData"/>
            <!--Matches mets:amdSec nodes with a matching ID-->
            <xsl:apply-templates select="/mets:mets/mets:amdSec[@ID = current()/@ADMID]/*/mets:mdWrap/mets:xmlData"/>

            <!--Matches mets:xmlData nodes with a grandparent with a matching ID-->
            <xsl:apply-templates select="//mets:xmlData[../../@ID = current()/@DMDID]"/>
            <!--Matches mets:xmlData nodes with a grandparent with a matching ID-->
            <xsl:apply-templates select="//mets:xmlData[../../@ID = current()/@ADMID]"/>
            <xsl:if test="@SIZE">
                <xip:FileSize><xsl:value-of select="@SIZE"/></xip:FileSize>
            </xsl:if>
            <xsl:if test="@CREATED">
                <xip:LastModifiedDate><xsl:value-of select="@CREATED"/></xip:LastModifiedDate>
            </xsl:if>
        </xip:File>
    </xsl:template>

    <xsl:template match="/mets:mets/mets:amdSec/*/mets:mdWrap/mets:xmlData">
        <xsl:call-template name="addGenericMetadata"/>
    </xsl:template>

    <xsl:template match="/mets:mets/mets:dmdSec/*/mets:mdWrap/mets:xmlData">
        <xsl:call-template name="addGenericMetadata"/>
    </xsl:template>

    <xsl:template match="//mets:xmlData">
        <xsl:call-template name="addGenericMetadata"/>
    </xsl:template>

    <!--Create a new metadata section for each piece of METS metadata-->
    <!--All child nodes are copied. If the input XML METS metadata is malformed, the transform is expected to fail.-->
    <xsl:template name="addGenericMetadata">
        <xip:Metadata>
            <xsl:attribute name="schemaURI">
                <xsl:value-of select="namespace-uri(child::*)"/>
            </xsl:attribute>
            <xsl:copy-of select="child::node()"/>
        </xip:Metadata>
    </xsl:template>

    <xsl:template  match="mets:mets/mets:fileSec/mets:fileGrp/mets:file"  mode="getFilePathString">
        <xsl:apply-templates select="mets:FLocat" mode="getPathMode">
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mets:FLocat" mode="getPathMode">
        <xsl:call-template name="getPath">
            <xsl:with-param name="relativePathToFile" select="@xlink:href" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="mets:FLocat" mode="getFileNameMode">
        <xsl:call-template name="getFileName">
            <xsl:with-param name="relativePathToFile" select="@xlink:href" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="getPath">
        <xsl:param name="relativePathToFile" />
        <xsl:param name="directoryPath" />
        <xsl:variable name="additionalDirectory" select="substring-before($relativePathToFile,'/')"/>
        <xsl:variable name="updatedDirectoryPathWithTerminatingSlash" select="concat(concat($directoryPath, $additionalDirectory ),  '/')"/>
        <xsl:variable name="updatedPathWithDirectoryRemoved" select="substring-after($relativePathToFile, $updatedDirectoryPathWithTerminatingSlash)"/>

        <xsl:choose>
            <xsl:when test="contains($updatedPathWithDirectoryRemoved,'/')">
                <xsl:call-template name="getPath">
                    <xsl:with-param name="relativePathToFile" select="$updatedPathWithDirectoryRemoved" />
                    <xsl:with-param name="directoryPath" select="$updatedDirectoryPathWithTerminatingSlash" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$updatedDirectoryPathWithTerminatingSlash" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getFileName">
        <xsl:param name="relativePathToFile" />
        <xsl:param name="directoryPath" />
        <xsl:variable name="additionalDirectory" select="concat(substring-before($relativePathToFile,'/'),  '/')"/>
        <xsl:variable name="updatedDirectoryPath" select="concat($directoryPath, $additionalDirectory )"/>
        <xsl:variable name="updatedPathWithDirectoryRemoved" select="substring-after($relativePathToFile, $additionalDirectory)"/>

        <xsl:choose>
            <xsl:when test="contains($updatedPathWithDirectoryRemoved,'/')">
                <xsl:call-template name="getFileName">
                    <xsl:with-param name="relativePathToFile" select="$updatedPathWithDirectoryRemoved" />
                    <xsl:with-param name="directoryPath" select="concat($updatedDirectoryPath,  '/')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$updatedPathWithDirectoryRemoved != ''">
                        <xsl:value-of select="$updatedPathWithDirectoryRemoved" />
                    </xsl:when>
                    <!--The paths have a slash added onto them by default. An empty path therefore is not matched in the sub-string after above -->
                    <!--The filename is not returned with a pre-prending forward slash-->
                    <xsl:otherwise>
                        <xsl:value-of select="$relativePathToFile" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
