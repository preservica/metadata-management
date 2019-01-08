<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!-- A basic stylesheet for generating a UA display of metadata in the multi-lingual schema. -->
<!-- This uses the "lang" attribute of each metadata element to determine what to display in the item's "name" field. -->
<!-- This only has French translations, and will default to English text if the lang attribute is missing or set to -->
<!-- something other than 'fr'. This can be extended to other languages by providing new xsl:when elements following the -->
<!-- established pattern. -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ml="http://www.preservica.com/example/multi-lingual-ua-metadata/v1"
    xmlns="http://www.tessella.com/sdb/cmis/metadata"
    exclude-result-prefixes="ml">

    <xsl:output method='xml' indent='yes'/>

    <!-- Match the base element and create a group. Note that the title for this group is hard-coded in English. -->
    <xsl:template match="ml:lingual">
        <group>
            <title>Multi Lingual Metadata</title>
            <xsl:apply-templates />
        </group>
    </xsl:template>

    <!-- Match the title element -->
    <xsl:template match="ml:title">
        <item>
            <!-- For the name, test whether the lang attribute is set to 'fr', and if so use some French text, otherwise, default to English -->
            <name>
                <xsl:choose>
                    <xsl:when test="@lang='fr'">Titre en Français</xsl:when>
                    <xsl:otherwise>English Title</xsl:otherwise>
                </xsl:choose>
            </name>
            <value>
                <xsl:value-of select="."/>
            </value>
            <type>
                <xsl:value-of select="concat('ml.ml_', local-name())"/>
            </type>
        </item>
    </xsl:template>

    <!-- Match the description element -->
    <xsl:template match="ml:description">
        <item>
            <!-- For the name, test whether the lang attribute is set to 'fr', and if so use some French text, otherwise, default to English -->
            <name>
                <xsl:choose>
                    <xsl:when test="@lang='fr'">Description en Français</xsl:when>
                    <xsl:otherwise>English Description</xsl:otherwise>
                </xsl:choose>
            </name>
            <value>
                <xsl:value-of select="."/>
            </value>
            <type>
                <xsl:value-of select="concat('ml.ml_', local-name())"/>
            </type>
        </item>
    </xsl:template>

</xsl:stylesheet>
