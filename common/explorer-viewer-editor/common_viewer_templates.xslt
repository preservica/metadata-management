<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pres="http://preservica.com/custom/saxon-extensions"
    xmlns:mdl="http://preservica.com/MetadataDropdownLists/v1">

    <!-- Parameter to locate the transform text file -->
    <xsl:param name="homeURI" />
    <!-- Default value for the language in case the locale is not passed to the transform -->
    <xsl:param name="language" select="'en_gb'"/>
    <!-- Accept an override for stylesheet location for local testing -->
    <xsl:param name="cssOverride" select="''"/>

    <!-- Import the XML file containing the locale specific text -->
    <xsl:variable name="stringFile" select="document(concat($homeURI,'/resources/transform_text.xml'))"/>
    <xsl:variable name="primaryLanguage" select="substring-before($language,'_')"/>

    <xsl:variable name="groupId"><xsl:value-of select="pres:uuid()"/></xsl:variable>

    <!-- Generic Template to add a field based on XPath Expression, whether or not it exists in the source XML   -->
    <!-- If a label parameter is specified, this is used; otherwise the field value is used to look-up the label -->
    <xsl:template name="add-field-node">
        <xsl:param name="field" />
        <xsl:param name="label" />
        <xsl:param name="dropDownValues" />
        <xsl:choose>
            <xsl:when test="pres:evaluate($field)">
                <xsl:apply-templates select="pres:evaluate($field)">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="dropDownValues">
                        <xsl:copy-of select="$dropDownValues"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$dropDownValues != ''">
                        <xsl:call-template name="setupDDLValidation">
                            <xsl:with-param name="field">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="label">
                                <xsl:value-of select="$label"/>
                            </xsl:with-param>
                            <xsl:with-param name="dropDownValues">
                                <xsl:copy-of select='$dropDownValues'/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nameValuePairTemplate">
                            <xsl:with-param name="field">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="label">
                                <xsl:value-of select="$label"/>
                            </xsl:with-param>
                            <xsl:with-param name="fieldValue">
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generic Template to add a big field based on XPath Expression, whether or not it exists in the source XML -->
    <!-- If a label parameter is specified, this is used; otherwise the field value is used to look-up the label   -->
    <xsl:template name="add-big-field-node">
        <xsl:param name="field" />
        <xsl:param name="label" />
        <xsl:choose>
            <xsl:when test="pres:evaluate($field)">
                <xsl:apply-templates select="pres:evaluate($field)">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="headingAndValueTemplate">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="fieldValue">
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- OUTPUT TEMPLATES -->

    <!-- Template to show a main section header -->
    <xsl:template name="mainSectionHeaderTemplate">
        <xsl:param name="sectionName"/>
        <tr>
            <td colspan="2" class="mainSectionHeader">
                <xsl:value-of select="$sectionName"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Template to show a name value pair -->
    <xsl:template name="nameValuePairTemplate">
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="fieldValue"/>

        <tr>
            <td class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td class="standardFieldValue">
                <xsl:value-of select="$fieldValue"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Template to show a heading and value field -->
    <xsl:template name="headingAndValueTemplate">
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="fieldValue"/>

        <tr>
            <td colspan="2" class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="standardFieldValue">
                <xsl:choose>
                    <xsl:when test="normalize-space($fieldValue) != ''">
                        <xsl:value-of select="$fieldValue"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <!-- Utilities -->

    <!-- Define an element for hardcoded paths - a normalized string -->
    <xs:element name="xpath" type="xs:normalizedString" />

    <!-- Variable to introduce a spacer row in the output where required -->
    <xsl:variable name="spacerRow">
        <tr class="spacer" colspan="2">
            <td />
        </tr>
    </xsl:variable>

    <!-- Template method used to localise the XSLT transform -->
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

    <!-- Template method used to validate field value against specified list -->
    <xsl:template name="setupDDLValidation">
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="dropDownValues"/>

        <xsl:variable name="currValue">
            <xsl:value-of select="text()"/>
        </xsl:variable>

        <tr>
            <td class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td class="standardFieldValue" data-metadata-field="true">
                <xsl:attribute name="data-group-id"><xsl:value-of select="$groupId"/></xsl:attribute>
                <xsl:if test="not($dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem[text() = $currValue])">
                    <xsl:attribute name="data-invalid-value">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem[text() = $currValue]">
                    <xsl:variable name="name"><xsl:value-of select="$dropDownValues/mdl:List[mdl:MenuItems/mdl:MenuItem = $currValue]/@name"/></xsl:variable>
                    <xsl:variable name="dependsOn"><xsl:value-of select="$dropDownValues/mdl:List[mdl:MenuItems/mdl:MenuItem = $currValue]/@dependsOn"/></xsl:variable>
                    <xsl:variable name="dependentValue"><xsl:value-of select="string-join($dropDownValues/mdl:List/mdl:MenuItems[mdl:MenuItem = $currValue]/@dependentValue, '$$')"/></xsl:variable>
                    <xsl:variable name="listName">
                        <xsl:choose>
                            <xsl:when test="($dependsOn != '') and ($dependentValue != '')"><xsl:value-of select="string-join(($name, $dependsOn, $dependentValue), '%%')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="data-list-name"><xsl:value-of select="$listName"/></xsl:attribute>
                </xsl:if>
                <!-- First div displays validation warning, 2nd div displays current value -->
                <div>
                    <b>&#160;</b><br></br>
                </div>
                <div><xsl:value-of select="$currValue"/></div>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>