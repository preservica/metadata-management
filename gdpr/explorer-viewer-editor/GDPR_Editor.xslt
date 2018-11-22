<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:gdpr="http://www.preservica.com/gdpr/v1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pres="http://preservica.com/custom/saxon-extensions"
                xmlns:mdl="http://preservica.com/MetadataDropdownLists/v1">

    <xsl:output method="html" encoding="UTF-8"/>

    <!-- Value for this transform name, to select any transform specific text -->
    <xsl:variable name="xslt" select="'gdpr'"/>

    <xsl:include href="common_editor_templates.xslt"/>

    <!-- To support custom drop down menu options, the below line should be commented out and example_dropdown_lists.xml
         should be replaced with the filename of the Metadata dropdown list document which you have uploaded to Preservica -->
     <xsl:variable name="dropdownlists" as="node()" select='document("GDPRDropDownList.xml")/mdl:Lists[1]'/>

    <!-- Adding a custom drop down menu is supported for fields which are created by calling the template "add-field-node".

         Within the <xsl:call-template> </xsl:call-template> block, you will need to copy and paste the following parameter (dropDownValues):

         <xsl:with-param name="dropDownValues">
             <xsl:copy-of select='$dropdownlists/mdl:List[@name="nameOfList"]'/>
         </xsl:with-param>

         You will then need to replace nameOfList with the list you have defined in your Metadata dropdown list document -->

    <!-- Main entry point -->
    <xsl:template match="/">
        <div>

            <!-- Put the stylesheet override in here. -->
            <xsl:if test="$cssOverride">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$cssOverride"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- Main Title for page -->
            <span class="XSLTransformTitle">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'mainHeader'"/>
                </xsl:call-template>
            </span>

            <br />
            <table class="XSLTransformTable">
                <col width="200px" />
                <col width="300px" />
                <xsl:call-template name="add-record-information" />
            </table>
        </div>
    </xsl:template>

    <!-- Template for the Record Information -->
    <xsl:template name="add-record-information">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
        </xsl:call-template>


        <!-- The individual fields -->

        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>//Q{http://www.preservica.com/gdpr/v1}personaldata</path>
            </xsl:with-param>
            <xsl:with-param name="dropDownValues">
                <xsl:copy-of select='$dropdownlists/mdl:List[@name="personaldata"]'/>
            </xsl:with-param>

        </xsl:call-template>

        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>//Q{http://www.preservica.com/gdpr/v1}recordobjected</path>
            </xsl:with-param>
            <xsl:with-param name="dropDownValues">
                <xsl:copy-of select='$dropdownlists/mdl:List[@name="recordobjected"]'/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>//Q{http://www.preservica.com/gdpr/v1}recordobjecteddate</path>
            </xsl:with-param>
            <xsl:with-param name="type">date</xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>//Q{http://www.preservica.com/gdpr/v1}recipientdisclosurecategory</path>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>//Q{http://www.preservica.com/gdpr/v1}timelimitforerasure</path>
            </xsl:with-param>
            <xsl:with-param name="type">date</xsl:with-param>
        </xsl:call-template>


    </xsl:template>

    <!-- Template to deal with name value pair text sections -->
    <xsl:template match="gdpr:personaldata|gdpr:recordobjected|gdpr:recordobjecteddate|gdpr:recipientdisclosurecategory|gdpr:timelimitforerasure">
        <xsl:param name="field" />
        <xsl:param name="label" />
        <xsl:param name="type" />
        <xsl:param name="dropDownValues" />

        <xsl:choose>
            <xsl:when test="$type = 'date'">
                <xsl:call-template name="nameValuePairTemplateDate">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="field">
                        <xsl:value-of select="fn:path()"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="fieldValue">
                        <xsl:value-of select="text()"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$dropDownValues != ''">
                <xsl:call-template name="setupDDL">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="field">
                        <xsl:value-of select="fn:path()"/>
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
                <xsl:call-template name="nameValuePairTemplateText">
                    <xsl:with-param name="key">
                        <xsl:value-of select="$field"/>
                    </xsl:with-param>
                    <xsl:with-param name="field">
                        <xsl:value-of select="fn:path()"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">
                        <xsl:value-of select="$label"/>
                    </xsl:with-param>
                    <xsl:with-param name="fieldValue">
                        <xsl:value-of select="text()"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>