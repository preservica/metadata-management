<?xml version="1.0" encoding="utf-8"?>


<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes"
                xmlns:sax="http://saxon.sf.net/net.sf.saxon.functions.Extensions"
                xmlns:email="http://www.tessella.com/mailbox/v1" exclude-result-prefixes="xs fn xdt sax">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:param name="homeURI"/>
    <!-- Default value for the language in case the locale is not passed to the transform -->
    <xsl:param name="language" select="'en-GB'"/>
    <!-- Accept an override for stylesheet location for local testing -->
    <xsl:param name="cssOverride" select="''"/>

    <!-- Value for this transform name, to select any transform specific text -->
    <xsl:variable name="xslt" select="'email'"/>

    <xsl:variable name="stringFile">
        <strings>
            <!-- Email fields -->
            <str xml:lang="en" xslt="email" name="to">To</str>
            <str xml:lang="en" xslt="email" name="from">From</str>
            <str xml:lang="en" xslt="email" name="cc">CC</str>
            <str xml:lang="en" xslt="email" name="bcc">BCC</str>
            <str xml:lang="en" xslt="email" name="date">Date</str>
            <str xml:lang="en" xslt="email" name="subject">Subject</str>
            <str xml:lang="en" xslt="email" name="encrypted">Encrypted</str>
            <str xml:lang="en" xslt="email" name="signed">Signed</str>
            <str xml:lang="en" xslt="email" name="numberOfAttachments">Number of attachments</str>
            <str xml:lang="en" xslt="email" name="attachmentFileNames">Attachment file name</str>
            <str xml:lang="en" xslt="email" name="size">Size</str>
            <str xml:lang="en" xslt="email" name="sizeInBytes">Size in bytes</str>
            <str xml:lang="en" xslt="email" name="priority">Priority</str>
            <str xml:lang="en" xslt="email" name="importance">Importance</str>
            <str xml:lang="en" xslt="email" name="labels">Label</str>
            <str xml:lang="en" xslt="email" name="rawHeader">Raw Header</str>
            <str xml:lang="en" xslt="email" name="appointmentStartTime">Appointment Start Time</str>
            <str xml:lang="en" xslt="email" name="appointmentEndTime">Appointment End Time</str>

            <!-- Folder fields -->
            <str xml:lang="en" xslt="email" name="folderName">Folder name</str>

            <!-- Mailbox fields -->
            <str xml:lang="en" xslt="email" name="dbTitle">Mailbox title</str>

            <option xml:lang="en" ddl="trueFalse" value="true">True</option>
            <option xml:lang="en" ddl="trueFalse" value="false">False</option>
        </strings>
    </xsl:variable>

    <!-- The below template is taken from: http://stackoverflow.com/questions/3309746/how-to-convert-newline-into-br-with-xslt
    It converts a literal new line in XML into an actual line break in HTML -->
    <xsl:template match="text()" name="insertBreaks">
        <xsl:param name="pText" select="."/>
        <xsl:choose>
            <xsl:when test="not(contains($pText, '&#xA;'))">
                <xsl:copy-of select="$pText"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($pText, '&#xA;')"/>
                <br/>
                <xsl:call-template name="insertBreaks">
                    <xsl:with-param name="pText" select=
                            "substring-after($pText, '&#xA;')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/">
        <div class="XSLTransformDiv">
            <span class="XSLTransformTitle">Email Metadata</span>
            <table class="XSLTransformTable">
                <xsl:apply-templates select="//email:to"/>
                <xsl:apply-templates select="//email:from"/>
                <xsl:apply-templates select="//email:cc"/>
                <xsl:apply-templates select="//email:bcc"/>
                <xsl:apply-templates select="//email:date"/>
                <xsl:apply-templates select="//email:subject"/>
                <xsl:apply-templates select="//email:encrypted"/>
                <xsl:apply-templates select="//email:signed"/>
                <xsl:apply-templates select="//email:numberOfAttachments"/>
                <xsl:apply-templates select="//email:attachmentFileNames"/>
                <xsl:apply-templates select="//email:size"/>
                <xsl:apply-templates select="//email:sizeInBytes"/>
                <xsl:apply-templates select="//email:priority"/>
                <xsl:apply-templates select="//email:importance"/>
                <xsl:apply-templates select="//email:folderName"/>
                <xsl:apply-templates select="//email:dbTitle"/>
                <xsl:apply-templates select="//email:labels"/>
                <xsl:apply-templates select="//email:appointmentStartTime"/>
                <xsl:apply-templates select="//email:appointmentEndTime"/>
                <xsl:apply-templates select="//email:rawHeader"/>
            </table>
        </div>
    </xsl:template>

    <xsl:template
            match="email:to|email:from|email:cc|email:bcc|email:date|email:subject|email:encrypted|email:signed|email:numberOfAttachments|email:attachmentFileNames|email:size|email:sizeInBytes|email:priority|email:importance|email:folderName|email:dbTitle|email:labels|email:appointmentStartTime|email:appointmentEndTime|email:rawHeader">

        <xsl:variable name="label">
            <xsl:value-of select="local-name(.)"/>
        </xsl:variable>

        <tr>
            <td class="standardFieldName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="$label"/>
                </xsl:call-template>
            </td>
            <td class="standardFieldValue">
                <xsl:call-template name="insertBreaks"></xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <xsl:variable name="primaryLanguage" select="substring-before($language,'-')"/>

    <!--Template method used to localise the XSLT transform-->
    <xsl:template name="getString">
        <xsl:param name="stringName"/>
        <xsl:variable name="str" select="$stringFile/strings/str[@name=$stringName][@xslt=$xslt or not(@xslt)]"/>
        <xsl:choose>
            <!-- case where the locale passed as param had format "en" -->
            <xsl:when test="$str[lang($language)]">
                <xsl:value-of select="$str[lang($language)][1]"/>
            </xsl:when>
            <!-- case where the locale passed as param had format "en-GB" -->
            <xsl:when test="$str[lang($primaryLanguage)]">
                <xsl:value-of select="$str[lang($primaryLanguage)][1]"/>
            </xsl:when>
            <!-- issue a warning if no translation found -->
            <xsl:otherwise>
                <xsl:message terminate="no">
                    <xsl:text>Warning: no string named '</xsl:text>
                    <xsl:value-of select="$stringName"/>
                    <xsl:text>' found.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>