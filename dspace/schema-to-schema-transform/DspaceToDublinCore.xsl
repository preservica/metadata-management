<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" >
                <xsl:apply-templates  select="/dublin_core/dcvalue" />
        </dc:dc>
    </xsl:template>

    <xsl:template match="dcvalue">
        <xsl:if test="@element='contributor' and @qualifier='author'">
            <dc:creator> <xsl:value-of select="text()"/> </dc:creator>
        </xsl:if>
        <xsl:if test="@element='subject'">
            <dc:subject> <xsl:value-of select="text()"/> </dc:subject>
        </xsl:if>
        <xsl:if test="@element='creator'">
            <dc:creator> <xsl:value-of select="text()"/> </dc:creator>
        </xsl:if>
        <xsl:if test="@element='description' and not ((@qualifier='abstract') or (@qualifier='provenance'))">
            <dc:description> <xsl:value-of select="text()"/> </dc:description>
        </xsl:if>
        <xsl:if test="@element='description' and @qualifier='abstract'">
            <dc:description>[abstract] <xsl:value-of select="text()"/> </dc:description>
        </xsl:if>
        <xsl:if test="@element='date' and @qualifier='issued'">
            <dc:date> <xsl:value-of select="text()"/> </dc:date>
        </xsl:if>
        <xsl:if test="@element='format'" >
            <dc:format> <xsl:value-of select="text()"/> </dc:format>
        </xsl:if>
        <xsl:if test="@element='identifier' and @qualifier='uri'">
            <dc:identifier> <xsl:value-of select="text()"/> </dc:identifier>
        </xsl:if>
        <xsl:if test="@element='identifier' and @qualifier='other'">
            <dc:identifier>[accessno] <xsl:value-of select="text()"/> </dc:identifier>
        </xsl:if>
        <xsl:if test="@element='language'" >
            <dc:language> <xsl:value-of select="text()"/> </dc:language>
        </xsl:if>
        <xsl:if test="@element='type'" >
            <dc:type> <xsl:value-of select="text()"/> </dc:type>
        </xsl:if>
        <xsl:if test="@element='title'" >
            <dc:title> <xsl:value-of select="text()"/> </dc:title>
        </xsl:if>
        <xsl:if test="@element='relation'">
            <dc:relation> <xsl:value-of select="text()"/> </dc:relation>
        </xsl:if>
        <xsl:if test="@element='coverage' and @qualifier='spatial'">
            <dc:coverage>[spatial] <xsl:value-of select="text()"/> </dc:coverage>
        </xsl:if>
        <xsl:if test="@element='coverage' and @qualifier='temporal'">
            <dc:coverage>[temporal] <xsl:value-of select="text()"/> </dc:coverage>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
