<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xpath-default-namespace="http://www.openarchives.org/OAI/2.0/" exclude-result-prefixes="xs"
    version="2.0">

    <!-- 
       This stylesheet takes the result of an OAI-PMH "ListSets" request,
       makes a "ListRecord" request per collection given in <setSpec>,
       and saves the results as one XML file of records per collection. 
       
       The query is repeated for each resumption token.
       
       Records with status "deleted" are excluded from the output. 
       
       Params 'client' and 'metadataPrefix' default to EBRPL digital archive 
       and oai_dc but can be overwritten. 
    -->

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="client" select="'https://cdm16340.contentdm.oclc.org'"/>
    <xsl:param name="metadataPrefix" select="'oai_dc'"/>

    <xsl:template match="@* | node()">
        <xsl:apply-templates select="ListSets"/>
    </xsl:template>

    <xsl:template match="ListSets">
        <xsl:for-each select="set/setSpec">
            <xsl:variable name="coll" select="."/>
            <xsl:variable name="query">
                <xsl:value-of
                    select="concat($client,'/oai/oai.php?verb=ListRecords&amp;metadataPrefix=',$metadataPrefix,'&amp;set=',$coll)"
                />
            </xsl:variable>
            <xsl:result-document method="xml" href="{$coll}-{$metadataPrefix}.xml">
                <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
                    <responseDate>
                        <xsl:value-of select="current-dateTime()"/>
                    </responseDate>
                    <xsl:element name="request">
                        <xsl:attribute name="verb" select="'ListRecords'"/>
                        <xsl:attribute name="metadataPrefix" select="$metadataPrefix"/>
                        <xsl:attribute name="set" select="$coll"/>
                    </xsl:element>
                    <ListRecords>
                        <xsl:for-each select="document($query)//record">
                            <xsl:choose>
                                <xsl:when test="header/@status = 'deleted'"/>
                                <xsl:otherwise>
                                    <xsl:copy-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:apply-templates select="document($query)//resumptionToken[not(. = '')]"
                        />
                    </ListRecords>
                </OAI-PMH>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="resumptionToken[not(. = '')]">
        <xsl:variable name="token" select="."/>
        <xsl:variable name="tokenQuery"
            select="concat($client,'/oai/oai.php?verb=ListRecords&amp;resumptionToken=',$token)"/>
        <xsl:for-each select="document($tokenQuery)//record">
            <xsl:choose>
                <xsl:when test="header/@status = 'deleted'"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:apply-templates select="document($tokenQuery)//resumptionToken[not(. = '')]"/>
    </xsl:template>

</xsl:stylesheet>