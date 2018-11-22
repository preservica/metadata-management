<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

    <xsl:output method="html" encoding="UTF-8"/>

    <!-- Parameter to locate the transform text file -->
    <xsl:param name="homeURI" />
    <!-- Default value for the language in case the locale is not passed to the transform -->
    <xsl:param name="language" select="'en-GB'"/>
    <!-- Accept an override for stylesheet location for local testing -->
    <xsl:param name="cssOverride" select="''"/>

    <!-- Import the XML file containing the locale specific text -->
    <xsl:variable name="stringFile" select="document(concat($homeURI,'/resources/transform_text.xml'))"/>
    <xsl:variable name="primaryLanguage" select="substring-before($language,'-')"/>

    <!-- the unusedrootelement is detected in java and trimmed off to give an XML fragment -->
    <xsl:template match="/">
        <xsl:call-template name="viewGenericTemplate"/>
    </xsl:template>

    <!-- the particular form of XHTML used to output the issues element -->
    <xsl:template name="viewGenericTemplate">
        <div>
            <!-- Put the stylesheet override in here. -->
            <xsl:if test="$cssOverride">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$cssOverride"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <span class="XSLTransformTitle">
                <xsl:value-of select="'Generic Metadata'"/>
            </span>

            <br />
            <table class="XSLTransformTable">
                <colgroup>
                    <col width="200px"/>
                    <col width="450px"/>
                </colgroup>
                <xsl:apply-templates mode="processArbitraryContents" select="/*" />
            </table>
        </div>
    </xsl:template>

    <xsl:template match="/*" mode="processArbitraryContents">
        <tr>
            <td class="mainSectionHeader" colspan="2">
                <xsl:choose>
                    <xsl:when test="namespace-uri()">
                        <xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/>
                        <xsl:value-of select="', Namespace: '"/>
                        <xsl:value-of select="namespace-uri()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <xsl:apply-templates select="./@*" />
        <xsl:for-each select="child::*">
            <xsl:call-template name="outputElement">
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="outputElement">
        <xsl:choose>
            <xsl:when test="count(child::*) > 0">
                <xsl:call-template name="outputTitle">
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="outputKeyValuePair">
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="outputTitle">
        <tr>
            <td class="standardFieldName">
                <xsl:for-each select="ancestor::*">
                    &#160;
                </xsl:for-each>
                <xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/>
            </td>
            <td></td>
        </tr>
        <xsl:apply-templates select="./@*" />
        <xsl:for-each select="child::*">
            <xsl:call-template name="outputElement">
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="outputKeyValuePair">
        <tr>
            <td class="standardFieldName">
                <xsl:for-each select="ancestor::*">
                    &#160;
                </xsl:for-each>
                <xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/>
            </td>
            <td class="standardFieldValue">
                <xsl:attribute name="id">
                    editable-<xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
                <input type="text">
                    <xsl:attribute name="class">
                        <xsl:text>standardTextFieldInput</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="fn:path()"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </input>
            </td>
        </tr>
        <xsl:apply-templates select="./@*" />
    </xsl:template>

    <xsl:template match="@*">
        <tr>
            <td class="standardFieldName">
                <xsl:for-each select="ancestor::*">
                    &#160;
                </xsl:for-each>
                <em><xsl:value-of select="fn:replace(translate(local-name(), '_', ' '), '([a-z])([A-Z])', '$1 $2')"/></em>
            </td>
            <td class="standardFieldValue">
                <xsl:attribute name="id">
                    editable-<xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
                <input type="text">
                    <xsl:attribute name="class">
                        <xsl:text>standardTextFieldInput</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="fn:path()"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </input>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
