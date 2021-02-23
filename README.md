# Run the XSLT

Download saxon.jar from https://www.saxonica.com/download/java.xml

Install the EA MAX Extension
https://wiki.hl7.org/MAX_-_Model_Automated_eXchange

Export the whole DCM Profile compliant EA model(s), including the <<DCM>> packages!

Run saxon example
```
> java -jar saxon9he.jar -s:example/ExampleDCM.max -xsl:xslt/dcm2fhirlm-stu3.xslt
```
Output (FHIR Logical Model Structuredefinitions XMLs) will be in /tmp/dcm2fhirlm.

# Run the IG Publisher

```
> cp /tmp/dcm2fhirlm/* /home/michael/eclipse-workspace/sample-ig/input/resources
> java -jar ../latest-ig-publisher/org.hl7.fhir.publisher.jar -ig ig.ini
```

# TODO xslt
* Translate codesystem name to URI
* Replace 'ë' special chars in paths! Now replaced in input max file.
* Put ZIB:ConceptId in mapping?
* Convert <reference> to FHIR reference
* There is something wrong with some descriptions. E.g. nl.zorg.Alert, nl.zorg.Contact, ..
