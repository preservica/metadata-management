<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <div class="XSLTransformDiv">
            <div style="height: 50px">
                <span class="XSLTransformTitle">Dublin Core</span>
            </div>
            <table class="XSLTransformTable">
                <tr>
                    <th style="text-align: center" class="MQ KQ">DC Element</th>
                    <th style="text-align: center" class="MQ KQ">Value</th>
                </tr>
                <xsl:apply-templates select="//dc:contributor" />
                <xsl:apply-templates select="//dc:coverage" />
                <xsl:apply-templates select="//dc:creator" />
                <xsl:apply-templates select="//dc:date" />
                <xsl:apply-templates select="//dc:description" />
                <xsl:apply-templates select="//dc:format" />
                <xsl:apply-templates select="//dc:identifier" />
                <xsl:apply-templates select="//dc:language" />
                <xsl:apply-templates select="//dc:publisher" />
                <xsl:apply-templates select="//dc:relation" />
                <xsl:apply-templates select="//dc:rights" />
                <xsl:apply-templates select="//dc:source" />
                <xsl:apply-templates select="//dc:subject" />
                <xsl:apply-templates select="//dc:title" />
                <xsl:apply-templates select="//dc:type" />
            </table>
        </div>
    </xsl:template>

    <xsl:template match="dc:contributor">
        <tr>
            <td class="standardFieldName">Contributor</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:coverage">
        <tr>
            <td class="standardFieldName">Coverage</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:creator">
        <tr>
            <td class="standardFieldName">Creator</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:date">
        <tr>
            <td class="standardFieldName">Date</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:description">
        <tr>
            <td class="standardFieldName">Description</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:format">
        <tr>
            <td class="standardFieldName">Format</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:identifier">
        <tr>
            <td class="standardFieldName">Identifier</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:language">
        <tr>
            <td class="standardFieldName">Language</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:publisher">
        <tr>
            <td class="standardFieldName">Publisher</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:relation">
        <tr>
            <td class="standardFieldName">Relation</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:rights">
        <tr>
            <td class="standardFieldName">Rights</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:source">
        <tr>
            <td class="standardFieldName">Source</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:subject">
        <tr>
            <td class="standardFieldName">Subject</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:title">
        <tr>
            <td class="standardFieldName">Title</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:type">
        <tr>
            <td class="standardFieldName">Type</td>
            <td class="standardFieldValue"><xsl:value-of select="text()"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
