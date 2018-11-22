<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:crawl="http://crawler.archive.org/crawl-order">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <div class="XSLTransformDiv">
            <span class="XSLTransformTitle">Hertrix Crawl Target</span>
            <br />
            <table class="XSLTransformTable">
                <tr>
                    <th class="HQ">Key</th>
                    <th class="HQ">Value</th>
                </tr>
                <xsl:apply-templates select="//crawl:meta/crawl:name" />
                <xsl:apply-templates select="//crawl:meta/crawl:description" />
                <xsl:apply-templates select="//crawl:meta/crawl:audience" />
                <xsl:apply-templates select="//crawl:meta/crawl:date" />
            </table>
            <br />
            <br />
            <span class="XSLTransformTitle">Hertrix Controller Settings</span>
            <br />
            <table class="XSLTransformTable">
                <tr>
                    <th class="HQ">Key</th>
                    <th class="HQ">Value</th>
                </tr>
                <xsl:apply-templates select="//crawl:integer[@name='max-hops']" />
                <xsl:apply-templates select="//crawl:integer[@name='max-path-depth']" />
            </table>
        </div>
    </xsl:template>

    <xsl:template match="crawl:meta/crawl:audience">
        <tr>
            <td class="standardFieldName">url</td>
            <td class="standardFieldValue">
                <xsl:value-of select="text()"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="crawl:meta/crawl:name|crawl:meta/crawl:description|crawl:meta/crawl:date">
        <tr>
            <td class="standardFieldName">
                <xsl:value-of select="local-name(.)"/>
            </td>
            <td class="standardFieldValue">
                <xsl:value-of select="text()"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="crawl:integer[@name='max-hops']|crawl:integer[@name='max-path-depth']">
        <tr>
            <td class="standardFieldName">
                <xsl:value-of select="@name"/>
            </td>
            <td class="standardFieldValue">
                <xsl:value-of select="text()"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>

