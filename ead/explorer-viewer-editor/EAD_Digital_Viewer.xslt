<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pres="http://preservica.com/custom/saxon-extensions"
    xmlns:mdl="http://preservica.com/MetadataDropdownLists/v1">

    <xsl:output method="html" encoding="UTF-8"/>

    <!-- Value for this transform name, to select any transform specific text -->
    <xsl:variable name="xslt" select="'ead'"/>

    <xsl:include href="common_viewer_templates.xslt"/>

    <!-- If you support custom drop down menu options in your Editor, you should make similar changes to your Viewer.
         The below line should be commented out and example_dropdown_lists.xml should be replaced with the filename of the Metadata dropdown list document which you have uploaded to Preservica -->
    <!-- <xsl:variable name="dropdownlists" as="node()" select='document("example_dropdown_lists.xml")/mdl:Lists[1]'/> -->

    <!-- For each field which has been configured with a custom drop down menu in your editor, you will need to make the following change:
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

            <span class="XSLTransformTitle">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'mainHeader'"/>
                </xsl:call-template>
            </span>

            <br />
            <table class="XSLTransformTable">
                <col width="200px" />
                <col width="300px" />
                <xsl:call-template name="add-header-nodes" />
                <xsl:call-template name="add-archdesc-nodes" />
            </table>
        </div>
    </xsl:template>

    <!-- Add all the nodes for the header -->
    <xsl:template name="add-header-nodes">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
            <xsl:with-param name="sectionName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'eadHeader'"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <!-- The individual fields -->
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}eadheader/Q{urn:isbn:1-931666-22-9}eadid</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}eadheader/Q{urn:isbn:1-931666-22-9}filedesc/Q{urn:isbn:1-931666-22-9}titlestmt/Q{urn:isbn:1-931666-22-9}titleproper</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}eadheader/Q{urn:isbn:1-931666-22-9}profiledesc/Q{urn:isbn:1-931666-22-9}descrules</path></xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <!-- Add all the nodes for the archival description -->
    <xsl:template name="add-archdesc-nodes">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
            <xsl:with-param name="sectionName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'archDescHeader'"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="add-archdesc-did" />

        <!-- The individual fields -->
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}bioghist/Q{urn:isbn:1-931666-22-9}p</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}custodhist/Q{urn:isbn:1-931666-22-9}p</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}bibliography/Q{urn:isbn:1-931666-22-9}p</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}odd/Q{urn:isbn:1-931666-22-9}note/Q{urn:isbn:1-931666-22-9}p</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}processinfo/Q{urn:isbn:1-931666-22-9}p</path></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Add the Fields of the DID -->
    <xsl:template name="add-archdesc-did">

        <!-- The DID -->
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}did/Q{urn:isbn:1-931666-22-9}unittitle</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}did/Q{urn:isbn:1-931666-22-9}unitdate[@label='Accumulation']</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}did/Q{urn:isbn:1-931666-22-9}unitdate[@label='Created']</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}did/Q{urn:isbn:1-931666-22-9}origination[@label='Creator']</path></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field"><path>/Q{urn:isbn:1-931666-22-9}ead/Q{urn:isbn:1-931666-22-9}archdesc/Q{urn:isbn:1-931666-22-9}did/Q{urn:isbn:1-931666-22-9}langmaterial</path></xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <!-- Template to deal with name value pair sections -->
    <xsl:template match="ead:ead/ead:eadheader/ead:eadid
                      |ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper
                      |ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author
                      |ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:p
                      |ead:ead/ead:eadheader/ead:profiledesc/ead:descrules
                      |ead:ead/ead:eadheader/ead:profiledesc/ead:creation/ead:date
                      |ead:ead/ead:archdesc/ead:did/ead:unittitle
                      |ead:ead/ead:archdesc/ead:did/ead:unitdate
                      |ead:ead/ead:archdesc/ead:did/ead:origination
                      |ead:ead/ead:archdesc/ead:did/ead:physdesc
                      |ead:ead/ead:archdesc/ead:did/ead:langmaterial">
        <xsl:param name="field" />
        <xsl:param name="label" />
        <xsl:param name="dropDownValues" />

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
                        <xsl:value-of select="text()"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template to deal with big field value sections -->
    <xsl:template match="ead:p">
        <xsl:param name="field"/>
        <xsl:param name="label" />

        <xsl:call-template name="headingAndValueTemplate">
            <xsl:with-param name="field">
                <xsl:value-of select="$field"/>
            </xsl:with-param>
            <xsl:with-param name="label">
                <xsl:value-of select="$label"/>
            </xsl:with-param>
            <xsl:with-param name="fieldValue">
                <xsl:value-of select="text()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>