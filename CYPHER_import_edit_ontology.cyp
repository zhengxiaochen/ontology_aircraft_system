##########################Configurations#####################
##'Airbus Graph DBMS' password: qu4lity
##https://neo4j.com/labs/neosemantics/4.2/config/
###database ini config.
CALL n10s.graphconfig.init();
CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;

##########################Import ontology###############
//#https://neo4j.com/labs/neosemantics/4.2/importing-ontologies/
//#Delete all nodes and relationships
MATCH (n) DETACH DELETE n
//!!!Use MAP instead of IGNORE: https://community.neo4j.com/t/problem-exporting-rdf-using-neosemantics-N010s/20880/9
call n10s.graphconfig.init({ handleVocabUris: 'MAP' });
//define Prefix for better visualize
CALL n10s.nsprefixes.add("prefix", "neo4j://orbitaljoint#");
call n10s.mapping.add("neo4j://orbitaljoint#/process", "Process");
call n10s.mapping.add("neo4j://orbitaljoint#/operation", "Operation");
call n10s.mapping.add("neo4j://orbitaljoint#/haspredecessor", "hasPredecessor");
call n10s.mapping.add("neo4j://orbitaljoint#/requiresresource", "requiresResource");
call n10s.mapping.add("neo4j://orbitaljoint#/isindividualof", "isIndividualOf");
call n10s.mapping.add("neo4j://orbitaljoint#/issubclassof", "isSubclassOf");
call n10s.mapping.add("neo4j://orbitaljoint#/hasEssentialOperation", "hasEssentialOperation");
call n10s.mapping.add("neo4j://orbitaljoint#/hasSubprocess", "hasSubprocess");
call n10s.mapping.add("neo4j://orbitaljoint#/hasOptionalOperation", "hasOptionalOperation");
call n10s.mapping.add("neo4j://orbitaljoint#/hasOperation", "hasOperation");
call n10s.mapping.add("neo4j://orbitaljoint#/hasOptionalAutoOperation", "hasOptionalAutoOperation");
call n10s.mapping.add("neo4j://orbitaljoint#/hasOptionalManualOperation", "hasOptionalManualOperation");

call n10s.onto.import.fetch("file:///C:\\Users\\hello\\Downloads\\airbus_application_ontology_mvp5.ttl","Turtle",{ handleVocabUris: "MAP" })
//CALL n10s.onto.import.fetch("https://raw.githubusercontent.com/zhengxiaochen/qu4lity_airbus_ontology/main/airbus_ontology.ttl","Turtle");
//set label for visualizing classes
MATCH (n:Resource) SET n.n4sch__label=n.label RETURN n;
//Rename Resource name to n4sch__Class
MATCH (n:Resource)
WITH collect(n) AS n1
CALL apoc.refactor.rename.label("Resource", "n4sch__Class", n1)
YIELD committedOperations
RETURN *;
//Object properties (relationships) are imported as Nodes
////set label for visualizing relationships
MATCH (p:Class)-[r]-(q:Class) WITH DISTINCT r MATCH (cr:Relationship) WHERE cr.uri CONTAINS r.onPropertyURI SET r.onPropertyName=cr.label;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasEssentialOperation"
CREATE (p)-[:hasEssentialOperation]->(q);
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasEssentialOperation"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasPredecessor"
CREATE (p)-[:hasPredecessor]->(q);
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasPredecessor"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "requiresResource"
CREATE (p)-[:requiresResource]->(q) ;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "requiresResource"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasSubprocess"
CREATE (p)-[:hasSubprocess]->(q) ;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasSubprocess"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalOperation"
CREATE (p)-[:hasOptionalOperation]->(q);
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalOperation"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalAutoOperation"
CREATE (p)-[:hasOptionalAutoOperation]->(q);
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalAutoOperation"
DETACH DELETE r;
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalManualOperation"
CREATE (p)-[:hasOptionalManualOperation]->(q);
MATCH (p:Class)-[r:SCO_RESTRICTION]->(q:Class) WHERE r.onPropertyName CONTAINS "hasOptionalManualOperation"
DETACH DELETE r;
MATCH (op:n4sch__Class) SET op.name=op.n4sch__label; //#SET all operations labels = name
//#############update data properties lost during import##########################
//Operation data properties ##############
MATCH (p:n4sch__Class {n4sch__label: 'S40_00001_Jig in'}) SET p.duration = 60, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_00002_Jig out'}) SET p.duration = 60, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_01001_Set up working environment'}) SET p.duration = 10, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_02001_Set in position Rails and LFT'}) SET p.duration = 10, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04001_Camera at stating holes'}) SET p.duration = 15, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04002_Drilling orbital 4,8'}) SET p.duration = 125, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04008_Set up the fixations LGP/Hi-Lite automatic'}) SET p.duration = 20, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04010_Riveting buttstraps and stabiliser automatic'}) SET p.duration = 90, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04012_Deburring int, positioning, attach them automatic'}) SET p.duration = 25, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04014_Deinstall LFT and rails'}) SET p.duration = 35, p.op_type = "Auto";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04003_Drilling template install'}) SET p.duration = 25, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04004_Fixation drilling template suite manual'}) SET p.duration = 30, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04005_Drilling (with adapter) 3,2 on Stringers int and drilling template'}) SET p.duration = 185, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04006_Deinstall drilling template'}) SET p.duration = 25, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04007_Set in position temporary fastener'}) SET p.duration = 15, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04009_Set up the fixations LGP/Hi-Lite manual'}) SET p.duration = 35, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04011_Riveting buttstraps and stabiliser manual'}) SET p.duration = 180, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_04013_Deburring int, positioning, attach them manual'}) SET p.duration = 45, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_02002_Cleanup and add sealant'}) SET p.duration = 35, p.op_type = "Manual";
MATCH (p:n4sch__Class {n4sch__label: 'S40_02003_Inspection'}) SET p.duration = 55, p.op_type = "Manual";
//Resource quantity##############
MATCH (p:n4sch__Class {n4sch__label: 'Light Flex Track Robot'}) SET p.cost_hour= 75, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'Light Flex Track Rail'}) SET p.cost_hour= 5, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'Station'}) SET p.cost_hour= 80, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'Station platform'}) SET p.cost_hour= 75, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'Mechanical Operator'}) SET p.cost_hour= 100, p.calendar= "shift_40h_week", p.number = 8;
MATCH (p:n4sch__Class {n4sch__label: 'Automation Operator'}) SET p.cost_hour= 100, p.calendar= "shift_40h_week", p.number = 8;
MATCH (p:n4sch__Class {n4sch__label: 'Hand drilling machine'}) SET p.cost_hour= 10, p.calendar= "24x7", p.number = 6;
MATCH (p:n4sch__Class {n4sch__label: 'Drilling Template'}) SET p.cost_hour= 10, p.calendar= "24x7", p.number = 5;
MATCH (p:n4sch__Class {n4sch__label: 'Crane'}) SET p.cost_hour= 30, p.calendar= "24x7", p.number = 1;
MATCH (p:n4sch__Class {n4sch__label: 'Transportation tooling'}) SET p.cost_hour= 80, p.calendar= "24x7", p.number = 1;
//Set Operation resources
MATCH (p:n4sch__Class)-[r:requiresResource]->(o:n4sch__Class) WHERE p.name STARTS WITH 'S40_0'
DETACH DELETE r;
MATCH (o19:n4sch__Class),(o20:n4sch__Class),(o1:n4sch__Class), (o2:n4sch__Class), (o3:n4sch__Class), (o4:n4sch__Class), (o5:n4sch__Class), (o6:n4sch__Class), (o7:n4sch__Class), (o8:n4sch__Class), (o9:n4sch__Class), (o10:n4sch__Class), (o11:n4sch__Class), (o12:n4sch__Class), (o13:n4sch__Class), (o14:n4sch__Class), (o15:n4sch__Class), (o16:n4sch__Class), (o17:n4sch__Class), (o18:n4sch__Class), (r11:n4sch__Class { name: "Mechanical Operator" }),(r12:n4sch__Class { name: "Automation Operator" }),(r2:n4sch__Class { name: "Light Flex Track Robot" }),(r3:n4sch__Class { name: "Light Flex Track Rail" }),(r4:n4sch__Class { name: "Hand drilling machine" }),(r5:n4sch__Class { name: "Drilling Template" }),(r6:n4sch__Class { name: "Station platform" }),(r7:n4sch__Class { name: "Station" }),(r8:n4sch__Class { name: "Crane" }),(r9:n4sch__Class { name: "Transportation tooling" })
WHERE o1.name STARTS WITH 'S40_01001' AND o2.name STARTS WITH 'S40_02001' AND o3.name STARTS WITH 'S40_04001' AND o4.name STARTS WITH 'S40_04002' AND o5.name STARTS WITH 'S40_04003' AND o6.name STARTS WITH 'S40_04004' AND o7.name STARTS WITH 'S40_04005' AND o8.name STARTS WITH 'S40_04006' AND o9.name STARTS WITH 'S40_04007' AND o10.name STARTS WITH 'S40_04008' AND o11.name STARTS WITH 'S40_04009' AND o12.name STARTS WITH 'S40_04010' AND o13.name STARTS WITH 'S40_04011' AND o14.name STARTS WITH 'S40_04012' AND o15.name STARTS WITH 'S40_04013' AND o16.name STARTS WITH 'S40_04014' AND o17.name STARTS WITH 'S40_02002' AND o18.name STARTS WITH 'S40_02003' AND o19.name STARTS WITH 'S40_00001' AND o20.name STARTS WITH 'S40_00002'
CREATE (o1)-[:requiresResource {number: 1}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o1)-[:requiresResource {number:1}]->(r7),
(o2)-[:requiresResource {number:2}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o2)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o2)-[:requiresResource {number:1}]->(r7),
(o3)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o3)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o3)-[:requiresResource {number:1}]->(r7),
(o4)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o4)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o4)-[:requiresResource {number:1}]->(r7),
(o5)-[:requiresResource {number:2}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o5)-[:requiresResource {number:1}]->(r7),
(o6)-[:requiresResource {number:2}]->(r11), (o6)-[:requiresResource {number:1}]->(r5),(r6)<-[:requiresResource {number: 1}]-(o6)-[:requiresResource {number:1}]->(r7),
(o7)-[:requiresResource {number:2}]->(r11), (r4)<-[:requiresResource {number:2}]-(o7)-[:requiresResource {number:1}]->(r5),(r6)<-[:requiresResource {number: 1}]-(o7)-[:requiresResource {number:1}]->(r7),
(o8)-[:requiresResource {number:2}]->(r11), (o8)-[:requiresResource {number:1}]->(r5),(r6)<-[:requiresResource {number: 1}]-(o8)-[:requiresResource {number:1}]->(r7),
(o9)-[:requiresResource {number:2}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o9)-[:requiresResource {number:1}]->(r7),
(o10)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o10)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o10)-[:requiresResource {number:1}]->(r7),
(o12)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o12)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o12)-[:requiresResource {number:1}]->(r7),
(o14)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o14)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o14)-[:requiresResource {number:1}]->(r7),
(o16)-[:requiresResource {number:1}]->(r12), (r2)<-[:requiresResource {number: 1}]-(o16)-[:requiresResource {number:1}]->(r3), (r6)<-[:requiresResource {number: 1}]-(o16)-[:requiresResource {number:1}]->(r7),
(o11)-[:requiresResource {number:2}]->(r11),
(o13)-[:requiresResource {number:2}]->(r11),
(o15)-[:requiresResource {number:2}]->(r11),
(o17)-[:requiresResource {number:2}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o17)-[:requiresResource {number:1}]->(r7),
(o18)-[:requiresResource {number:2}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o18)-[:requiresResource {number:1}]->(r7), (r8)<-[:requiresResource {number: 1}]-(o19)-[:requiresResource {number:1}]->(r9), (r8)<-[:requiresResource {number: 1}]-(o20)-[:requiresResource {number:1}]->(r9);



##########################Example showing how to generate a new process by step##########################
//#####create new process
//## structure of the process
//MATCH (op) WHERE op.name STARTS WITH 'N01' DETACH DELETE op;

MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})
CREATE (np:Process{name: "R01" + p.n4sch__label}), (np)-[:isIndividualOf]->(p)
WITH * MATCH (p)-[:hasEssentialOperation]->(Eop:n4sch__Class)
WITH DISTINCT Eop,np,p CREATE (nEop :Operation{name: "N01" + Eop.n4sch__label}), (nEop)-[:isIndividualOf]->(Eop), (np)-[:hasOperation]->(nEop)
WITH * MATCH (Eop)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1)
MERGE (nEop)-[:hasPredecessor]->(pr1)
RETURN * //3 EssentialOperation:Jig in, Jig out, set environment


//Subprocess EssentialOperation
MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasEssentialOperation]->(e:n4sch__Class)//sc:upper and lower half
WITH DISTINCT e
CREATE (oe1:Operation{name: "N01" + e.n4sch__label+"_1"})-[:isIndividualOf]->(e), (oe2:Operation{name: "N01" + e.n4sch__label+"_2"})-[:isIndividualOf]->(e)
WITH * MATCH (e)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2)
WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH 'N01' AND pr2.name STARTS WITH 'N01'
MERGE (oe1)-[:hasPredecessor]->(pr1) MERGE (oe2)-[:hasPredecessor]->(pr2)
RETURN *

//Subprocess OPTIONALautomated
MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasOptionalAutoOperation]->(Oop:n4sch__Class)
WITH DISTINCT Oop CREATE (nOop:Operation{name: 'N01' + Oop.n4sch__label})-[:isIndividualOf]->(Oop)
WITH * MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc)-[:hasSubprocess]->(ssc)-[:hasOptionalAutoOperation]->(Oop1)
WITH DISTINCT Oop1 CREATE (nOop1:Operation{name: 'N01' + Oop1.n4sch__label + '_1'})-[:isIndividualOf]->(Oop1), (nOop2:Operation{name: 'N01' + Oop1.n4sch__label + '_2'})-[:isIndividualOf]->(Oop1)
WITH * MATCH (Oop1)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH 'N01' AND pr2.name STARTS WITH 'N01'
MERGE (nOop1)-[:hasPredecessor]->(pr1) MERGE (nOop2)-[:hasPredecessor]->(pr2)
WITH * MATCH (p1:Operation), (p2:Operation), (p3:Operation), (p4:Operation), (p5:Operation), (p6:Operation) WHERE p1.name CONTAINS 'N01Camera at stating holes_1' AND p2.name CONTAINS 'N01Deburring int, positioning, attach them automatic_1' AND p3.name CONTAINS 'N01Camera at stating holes_2' AND p4.name CONTAINS 'N01Deburring int, positioning, attach them automatic_2' AND p5.name CONTAINS 'N01Set in position Rails and LFT' AND p6.name CONTAINS 'N01Deinstall LFT and rails'
MERGE (p1)-[:hasPredecessor]->(p5) MERGE (p3)-[:hasPredecessor]->(p2) MERGE (p6)-[:hasPredecessor]->(p4)
RETURN *

//Subprocess anual sequencial subprocess
MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc)-[:hasSubprocess]->(ssc)-[:hasOptionalManualOperation]->(Oop1)
WITH DISTINCT Oop1 CREATE (nOop1:Operation{name: 'N01' + Oop1.n4sch__label + '_1'})-[:isIndividualOf]->(Oop1), (nOop2:Operation{name: 'N01' + Oop1.n4sch__label + '_2'})-[:isIndividualOf]->(Oop1)
WITH * MATCH (Oop1)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH 'N01' AND pr2.name STARTS WITH 'N01'
MERGE (nOop1)-[:hasPredecessor]->(pr1) MERGE (nOop2)-[:hasPredecessor]->(pr2)
WITH * MATCH (p1:Operation), (p2:Operation),(p0:Operation), (p3:Operation)  WHERE p1.name CONTAINS 'N01Deburring int, positioning, attach them manual_1'  AND p2.name CONTAINS 'N01Drilling template install_2' AND p0.name CONTAINS 'N01Drilling template install_1' AND p3.name CONTAINS 'N01Deburring int, positioning, attach them manual_2'
MERGE (p2)-[:hasPredecessor]->(p1)
RETURN *

//Connect nodes sub1
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_04012_Deburring int, positioning, attach them automatic_1' AND p2.name CONTAINS 'N01S40_04001_Camera at stating holes_2' MERGE (p2)-[:hasPredecessor]->(p1);
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_02001_Set in position Rails and LFT' AND p2.name CONTAINS 'N01S40_04001_Camera at stating holes_1' MERGE (p2)-[:hasPredecessor]->(p1);
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_04012_Deburring int, positioning, attach them automatic_2' AND p2.name CONTAINS 'N01S40_04014_Deinstall LFT and rails' MERGE (p2)-[:hasPredecessor]->(p1);
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_04014_Deinstall LFT and rails' AND p2.name CONTAINS 'N01S40_02002_Cleanup and add sealant_1' MERGE (p2)-[:hasPredecessor]->(p1);

//Connect nodes sub2
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_04013_Deburring int, positioning, attach them manual_1' AND p2.name CONTAINS 'N01S40_04003_Drilling template install_2' MERGE (p2)-[:hasPredecessor]->(p1);
MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS 'N01S40_04013_Deburring int, positioning, attach them manual_2' AND p2.name CONTAINS 'N01S40_02002_Cleanup and add sealant_2' MERGE (p2)-[:hasPredecessor]->(p1);

//Connect main and 2 sub1
MATCH (p1:Operation), (p2:Operation), (p3:Operation) WHERE p1.name CONTAINS 'N01S40_02003_Inspection_1' AND p2.name CONTAINS ' N01S40_02003_Inspection_2' AND p3.name CONTAINS 'N01S40_00002_Jig out' MERGE (p1)<-[:hasPredecessor]-(p3)-[:hasPredecessor]->(p2);
MATCH (p1:Operation), (p2:Operation), (p3:Operation) WHERE p1.name CONTAINS 'N01S40_02001_Set in position Rails and LFT' AND p2.name CONTAINS 'N01S40_04003_Drilling template install_1' AND p3.name CONTAINS 'N01S40_01001_Set up working environment' MERGE (p1)-[:hasPredecessor]->(p3)<-[:hasPredecessor]-(p2);

//AddResourceTime
MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[:requiresResource]->(res:n4sch__Class) WHERE op.name STARTS WITH 'N01'
WITH DISTINCT res CREATE (rob:Resource{name: 'N01' + res.n4sch__label, n4sch__label: 'N01' + res.n4sch__label})-[:isIndividualOf]->(res)
WITH * MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[r]->(res:n4sch__Class)<-[:isIndividualOf]-(rob) WHERE op.name STARTS WITH 'N01'
CREATE (op)-[:requiresResource{number: r.number}]->(rob);

MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class) WHERE op.name STARTS WITH 'N01'
SET op.duration = cl.duration, op.op_type=cl.op_type;

MATCH (op) WHERE op.name STARTS WITH 'N01'
SET op.n4sch__label = op.name;



### QUERY examples###
//Displaying 68 nodes, 328 relationships.
MATCH (operation)-[Relationship]-(entity) WHERE operation.name STARTS WITH 'N01'
RETURN *;

//EXPORT as RDF
//https://neo4j.com/labs/neosemantics/4.0/export/
//Formats: Turtle, N-Triples, JSON-LD, RDF/XML, TriG and N-Quads
:POST http://localhost:7474/rdf/orbitaljoint/cypher
{ "cypher" : "MATCH (operatoin)-[relationship]-(entity) WHERE operatoin.name STARTS WITH 'N01' RETURN *", "format": "RDF/XML" }

:POST http://localhost:7474/rdf/orbitaljoint/cypher
{ "cypher" : "MATCH (c:n4sch__Class) RETURN *", "format": "Turtle" }
