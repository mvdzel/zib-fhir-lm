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
		This now generated STU3 Structure Definitions for ZIB's.
		For this to work on DSTU2 servers remove:
		- <title>
		- <purpose>
		- <keywords>
		- <type>
		
		Somehow we need to use the FHIR datatypes to make all the tooling work.
		For ClinFHIR to work we also need:
			<extension url="http:www.clinfhir.com/StructureDefinition/userEmail">
	   			<valueString value="david.hay25@gmail.com" />
			</extension>
	   		<url value="..."/>
			<identifier>
	   			<system value="http://clinfhir.com" />
	   			<value value="author" />
			</identifier>
	 -->
	
	<xsl:variable name="datatypes">
		<datatype id="7887" dcm="TS" fhir="dateTime"/>
		<datatype id="7906" dcm="CD" fhir="Coding"/>
		<datatype id="7895" dcm="ST" fhir="string"/>
		<datatype id="7891" dcm="PQ" fhir="Quantity"/>
		<datatype id="7892" dcm="BL" fhir="boolean"/>
		<datatype id="7888" dcm="INT" fhir="integer"/>
		<datatype id="7886" dcm="CO" fhir="Coding"/>
		<datatype id="7885" dcm="ED" fhir="base64Binary"/>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:for-each select="/max:model/objects/object[stereotype='DCM']">
			<xsl:variable name="dcm" select="."/>
			<xsl:variable name="dcmid" select="$dcm/id"/>
			<xsl:variable name="im" select="/max:model/objects/object[parentId=$dcmid and name='Information Model']"/>
			<xsl:variable name="imid" select="$im/id"/>
			<xsl:variable name="dcmname" select="tag[@name='DCM::Name']/@value"/>
			
			<xsl:variable name="href" select="concat('file:/c:/temp/dcm2fhirlm/',$dcmname,'.xml')"/>
			<xsl:value-of select="$href"/><xsl:text>
</xsl:text>
			<xsl:result-document href="{$href}" format="xml">
				<fhir:StructureDefinition>
				  <fhir:url><xsl:attribute name="value"><xsl:value-of select="concat('https://zibs.nl/zibs/',$dcmname)"/></xsl:attribute></fhir:url>
			      <fhir:id><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::Id']/@value"/></xsl:attribute></fhir:id>
			      <fhir:language value="nl"/>
			      <fhir:version><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::Version']/@value"/></xsl:attribute></fhir:version>
				  <fhir:name><xsl:attribute name="value"><xsl:value-of select="$dcmname"/></xsl:attribute></fhir:name>
				  <fhir:title><xsl:attribute name="value"><xsl:value-of select="$dcmname"/></xsl:attribute></fhir:title>
				  <fhir:status value="draft" />
				  <xsl:variable name="datecomps" select="tokenize(tag[@name='DCM::RevisionDate']/@value,'-')"/>
				  <xsl:variable name="revdate" select="concat(format-number($datecomps[3],'0000'),'-',format-number($datecomps[2],'00'),'-',format-number($datecomps[1],'00'))"/>
				  <fhir:date><xsl:attribute name="value"><xsl:value-of select="$revdate"/></xsl:attribute></fhir:date>
			      <fhir:contact><fhir:name><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::EndorsingAuthority.Name']/@value"/></xsl:attribute></fhir:name></fhir:contact>
			      <xsl:variable name="description"><xsl:value-of select="/max:model/objects/object[parentId=$dcmid and name='Concept']/notes" disable-output-escaping="yes"/></xsl:variable>
			      <xsl:variable name="purpose"><xsl:value-of select="/max:model/objects/object[parentId=$dcmid and name='Purpose']/notes" disable-output-escaping="yes"/></xsl:variable>
			      <xsl:variable name="copyright"><xsl:value-of select="/max:model/objects/object[parentId=$dcmid and name='Copyrights']/notes" disable-output-escaping="yes"/></xsl:variable>
				  <fhir:description><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($description,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:description>
				  <fhir:purpose><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($purpose,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:purpose>
				  <fhir:copyright><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($copyright,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:copyright>
				  <fhir:keyword><fhir:display><xsl:attribute name="value"><xsl:value-of select="tag[@name='DCM::KeywordList']/@value"/></xsl:attribute></fhir:display></fhir:keyword>
				  <fhir:kind value="logical" />
				  <fhir:abstract value="false" />
				  <fhir:type value="ZIB" />
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
					  	<xsl:variable name="cid" select="sourceId"/>
					  	<xsl:variable name="concept" select="/max:model/objects/object[id=$cid]"/>
					  	<xsl:variable name="cname" select="$concept/name"/>
					  	<fhir:element>
				  	  	  <xsl:attribute name="id"><xsl:value-of select="$concept/tag[@name='DCM::DefinitionCode' and starts-with(@value,'NL-CM:')]/@value"/></xsl:attribute>
					      <fhir:path><xsl:attribute name="value"><xsl:value-of select="concat($rcname,'.',$cname)"/></xsl:attribute></fhir:path>
					      <fhir:label><xsl:attribute name="value"><xsl:value-of select="$cname"/></xsl:attribute></fhir:label>
					      <!-- obv DefinitionCodes <fhir:code></fhir:code> -->
					      <fhir:definition><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($concept/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:definition>
					      <xsl:variable name="card" select="sourceCard"/>
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
						      	<!-- <fhir:code><xsl:attribute name="value"><xsl:value-of select="concat('https://zibs.nl/datatypes/',$datatypes/datatype[@id=$datatypeid]/@dcm)"/></xsl:attribute></fhir:code> -->
					      		<fhir:code><xsl:attribute name="value"><xsl:value-of select="$datatypes/datatype[@id=$datatypeid]/@fhir"/></xsl:attribute></fhir:code>
						      </fhir:type>
					      </xsl:if>
					      <xsl:if test="exists($concept/tag[@name='DCM::ReferencedDefinitionCode'])">
					      	  <fhir:type>
						      	<fhir:code value="Reference"/>
						      	<fhir:profile><xsl:attribute name="value"><xsl:value-of select="$concept/tag[@name='DCM::ReferencedDefinitionCode']/@value"/></xsl:attribute></fhir:profile>
					      	  </fhir:type>
					      </xsl:if>
					    </fhir:element>
					    
					    <xsl:if test="$concept/stereotype='container'">
						    <xsl:for-each select="/max:model/relationships/relationship[destId=$cid and type='Aggregation']">
							  	<xsl:variable name="cid2" select="sourceId"/>
							  	<xsl:variable name="concept2" select="/max:model/objects/object[id=$cid2]"/>
							  	<xsl:variable name="cname2" select="$concept2/name"/>
							  	<fhir:element>
						  	  	  <xsl:attribute name="id"><xsl:value-of select="$concept2/tag[@name='DCM::DefinitionCode' and starts-with(@value,'NL-CM:')]/@value"/></xsl:attribute>
							      <fhir:path><xsl:attribute name="value"><xsl:value-of select="concat($rcname,'.',$cname,'.',$cname2)"/></xsl:attribute></fhir:path>
							      <fhir:label><xsl:attribute name="value"><xsl:value-of select="$cname2"/></xsl:attribute></fhir:label>
							      <!-- obv DefinitionCodes <fhir:code></fhir:code> -->
							      <fhir:definition><xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after($concept2/notes,'&lt;nl-NL&gt;'),'&lt;/nl-NL&gt;')"/></xsl:attribute></fhir:definition>
							      <xsl:variable name="card2" select="sourceCard"/>
							      <xsl:choose>
								      <xsl:when test="contains($card2,'..')">
									      <fhir:min><xsl:attribute name="value"><xsl:value-of select="substring-before($card2,'..')"/></xsl:attribute></fhir:min>
									      <fhir:max><xsl:attribute name="value"><xsl:value-of select="substring-after($card2,'..')"/></xsl:attribute></fhir:max>
									  </xsl:when>
								      <xsl:when test="$card2='1'">
									      <fhir:min value="1"/>
									      <fhir:max value="1"/>
									  </xsl:when>
							      </xsl:choose>
					      		  <xsl:if test="exists(/max:model/relationships/relationship[sourceId=$cid2 and type='Generalization'])">
							      	<fhir:type>
							      		<xsl:variable name="datatypeid2" select="/max:model/relationships/relationship[sourceId=$cid2 and type='Generalization']/destId"/>
							      		<!-- <fhir:code><xsl:attribute name="value"><xsl:value-of select="concat('https://zibs.nl/datatypes/',$datatypes/datatype[@id=$datatypeid2]/@zib)"/></xsl:attribute></fhir:code> -->
							      		<fhir:code><xsl:attribute name="value"><xsl:value-of select="$datatypes/datatype[@id=$datatypeid2]/@fhir"/></xsl:attribute></fhir:code>
							      	</fhir:type>
							      </xsl:if>
							      <xsl:if test="exists($concept2/tag[@name='DCM::ReferencedDefinitionCode'])">
							      	  <fhir:type>
								      	<fhir:code value="Reference"/>
								      	<fhir:targetProfile><xsl:attribute name="value"><xsl:value-of select="$concept2/tag[@name='DCM::ReferencedDefinitionCode']/@value"/></xsl:attribute></fhir:targetProfile>
							      	  </fhir:type>
							      </xsl:if>
							    </fhir:element>
							</xsl:for-each>
					    </xsl:if>
					    
				    </xsl:for-each>
				    
				  </fhir:snapshot>
				</fhir:StructureDefinition>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>