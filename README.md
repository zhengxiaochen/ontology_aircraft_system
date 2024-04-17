# ontology_aircraft_system
This repository contains:
1) Instroduction to Neo4j installation on Azure Ubuntu VM.docx: Installation and configuration of Neo4j on Azure.
2) Instroduction to ontology import and edit with Neo4j.docx: how to import and query (add/edit/remove) ontologies in Neo4j with Cypher.
3) CYPHER_import_edit_ontology.cyp: The raw code of ontology import and edit with Neo4j
4) Instroduction to Python script.docx:introduction to the python scripts for automatically generating aircraft assembly processes based on the application ontology.
5) auto_generate_process.py: Python scripts for automatically generating aircraft assembly processes based on the application ontology.
6) Aircraft_assembly_process_ontology.ttl: the application ontology to be imported to Neo4j. It contains some predefined classes about assembly process.


Update 20240417:
Correct a couples of errors. Update the the following codes in "Instroduction to ontology import and edit with Neo4j.docx"


CALL n10s.graphconfig.init();
CREATE CONSTRAINT n10s_unique_uri FOR (r:Resource) REQUIRE r.uri IS UNIQUE

Ontology address (Letter A should be a):
https://raw.githubusercontent.com/zhengxiaochen/ontology_aircraft_system/main/aircraft_assembly_process_ontology.ttl

Parameter value of handleVocabUris should be MAP 
CALL n10s.graphconfig.init({ handleVocabUris: 'MAP' });


