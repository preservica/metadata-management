<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pres="http://preservica.com/custom/saxon-extensions"
    xmlns:mdl="http://preservica.com/MetadataDropdownLists/v1">

    <xsl:output method="html" encoding="UTF-8"/>

    <!-- Value for this transform name, to select any transform specific text -->
    <xsl:variable name="xslt" select="'mods'"/>

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
                <xsl:call-template name="add-detail-information" />
                <xsl:call-template name="add-notes" />
            </table>
        </div>
    </xsl:template>

    <!-- Template for the Record Information -->
    <xsl:template name="add-record-information">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
            <xsl:with-param name="sectionName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName">
                        <path>recordInfoHeader</path>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <!-- The individual fields -->
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}recordInfo/Q{http://www.loc.gov/mods/v3}recordIdentifier</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}recordInfo/Q{http://www.loc.gov/mods/v3}recordOrigin</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}recordInfo/Q{http://www.loc.gov/mods/v3}recordCreationDate</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}recordInfo/Q{http://www.loc.gov/mods/v3}descriptionStandard</path>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template for the Details -->
    <xsl:template name="add-detail-information">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
            <xsl:with-param name="sectionName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName">
                        <path>detailsHeader</path>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <!-- The individual fields -->
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}titleInfo/Q{http://www.loc.gov/mods/v3}title</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}name[Q{http://www.loc.gov/mods/v3}role/Q{http://www.loc.gov/mods/v3}roleTerm[text()='Creator']]/Q{http://www.loc.gov/mods/v3}namePart</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}typeOfResource</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}originInfo/Q{http://www.loc.gov/mods/v3}dateCreated</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}originInfo/Q{http://www.loc.gov/mods/v3}dateOther</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}language/Q{http://www.loc.gov/mods/v3}languageTerm</path>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}physicalDescription/Q{http://www.loc.gov/mods/v3}extent</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}physicalDescription/Q{http://www.loc.gov/mods/v3}form</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}physicalDescription/Q{http://www.loc.gov/mods/v3}note[@type='arrangement']</path>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}accessCondition[@type='access']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}accessCondition[@type='use']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}subject/Q{http://www.loc.gov/mods/v3}topic</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}relatedItem[@type='host']/Q{http://www.loc.gov/mods/v3}titleInfo/Q{http://www.loc.gov/mods/v3}title</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}location/Q{http://www.loc.gov/mods/v3}physicalLocation[@type='original']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}relatedItem[@type='otherVersion']/Q{http://www.loc.gov/mods/v3}titleInfo/Q{http://www.loc.gov/mods/v3}title</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}relatedItem[@type='references']/Q{http://www.loc.gov/mods/v3}titleInfo/Q{http://www.loc.gov/mods/v3}title</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}relatedItem[@type='isReferencedBy']/Q{http://www.loc.gov/mods/v3}titleInfo/Q{http://www.loc.gov/mods/v3}title</path>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template for the Notes -->
    <xsl:template name="add-notes">

        <!-- Heading for this section -->
        <xsl:call-template name="mainSectionHeaderTemplate">
            <xsl:with-param name="sectionName">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName">
                        <path>notesHeader</path>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <!-- The individual fields -->
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='biographyHistory']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='history']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='acquisition']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='appraisal']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='accrual']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='bibliography']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='other']</path>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="add-big-field-node">
            <xsl:with-param name="field">
                <path>/Q{http://www.loc.gov/mods/v3}mods/Q{http://www.loc.gov/mods/v3}note[@type='processinfo']</path>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Template to deal with name value pair sections -->
    <xsl:template match="mods:mods/mods:recordInfo/mods:recordIdentifier
                     |mods:mods/mods:recordInfo/mods:recordOrigin
                     |mods:mods/mods:recordInfo/mods:recordCreationDate
                     |mods:mods/mods:recordInfo/mods:descriptionStandard
                     |mods:mods/mods:titleInfo/mods:title
                     |mods:mods/mods:typeOfResource
                     |mods:mods/mods:name/mods:namePart
                     |mods:mods/mods:originInfo/mods:dateCreated
                     |mods:mods/mods:originInfo/mods:dateOther
                     |mods:mods/mods:language/mods:languageTerm
                     |mods:mods/mods:physicalDescription/mods:extent
                     |mods:mods/mods:physicalDescription/mods:form
                     |mods:mods/mods:physicalDescription/mods:note">
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

    <!-- Template to deal with big value sections -->
    <xsl:template match="mods:mods/mods:note
                     |mods:mods/mods:accessCondition
                     |mods:mods/mods:subject/mods:topic
                     |mods:mods/mods:location/mods:physicalLocation
                     |mods:mods/mods:relatedItem/mods:titleInfo/mods:title">
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