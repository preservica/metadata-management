<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
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
        <xsl:param name="type" />
        <xsl:param name="dropDownValues" />
        <xsl:param name="readonly" />

        <xsl:choose>
            <xsl:when test="pres:evaluate($field)">
                <xsl:apply-templates select="pres:evaluate($field)">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="type">
                        <xsl:value-of select="$type"/>
                    </xsl:with-param>
                    <xsl:with-param name="dropDownValues">
                        <xsl:copy-of select="$dropDownValues"/>
                    </xsl:with-param>
                    <xsl:with-param name="readonly">
                        <xsl:value-of select="$readonly"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$type = 'date'">
                        <xsl:call-template name="nameValuePairTemplateDate">
                            <xsl:with-param name="key">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="field">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="label">
                                <xsl:value-of select="$label"/>
                            </xsl:with-param>
                            <xsl:with-param name="fieldValue">
                            </xsl:with-param>
                            <xsl:with-param name="readonly">
                                <xsl:value-of select="$readonly"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$dropDownValues != ''">
                        <xsl:call-template name="setupDDL">
                            <xsl:with-param name="key">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="field">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="label">
                                <xsl:value-of select="$label"/>
                            </xsl:with-param>
                            <xsl:with-param name="dropDownValues">
                                <xsl:copy-of select='$dropDownValues'/>
                            </xsl:with-param>
                            <xsl:with-param name="readonly">
                                <xsl:value-of select="$readonly"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nameValuePairTemplateText">
                            <xsl:with-param name="key">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="field">
                                <xsl:value-of select="$field"/>
                            </xsl:with-param>
                            <xsl:with-param name="label">
                                <xsl:value-of select="$label"/>
                            </xsl:with-param>
                            <xsl:with-param name="fieldValue">
                            </xsl:with-param>
                            <xsl:with-param name="readonly">
                                <xsl:value-of select="$readonly"/>
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
        <xsl:param name="readonly" />
        <xsl:choose>
            <xsl:when test="pres:evaluate($field)">
                <xsl:apply-templates select="pres:evaluate($field)">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="readonly">
                        <xsl:value-of select="$readonly"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="headingAndValueTemplate">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="fieldValue">
                    </xsl:with-param>
                    <xsl:with-param name="readonly">
                        <xsl:value-of select="$readonly"/>
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

    <!-- Template to show a name value pair text field -->
    <xsl:template name="nameValuePairTemplateText">
        <xsl:param name="key"/>
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <tr>
            <td class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$key"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <xsl:call-template name="textBoxTemplate">
                <xsl:with-param name="field">
                    <xsl:value-of select="$field"/>
                </xsl:with-param>
                <xsl:with-param name="fieldValue">
                    <xsl:value-of select="$fieldValue"/>
                </xsl:with-param>
                <xsl:with-param name="readonly">
                    <xsl:value-of select="$readonly"/>
                </xsl:with-param>
            </xsl:call-template>
        </tr>
    </xsl:template>

    <xsl:template name="textBoxTemplate">
        <xsl:param name="field"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <td>
            <xsl:attribute name="id">editable-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <input type="text">
                <xsl:attribute name="name">
                    <xsl:value-of select="$field"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                    <xsl:value-of select="$fieldValue"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>standardTextFieldInput</xsl:text>
                </xsl:attribute>
                <xsl:if test="$readonly = 'true'">
                    <xsl:attribute name="readonly"/>
                </xsl:if>
            </input>
        </td>
    </xsl:template>

    <!-- Template to show a name value pair date field -->
    <xsl:template name="nameValuePairTemplateDate">
        <xsl:param name="key"/>
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <tr>
            <td class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$key"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <xsl:call-template name="dateBoxTemplate">
                <xsl:with-param name="field">
                    <xsl:value-of select="$field"/>
                </xsl:with-param>
                <xsl:with-param name="fieldValue">
                    <xsl:value-of select="$fieldValue"/>
                </xsl:with-param>
                <xsl:with-param name="readonly">
                    <xsl:value-of select="$readonly"/>
                </xsl:with-param>
            </xsl:call-template>
        </tr>
    </xsl:template>

    <xsl:template name="dateBoxTemplate">
        <xsl:param name="field"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <td>
            <xsl:attribute name="id">editable-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <input type="date">
                <xsl:attribute name="name">
                    <xsl:value-of select="$field"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                    <xsl:value-of select="$fieldValue"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>standardTextFieldInput</xsl:text>
                </xsl:attribute>
                <xsl:if test="$readonly = 'true'">
                    <xsl:attribute name="readonly"/>
                </xsl:if>
            </input>
        </td>
    </xsl:template>

    <!-- Template to show a heading and value field -->
    <xsl:template name="headingAndValueTemplate">
        <xsl:param name="key"/>
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <tr>
            <td colspan="2" class="standardFieldName">
                <xsl:choose>
                    <xsl:when test="$label != ''">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName">
                                <xsl:value-of select="$key"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <xsl:call-template name="textAreaTemplate">
                <xsl:with-param name="field">
                    <xsl:value-of select="$field"/>
                </xsl:with-param>
                <xsl:with-param name="fieldValue">
                    <xsl:value-of select="$fieldValue"/>
                </xsl:with-param>
                <xsl:with-param name="readonly">
                    <xsl:value-of select="$readonly"/>
                </xsl:with-param>
            </xsl:call-template>
        </tr>
    </xsl:template>

    <xsl:template name="textAreaTemplate">
        <xsl:param name="field"/>
        <xsl:param name="fieldValue"/>
        <xsl:param name="readonly"/>

        <td colspan="2">
            <xsl:attribute name="id">editable-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <textArea rows="4" cols="80" class="standardTextAreaInput">
                <xsl:attribute name="name">
                    <xsl:value-of select="$field"/>
                </xsl:attribute>
                <xsl:if test="$readonly = 'true'">
                    <xsl:attribute name="readonly"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="normalize-space($fieldValue) != ''">
                        <xsl:value-of select="$fieldValue"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
            </textArea>
        </td>
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

    <!-- Sets up drop down list using supplied values -->
    <xsl:template name="setupDDL">
        <xsl:param name="key"/>
        <xsl:param name="field"/>
        <xsl:param name="label"/>
        <xsl:param name="dropDownValues"/>
        <xsl:param name="readonly" />

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
                                <xsl:value-of select="$key"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:attribute name="id">editable-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
                <xsl:if test="not($dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem[text() = $currValue])">
                    <xsl:attribute name="class">XSLTInvalidDropdownValue</xsl:attribute>
                </xsl:if>

                <!-- If the current value is not in the permitted drop down list values, show a warning -->
                <div>
                    <xsl:if test="$dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem[text() = $currValue]">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                    </xsl:if>
                    <b>&#160;</b><br></br>
                </div>

                <xsl:call-template name="buildCustomDDL">
                    <xsl:with-param name="field">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="existingValue">
                        <xsl:value-of select="$currValue"/>
                    </xsl:with-param>
                    <xsl:with-param name="dropDownValues">
                        <xsl:copy-of select="$dropDownValues"/>
                    </xsl:with-param>
                    <xsl:with-param name="readonly">
                        <xsl:value-of select="$readonly"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <!-- Template method used to build a drop down list -->
    <xsl:template name="buildCustomDDL">
        <xsl:param name="field"/>
        <xsl:param name="existingValue"/>
        <xsl:param name="dropDownValues"/>
        <xsl:param name="readonly" />

        <select type="text" class="standardTextFieldInput" data-metadata-field="true" onchange="initialiseDropdownLists()">
            <xsl:attribute name="name"><xsl:value-of select="$field" /></xsl:attribute>
            <xsl:attribute name="data-group-id"><xsl:value-of select="$groupId"/></xsl:attribute>
            <xsl:variable name="name"><xsl:value-of select="$dropDownValues/mdl:List[1]/@name"/></xsl:variable>
            <xsl:variable name="dependsOn"><xsl:value-of select="$dropDownValues/mdl:List[1]/@dependsOn"/></xsl:variable>
            <xsl:variable name="listName">
                <xsl:choose>
                    <xsl:when test="($dependsOn != '')"><xsl:value-of select="string-join(($name, $dependsOn), '%%')"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="data-list-name"><xsl:value-of select="$listName" /></xsl:attribute>
            <xsl:if test="$readonly = 'true'">
                <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>

            <!-- If the current value is not in the permitted drop down list values, add it to the drop down and keep it selected -->
            <xsl:if test="not($dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem[text() = $existingValue])">
                <option>
                    <xsl:attribute name="data-group-id"><xsl:value-of select="$groupId"/></xsl:attribute>
                    <xsl:attribute name="data-invalid-item">true</xsl:attribute>
                    <xsl:value-of select="$existingValue"/>
                </option>
            </xsl:if>

            <xsl:for-each select="$dropDownValues/mdl:List/mdl:MenuItems/mdl:MenuItem">
                <option>
                    <xsl:attribute name="data-group-id"><xsl:value-of select="$groupId"/></xsl:attribute>
                    <xsl:variable name="dependentValue"><xsl:value-of select="../@dependentValue"/></xsl:variable>
                    <xsl:attribute name="data-list-name">
                        <xsl:choose>
                            <xsl:when test="($dependentValue != '')"><xsl:value-of select="string-join(($listName, $dependentValue), '%%')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$listName"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="@inactive = 'true'">
                        <xsl:attribute name="disabled"></xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="dropdownValue">
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:variable name="default">
                        <xsl:value-of select="@default"/>
                    </xsl:variable>
                    <xsl:choose>
                        <!-- If current value is empty, and a default is specified, select the default -->
                        <xsl:when test="($existingValue = '') and ($default = 'true')">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="$existingValue = $dropdownValue">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="."/>
                </option>
            </xsl:for-each>
        </select>
    </xsl:template>

</xsl:stylesheet>