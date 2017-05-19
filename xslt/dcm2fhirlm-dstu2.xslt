<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:max="http://www.umcg.nl/MAX"
	xmlns:fhir="http://hl7.org/fhir"
	exclude-result-prefixes="max xsi xsd">

	<xsl:output method="text"/>
	<xsl:output encoding="utf-8" indent="yes" method="xml" name="xml"/>
	
	<!--
		This generates DSTU2 Structure Definitions for ZIB's.
		
		Somehow we need to use the FHIR datatypes to make all the tooling work.
		For ClinFHIR to work we also need:
			<identifier>
	   			<system value="http://clinfhir.com" />
	   			<value value="author" />
			</identifier>
	 -->
	
	<xsl:variable name="NL-CM">2.16.840.1.113883.2.4.3.11.60.40.3.</xsl:variable>
	<xsl:variable name="url-prefix">https://zibs.nl/fhir/StructureDefinition/</xsl:variable>
	<xsl:variable name="datatypes">
		<datatype id="7887" dcm="TS" fhir="dateTime"/>
		<datatype id="7906" dcm="CD" fhir="Coding"/>
		<datatype id="7895" dcm="ST" fhir="string"/>
		<datatype id="7891" dcm="PQ" fhir="Quantity"/>
		<datatype id="7892" dcm="BL" fhir="boolean"/>
		<datatype id="7888" dcm="INT" fhir="integer"/>
		<datatype id="7886" dcm="CO" fhir="Coding"/>
		<datatype id="7885" dcm="ED" fhir="base64Binary"/>
		<datatype id="7889" dcm="II" fhir="Identifier"/>
		<datatype id="7903" dcm="ANY" fhir="Element"/>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:for-each select="/max:model/objects/object[stereotype='DCM']">
			<xsl:variable name="dcm" select="."/>
			<xsl:variable name="dcmid" select="$dcm/id"/>
			<xsl:variable name="im" select="/max:model/objects/object[parentId=$dcmid and name='Information Model']"/>
			<xsl:variable name="imid" select="$im/id"/>
			<xsl:variable name="dcmname" select="tag[@name='DCM::Name']/@value"/>
			<xsl:variable name="dcmid" select="tag[@name='DCM::Id']/@value"/>
			
			<xsl:variable name="href" select="concat('file:/c:/temp/dcm2fhirlm/',$dcmname,'.xml')"/>
			<xsl:value-of select="$href"/><xsl:text>
</xsl:text>
			<xsl:result-document href="{$href}" format="xml">
				<fhir:StructureDefinition>
			      <fhir:id><xsl:attribute name="value"><xsl:value-of select="$dcmid"/></xsl:attribute></fhir:id>
				  <fhir:url><xsl:attribute name="value"><xsl:value-of select="concat($url-prefix,$dcmid)"/></xsl:attribute></fhir:url>
				  <fhir:identifier>
				    <fhir:system value="http://clinfhir.com" />
				    <fhir:value value="author" />
				  </fhir:identifier>
				  <fhir:language value="nl"/>
			      <fhir:version><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::Version']/@value"/></xsl:attribute></fhir:version>
				  <fhir:name><xsl:attribute name="value"><xsl:value-of select="$dcmname"/></xsl:attribute></fhir:name>
				  <fhir:status value="draft" />
				  <xsl:variable name="datecomps" select="tokenize(tag[@name='DCM::RevisionDate']/@value,'-')"/>
				  <xsl:variable name="revdate" select="concat(format-number($datecomps[3],'0000'),'-',format-number($datecomps[2],'00'),'-',format-number($datecomps[1],'00'))"/>
				  <fhir:date><xsl:attribute name="value"><xsl:value-of select="$revdate"/></xsl:attribute></fhir:date>
			      <fhir:contact><fhir:name><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::EndorsingAuthority.Name']/@value"/></xsl:attribute></fhir:name></fhir:contact>
			      <xsl:variable name="description"><xsl:value-of select="/max:model/objects/object[parentId=$dcmid and name='Concept']/notes" disable-output-escaping="yes"/></xsl:variable>
			      <xsl:variable name="copyright"><xsl:value-of select="/max:model/objects/object[parentId=$dcmid and name='Copyrights']/notes" disable-output-escaping="yes"/></xsl:variable>
				  <fhir:description><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($description,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:description>
				  <fhir:copyright><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($copyright,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:copyright>
				  <fhir:kind value="logical" />
				  <fhir:abstract value="false" />
				  <fhir:snapshot>
				  	<xsl:variable name="rootconcept" select="/max:model/objects/object[parentId=$imid and stereotype='rootconcept']"/>
				  	<xsl:variable name="rcid" select="$rootconcept/id"/>
				  	<xsl:variable name="rcname" select="$rootconcept/name"/>
				  	 <fhir:element>
				  	  <xsl:attribute name="id"><xsl:value-of select="$rootconcept/tag[@name='DCM::DefinitionCode' and starts-with(@value,'NL-CM:')]/@value"/></xsl:attribute>
				      <fhir:path><xsl:attribute name="value"><xsl:value-of select="$rcname"/></xsl:attribute></fhir:path>
				      <!-- obv DefinitionCodes <fhir:code></fhir:code> -->
				      <fhir:definition><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($rootconcept/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:definition>
				    </fhir:element>
				    
				    <xsl:for-each select="/max:model/relationships/relationship[destId=$rcid and type='Aggregation']">
				    	<xsl:call-template name="ElementDefinition">
				    		<xsl:with-param name="path-prefix" select="$rcname"/>
				    		<xsl:with-param name="relationship" select="."/>
				    	</xsl:call-template>
				    </xsl:for-each>
				  </fhir:snapshot>
				</fhir:StructureDefinition>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="ElementDefinition">
		<xsl:param name="path-prefix"/>
		<xsl:param name="relationship"/>
	  	<xsl:variable name="cid" select="$relationship/sourceId"/>
	  	<xsl:variable name="concept" select="/max:model/objects/object[id=$cid]"/>
	  	<xsl:variable name="cname" select="$concept/name"/>
	  	<fhir:element>
  	  	  <xsl:attribute name="id"><xsl:value-of select="$concept/tag[@name='DCM::DefinitionCode' and starts-with(@value,'NL-CM:')]/@value"/></xsl:attribute>
	      <fhir:path><xsl:attribute name="value"><xsl:value-of select="concat($path-prefix,'.',$cname)"/></xsl:attribute></fhir:path>
	      <fhir:label><xsl:attribute name="value"><xsl:value-of select="$cname"/></xsl:attribute></fhir:label>
	      <!-- obv DefinitionCodes <fhir:code></fhir:code> -->
	      <fhir:definition><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($concept/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:definition>
	      <xsl:variable name="card" select="$relationship/sourceCard"/>
	      <xsl:choose>
		      <xsl:when test="contains($card,'..')">
			      <fhir:min><xsl:attribute name="value"><xsl:value-of select="substring-before($card,'..')"/></xsl:attribute></fhir:min>
			      <fhir:max><xsl:attribute name="value"><xsl:value-of select="substring-after($card,'..')"/></xsl:attribute></fhir:max>
			  </xsl:when>
		      <xsl:when test="$card='1'">
			      <fhir:min value="1"/>
			      <fhir:max value="1"/>
			  </xsl:when>
	      </xsl:choose>
	      <xsl:if test="exists(/max:model/relationships/relationship[sourceId=$cid and type='Generalization'])">
		      <fhir:type>
		      	<xsl:variable name="datatypeid" select="/max:model/relationships/relationship[sourceId=$cid and type='Generalization']/destId"/>
	      		<fhir:code><xsl:attribute name="value"><xsl:value-of select="$datatypes/datatype[@id=$datatypeid]/@fhir"/></xsl:attribute></fhir:code>
		      </fhir:type>
	      </xsl:if>
	      <xsl:if test="exists($concept/tag[@name='DCM::ReferencedDefinitionCode'])">
	      	  <fhir:type>
		      	<fhir:code value="Reference"/>
		      	<fhir:profile><xsl:attribute name="value"><xsl:value-of select="concat($url-prefix,replace($concept/tag[@name='DCM::ReferencedDefinitionCode']/@value,'NL-CM:',$NL-CM))"/></xsl:attribute></fhir:profile>
	      	  </fhir:type>
	      </xsl:if>
	    </fhir:element>

	    <xsl:if test="$concept/stereotype='container'">
		    <xsl:for-each select="/max:model/relationships/relationship[destId=$cid and type='Aggregation']">
		    	<xsl:call-template name="ElementDefinition">
		    		<xsl:with-param name="path-prefix" select="concat($path-prefix,'.',$cname)"/>
		    		<xsl:with-param name="relationship" select="."/>
		    	</xsl:call-template>
			</xsl:for-each>
	    </xsl:if>
	</xsl:template>

</xsl:stylesheet>