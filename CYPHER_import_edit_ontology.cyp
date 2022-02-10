##########################Neo4j graph database installation#####################
//How to install and configure a Neo4j graph database on an Azure cloud Ubuntu Virtual Machine (VM) has been introduced in a previous document:
// https://www.researchgate.net/publication/355889982_Neo4j_graph_database_installation_on_Azure_cloud_Ubuntu_Virtual_Machine_and_configuration_of_Neosemantics_package_for_Ontology
##########################Configurations#####################
//##https://neo4j.com/labs/neosemantics/4.2/config/
//##database ini config.
CALL n10s.graphconfig.init();
CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;


##########################Import ontology###############
//#https://neo4j.com/labs/neosemantics/4.2/importing-ontologies/
//#Delete all nodes and relationships
//MATCH (n) DETACH DELETE n
//!!!Use MAP instead of IGNORE: https://community.neo4j.com/t/problem-exporting-rdf-using-neosemantics-n10s/20880/9
call n10s.graphconfig.init({ handleVocabUris: 'handleVocabUris' });
call n10s.onto.import.fetch("file:///C:\\Users\\hello\\Downloads\\urn_webprotege_ontology_9a45bb51-8473-4cc3-af08-57a784d84a45.ttl","Turtle",{ handleVocabUris: "MAP" })
//CALL n10s.onto.import.fetch("https://raw.githubusercontent.com/zhengxiaochen/qu4lity_airbus_ontology/main/airbus_ontology.ttl","Turtle");
//set label for visualizing classes
MATCH (n:Resource) SET n.n4sch__label=n.label RETURN n;
//Rename Resource name to n4sch__Class
MATCH (n:Resource)
WITH collect(n) AS n1
CALL apoc.refactor.rename.label("Resource", "n4sch__Class", n1)
YIELD committedOperations
RETURN *;

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

//#import ontology: individuals are not loaded
//#https://community.neo4j.com/t/linking-instances-individuals-to-my-ontology-graph/32775
//#CALL n10s.graphconfig.init({handleRDFTypes: "LABELS_AND_NODES"}) #this was used for importing individuals, but didn't work
//##Turtle
//CALL n10s.graphconfig.init();
//call n10s.onto.import.fetch("file:///C:\\Users\\hello\\Downloads\\urn_webprotege_ontology_9a45bb51-8473-4cc3-af08-57a784d84a45.ttl","Turtle",{ handleVocabUris: "IGNORE" })
//#from github
//###attention Use the Raw ttl file, not the default one
//CALL n10s.onto.import.fetch("https://raw.githubusercontent.com/zhengxiaochen/qu4lity_airbus_ontology/main/airbus_ontology.ttl","Turtle");
#######################################

##########################Create new Classes for MVP5##########################

//##############Operations ##############
//#delete all operations with relations
//#MATCH (op:n4sch__Class) WHERE op.name STARTS WITH 'S40_0' DETACH DELETE op;
MATCH (p:n4sch__Class {n4sch__label: 'Setup Operation'}) CREATE (op:n4sch__Class { name: "S40_01001_Set up working environment", duration: 10 }), (op)-[:isSubclassOf]->(p);
//##automated process
//#1/2
MATCH (p:n4sch__Class {n4sch__label: 'Installation Operation'}) CREATE (op:n4sch__Class { name: "S40_02001_Set in position Rails and LFT", duration: 10, op_type: "Auto"}),  (op)-[:isSubclassOf]->(p);
//# 1/4
MATCH (p:n4sch__Class {n4sch__label: 'Positioning Operation'}) CREATE (op:n4sch__Class { name: "S40_04001_Camera at stating holes", duration: 15, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Drilling Operation'}) CREATE (op:n4sch__Class { name: "S40_04002_Drilling orbital 4,8", duration: 125, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Positioning Operation'}) CREATE (op:n4sch__Class { name: "S40_04008_Set up the fixations LGP/Hi-Lite automatic", duration: 20, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Riveting Operation'}) CREATE (op:n4sch__Class { name: "S40_04010_Riveting buttstraps and stabiliser automatic", duration: 90, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Deburring Operation'}) CREATE (op:n4sch__Class { name: "S40_04012_Deburring int, positioning, attach them automatic", duration: 25, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
//#1/2
MATCH (p:n4sch__Class {n4sch__label: 'Uninstallation Operation'}) CREATE (op:n4sch__Class { name: "S40_04014_Deinstall LFT and rails", duration: 35, op_type: "Auto" }), (op)-[:isSubclassOf]->(p);
// ## Manual process
MATCH (p:n4sch__Class {n4sch__label: 'Installation Operation'}) CREATE (op:n4sch__Class { name: "S40_04003_Drilling template install", duration: 25, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Installation Operation'}) CREATE (op:n4sch__Class { name: "S40_04004_Fixation drilling template suite manual", duration: 30, op_type: "Manual"  }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Drilling Operation'}) CREATE (op:n4sch__Class { name: "S40_04005_Drilling (with adapter) 3,2 on Stringers int and drilling template", duration: 185, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Uninstallation Operation'}) CREATE (op:n4sch__Class { name: "S40_04006_Deinstall drilling template", duration: 25, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Positioning Operation'}) CREATE (op:n4sch__Class { name: "S40_04007_Set in position temporary fastener", duration: 15, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Positioning Operation'}) CREATE (op:n4sch__Class { name: "S40_04009_Set up the fixations LGP/Hi-Lite manual", duration: 35, op_type: "Manual"  }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Riveting Operation'}) CREATE (op:n4sch__Class { name: "S40_04011_Riveting buttstraps and stabiliser manual", duration: 180, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Deburring Operation'}) CREATE (op:n4sch__Class { name: "S40_04013_Deburring int, positioning, attach them manual", duration: 45, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
//## 1/2 EssentialOperation
MATCH (p:n4sch__Class {n4sch__label: 'Sealing Operation'}) CREATE (op:n4sch__Class { name: "S40_02002_Cleanup and add sealant", duration: 35, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Inspection Operation'}) CREATE (op:n4sch__Class { name: "S40_02003_Inspection", duration: 55, op_type: "Manual" }), (op)-[:isSubclassOf]->(p);
//#SET all operations labels = name
MATCH (op:n4sch__Class) WHERE op.name STARTS WITH 'S40_0' SET op.n4sch__label=substring(op.name,10);

//##Operation sequence
MATCH (o1:n4sch__Class ), (o2:n4sch__Class ), (o3:n4sch__Class ), (o4:n4sch__Class ), (o5:n4sch__Class ), (o6:n4sch__Class ), (o7:n4sch__Class ), (o8:n4sch__Class ), (o9:n4sch__Class ), (o10:n4sch__Class ), (o11:n4sch__Class ), (o12:n4sch__Class ), (o13:n4sch__Class ), (o14:n4sch__Class ), (o15:n4sch__Class ), (o16:n4sch__Class ), (o17:n4sch__Class ), (o18:n4sch__Class )
WHERE o1.name STARTS WITH 'S40_01001' AND o2.name STARTS WITH 'S40_02001' AND o3.name STARTS WITH 'S40_04001' AND o4.name STARTS WITH 'S40_04002' AND o5.name STARTS WITH 'S40_04003' AND o6.name STARTS WITH 'S40_04004' AND o7.name STARTS WITH 'S40_04005' AND o8.name STARTS WITH 'S40_04006' AND o9.name STARTS WITH 'S40_04007' AND o10.name STARTS WITH 'S40_04008' AND o11.name STARTS WITH 'S40_04009' AND o12.name STARTS WITH 'S40_04010' AND o13.name STARTS WITH 'S40_04011' AND o14.name STARTS WITH 'S40_04012' AND o15.name STARTS WITH 'S40_04013' AND o16.name STARTS WITH 'S40_04014' AND o17.name STARTS WITH 'S40_02002' AND o18.name STARTS WITH 'S40_02003'
CREATE (o18)-[:hasPredecessor]->(o17), (o14)-[:hasPredecessor]->(o12)-[:hasPredecessor]->(o10)-[:hasPredecessor]->(o4)-[:hasPredecessor]->(o3), (o15)-[:hasPredecessor]->(o13)-[:hasPredecessor]->(o11)-[:hasPredecessor]->(o9)-[:hasPredecessor]->(o8)-[:hasPredecessor]->(o7)-[:hasPredecessor]->(o6)-[:hasPredecessor]->(o5);

//##############Resource##############
//MATCH (p:n4sch__Class {n4sch__label: 'FlexTrack Body'}) CREATE (op:n4sch__Class { name: "S40_R_Light Flex Track Robot",cost_hour: 75, calendar: "24x7", number: 2 }), (op)-[:isSubclassOf]->(p);
//MATCH (p:n4sch__Class {n4sch__label: 'FlexTrack Rail'}) CREATE (op:n4sch__Class { name: "S40_R_Light Flex Track Rail",cost_hour: 5, calendar: "24x7", number: 2 }), (op)-[:isSubclassOf]->(p);
//MATCH (p:n4sch__Class {n4sch__label: 'Light Flex Track Robot'}) SET p.cost_hour= 75, p.calendar= "24x7", p.number = 2;
//MATCH (p:n4sch__Class {n4sch__label: 'Light Flex Track Rail'}) SET p.cost_hour= 5, p.calendar= "24x7", p.number = 2;

MATCH (p:n4sch__Class {n4sch__label: 'FlexTrack Body'}) SET p.n4sch__label= "Light Flex Track Robot", p.name="Light Flex Track Robot", p.cost_hour= 75, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'FlexTrack Rail'}) SET p.n4sch__label= "Light Flex Track Rail",p.name="Light Flex Track Rail", p.cost_hour= 5, p.calendar= "24x7", p.number = 2;
MATCH (p:n4sch__Class {n4sch__label: 'Facilities'}) CREATE (op:n4sch__Class { name: "Station",n4sch__label:"Station",cost_hour: 80, calendar: "24x7", number: 2 }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Facilities'}) CREATE (op:n4sch__Class { name: "Station platform",n4sch__label:"Station platform",cost_hour: 75, calendar: "24x7", number: 2}), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Operator'}) CREATE (op:n4sch__Class { name: "Mechanical Operator",n4sch__label:"Mechanical Operator",cost_hour: 100, calendar: "shift_40h_week", number: 8 }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Operator'}) CREATE (op:n4sch__Class { name: "Automation Operator",n4sch__label:"Automation Operator",cost_hour: 100, calendar: "shift_40h_week", number: 8 }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Equipment'}) CREATE (op:n4sch__Class { name: "Hand drilling machine",n4sch__label:"Hand drilling machine",cost_hour: 10, calendar: "24x7", number: 6 }), (op)-[:isSubclassOf]->(p);
MATCH (p:n4sch__Class {n4sch__label: 'Equipment'}) CREATE (op:n4sch__Class { name: "Drilling template",n4sch__label:"Drilling template",cost_hour: 10, calendar: "24x7", number: 5 }), (op)-[:isSubclassOf]->(p);

//##Assign Operation resources
MATCH (o1:n4sch__Class), (o2:n4sch__Class), (o3:n4sch__Class), (o4:n4sch__Class), (o5:n4sch__Class), (o6:n4sch__Class), (o7:n4sch__Class), (o8:n4sch__Class), (o9:n4sch__Class), (o10:n4sch__Class), (o11:n4sch__Class), (o12:n4sch__Class), (o13:n4sch__Class), (o14:n4sch__Class), (o15:n4sch__Class), (o16:n4sch__Class), (o17:n4sch__Class), (o18:n4sch__Class), (r11:n4sch__Class { name: "Mechanical Operator" }),(r12:n4sch__Class { name: "Automation Operator" }),(r2:n4sch__Class { name: "Light Flex Track Robot" }),(r3:n4sch__Class { name: "Light Flex Track Rail" }),(r4:n4sch__Class { name: "Hand drilling machine" }),(r5:n4sch__Class { name: "Drilling template" }),(r6:n4sch__Class { name: "Station platform" }),(r7:n4sch__Class { name: "Station" })
WHERE o1.name STARTS WITH 'S40_01001' AND o2.name STARTS WITH 'S40_02001' AND o3.name STARTS WITH 'S40_04001' AND o4.name STARTS WITH 'S40_04002' AND o5.name STARTS WITH 'S40_04003' AND o6.name STARTS WITH 'S40_04004' AND o7.name STARTS WITH 'S40_04005' AND o8.name STARTS WITH 'S40_04006' AND o9.name STARTS WITH 'S40_04007' AND o10.name STARTS WITH 'S40_04008' AND o11.name STARTS WITH 'S40_04009' AND o12.name STARTS WITH 'S40_04010' AND o13.name STARTS WITH 'S40_04011' AND o14.name STARTS WITH 'S40_04012' AND o15.name STARTS WITH 'S40_04013' AND o16.name STARTS WITH 'S40_04014' AND o17.name STARTS WITH 'S40_02002' AND o18.name STARTS WITH 'S40_02003'
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
(o18)-[:requiresResource {number:2}]->(r11), (r6)<-[:requiresResource {number: 1}]-(o18)-[:requiresResource {number:1}]->(r7);

//############## Processes - upper/lower half, left/right quarter ##############
//##delete original relation with Operations
//##//MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'})-[re:n4sch__SCO_RESTRICTION{onPropertyName:'R9DdtPWxyA1JZNBr6RBl7jZ'}]->(op) DELETE re RETURN p,op;
MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'})-[re:n4sch__SCO_RESTRICTION]->(op) DELETE re RETURN p,op;
MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'})<-[re:n4sch__SCO_RESTRICTION{onPropertyName:'RC3SMTo1pqRXZWD5dLjQzIu'}]->(op) DELETE re RETURN p,op;
//##add new relationships
MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'}), (o1:n4sch__Class {n4sch__label: 'Front Fuselage'}), (o2:n4sch__Class {n4sch__label: 'Rear Fuselage'}) CREATE (o1)<-[:joinsMaterial]-(p)-[:joinsMaterial]->(o2) RETURN p;

//##Add subProcess
MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'}) CREATE
(sc1:n4sch__Class { name: "Upper Orbital Joining Process", n4sch__label: "Upper Orbital Joining Process"}),
(sc2:n4sch__Class { name: "Lower Orbital Joining Process", n4sch__label: "Lower Orbital Joining Process"}),
(sc11:n4sch__Class { name: "Upper Left Orbital Joining Process", n4sch__label: "Upper Left Orbital Joining Process"}),
(sc12:n4sch__Class { name: "Upper Right Orbital Joining Process", n4sch__label: "Upper Right Orbital Joining Process"}),
(sc21:n4sch__Class { name: 'Lower Left Orbital Joining Process', n4sch__label: 'Lower Left Orbital Joining Process'}),
(sc22:n4sch__Class { name: 'Lower Right Orbital Joining Process', n4sch__label: 'Lower Right Orbital Joining Process'}),
(sc1)<-[:hasSubprocess]-(p)-[:hasSubprocess]->(sc2), (sc11)<-[:hasSubprocess]-(sc1)-[:hasSubprocess]->(sc12),(sc21)<-[:hasSubprocess]-(sc2)-[:hasSubprocess]->(sc22);
//RETURN p

//##EssentialOperations
MATCH (o1:n4sch__Class), (o2:n4sch__Class), (o3:n4sch__Class), (o4:n4sch__Class), (o5:n4sch__Class), (o6:n4sch__Class), (o7:n4sch__Class), (o8:n4sch__Class), (o9:n4sch__Class), (o10:n4sch__Class), (o11:n4sch__Class), (o12:n4sch__Class), (o13:n4sch__Class), (o14:n4sch__Class), (o15:n4sch__Class), (o16:n4sch__Class), (o17:n4sch__Class), (o18:n4sch__Class), (p1:n4sch__Class {n4sch__label: 'Orbital Joining Process'}), (sc1:n4sch__Class {n4sch__label: 'Upper Orbital Joining Process'}), (sc2:n4sch__Class {n4sch__label: 'Lower Orbital Joining Process'}), (sc11:n4sch__Class {n4sch__label: 'Upper Right Orbital Joining Process'}),(sc12:n4sch__Class {n4sch__label: 'Upper Left Orbital Joining Process'}), (sc21:n4sch__Class {n4sch__label: 'Lower Right Orbital Joining Process'}),(sc22:n4sch__Class {n4sch__label: 'Lower Left Orbital Joining Process'})
WHERE o1.name STARTS WITH 'S40_01001' AND o2.name STARTS WITH 'S40_02001' AND o3.name STARTS WITH 'S40_04001' AND o4.name STARTS WITH 'S40_04002' AND o5.name STARTS WITH 'S40_04003' AND o6.name STARTS WITH 'S40_04004' AND o7.name STARTS WITH 'S40_04005' AND o8.name STARTS WITH 'S40_04006' AND o9.name STARTS WITH 'S40_04007' AND o10.name STARTS WITH 'S40_04008' AND o11.name STARTS WITH 'S40_04009' AND o12.name STARTS WITH 'S40_04010' AND o13.name STARTS WITH 'S40_04011' AND o14.name STARTS WITH 'S40_04012' AND o15.name STARTS WITH 'S40_04013' AND o16.name STARTS WITH 'S40_04014' AND o17.name STARTS WITH 'S40_02002' AND o18.name STARTS WITH 'S40_02003'
CREATE
(p1)-[:hasEssentialOperation]->(o1), (sc1)-[:hasEssentialOperation]->(o17)<-[:hasEssentialOperation]-(sc2),(sc1)-[:hasEssentialOperation]->(o18)<-[:hasEssentialOperation]-(sc2),
(o2)<-[:hasOptionalAutoOperation]-(sc1)-[:hasOptionalAutoOperation]->(o16), (o2)<-[:hasOptionalAutoOperation]-(sc2)-[:hasOptionalAutoOperation]->(o16),
(o3)<-[:hasOptionalAutoOperation]-(sc11)-[:hasOptionalAutoOperation]->(o4), (o10)<-[:hasOptionalAutoOperation]-(sc11)-[:hasOptionalAutoOperation]->(o12),(sc11)-[:hasOptionalAutoOperation]->(o14), (o5)<-[:hasOptionalManualOperation]-(sc11)-[:hasOptionalManualOperation]->(o6), (o7)<-[:hasOptionalManualOperation]-(sc11)-[:hasOptionalManualOperation]->(o8), (o9)<-[:hasOptionalManualOperation]-(sc11)-[:hasOptionalManualOperation]->(o11), (o13)<-[:hasOptionalManualOperation]-(sc11)-[:hasOptionalManualOperation]->(o15),
(o3)<-[:hasOptionalAutoOperation]-(sc12)-[:hasOptionalAutoOperation]->(o4), (o10)<-[:hasOptionalAutoOperation]-(sc12)-[:hasOptionalAutoOperation]->(o12),(sc12)-[:hasOptionalAutoOperation]->(o14), (o5)<-[:hasOptionalManualOperation]-(sc12)-[:hasOptionalManualOperation]->(o6), (o7)<-[:hasOptionalManualOperation]-(sc12)-[:hasOptionalManualOperation]->(o8), (o9)<-[:hasOptionalManualOperation]-(sc12)-[:hasOptionalManualOperation]->(o11), (o13)<-[:hasOptionalManualOperation]-(sc12)-[:hasOptionalManualOperation]->(o15),
(o3)<-[:hasOptionalAutoOperation]-(sc21)-[:hasOptionalAutoOperation]->(o4), (o10)<-[:hasOptionalAutoOperation]-(sc21)-[:hasOptionalAutoOperation]->(o12),(sc21)-[:hasOptionalAutoOperation]->(o14), (o5)<-[:hasOptionalManualOperation]-(sc21)-[:hasOptionalManualOperation]->(o6), (o7)<-[:hasOptionalManualOperation]-(sc21)-[:hasOptionalManualOperation]->(o8), (o9)<-[:hasOptionalManualOperation]-(sc21)-[:hasOptionalManualOperation]->(o11), (o13)<-[:hasOptionalManualOperation]-(sc21)-[:hasOptionalManualOperation]->(o15),
(o3)<-[:hasOptionalAutoOperation]-(sc22)-[:hasOptionalAutoOperation]->(o4), (o10)<-[:hasOptionalAutoOperation]-(sc22)-[:hasOptionalAutoOperation]->(o12),(sc22)-[:hasOptionalAutoOperation]->(o14), (o5)<-[:hasOptionalManualOperation]-(sc22)-[:hasOptionalManualOperation]->(o6), (o7)<-[:hasOptionalManualOperation]-(sc22)-[:hasOptionalManualOperation]->(o8), (o9)<-[:hasOptionalManualOperation]-(sc22)-[:hasOptionalManualOperation]->(o11), (o13)<-[:hasOptionalManualOperation]-(sc22)-[:hasOptionalManualOperation]->(o15);
//RETURN p1;


##########################RULES reasoning: check rules and automatically create related individuals##########################
##########################OPTION1 - N1 - 1/2 AUTO concurrent 1/2 MANUAL ##########################
//#####create new process
//## structure of the process
//MATCH (op) WHERE op.name STARTS WITH 'N1' DETACH DELETE op;
MATCH (op),(ob), (res) WHERE op.name STARTS WITH 'N1' AND ob.name STARTS WITH "RD1" AND res.name STARTS WITH "N1R"  DETACH DELETE op, ob, res;

MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasEssentialOperation]->(Eop:n4sch__Class)
CREATE (np:Process{name: "RD1" + p.n4sch__label}), (np)-[:isIndividualOf]->(p), (nEop :Operation{name: "N1" + Eop.n4sch__label}), (nEop)-[:isIndividualOf]->(Eop), (np)-[:hasOperation]->(nEop)  //only 1 EssentialOperation
WITH * MATCH (p)-[:hasSubprocess]->(sc:n4sch__Class)-[:hasEssentialOperation]->(Eop1:n4sch__Class)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)//sc:upper and lower half
WITH DISTINCT Eop1, pr
CREATE (nEop1:Operation{name: "N1" + Eop1.n4sch__label+"_1"})-[:isIndividualOf]->(Eop1), (nEop1)<-[:hasPredecessor]-(fop1:Operation{name:'N1' + pr.n4sch__label+"_1"})-[:isIndividualOf]->(pr), (nEop2:Operation{name: "N1" + Eop1.n4sch__label +"_2"})-[:isIndividualOf]->(Eop1), (nEop2)<-[:hasPredecessor]-(fop2:Operation{name:'N1' + pr.n4sch__label+"_2"})-[:isIndividualOf]->(pr)   //only 1 EssentialOperation and its following ops
RETURN nEop1, fop1, nEop2, fop2

//OptionalOperation of sc
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class)
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N1" + Oop.n4sch__label})-[:isIndividualOf]->(Oop)
RETURN nOop

//ssc
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)
WITH DISTINCT sc
MATCH (sc)-[:hasSubprocess]->(ssc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class) //2 OptionalOperation
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N1" + Oop.n4sch__label + "_1"})-[:isIndividualOf]->(Oop)
WITH * MATCH (Oop)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)
WITH DISTINCT pr as pr0
UNWIND pr0 as pr1
CREATE (fop1:Operation{name:'N1' + pr1.n4sch__label+ "_1"}), (fop1)-[:isIndividualOf]->(pr1)
WITH * MATCH (op1)-[:isIndividualOf]->(oc1:n4sch__Class)<-[:hasPredecessor]-(pr1) WHERE op1.name STARTS WITH "N1"
CREATE (fop1)-[:hasPredecessor]->(op1)
RETURN op1, fop1

//create a copy of 1/4 operations
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)
WITH DISTINCT sc
MATCH (sc)-[:hasSubprocess]->(ssc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class) //2 OptionalOperation
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N1" + Oop.n4sch__label + "_2"})-[:isIndividualOf]->(Oop)
WITH * MATCH (Oop)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)
WITH DISTINCT pr as pr0
UNWIND pr0 as pr1
CREATE (fop2:Operation{name:'N1' + pr1.n4sch__label+ "_2"}), (fop2)-[:isIndividualOf]->(pr1)
WITH * MATCH (op2)-[:isIndividualOf]->(oc1:n4sch__Class)<-[:hasPredecessor]-(pr1) WHERE op2.name ENDS WITH "_2" AND op2.name STARTS WITH "N1"
CREATE (fop2)-[:hasPredecessor]->(op2)
RETURN op2, fop2

//to be improved
//Option1: concurrent 1/2
MATCH (lft1:Operation), (lft2:Operation), (cam1:Operation), (cam2:Operation), (deb1:Operation), (deb2:Operation), (cln1:Operation), (cln2:Operation), (drl1:Operation), (drl2:Operation), (deb3:Operation), (deb4:Operation), (pre:Operation)
WHERE lft1.name CONTAINS "N1Set in position Rails and LFT" AND lft2.name CONTAINS "N1Deinstall LFT and rails" AND cam1.name CONTAINS "N1Camera at stating holes_1" AND cam2.name CONTAINS "N1Camera at stating holes_2" AND deb1.name CONTAINS "N1Deburring int, positioning, attach them automatic_1" AND deb2.name CONTAINS "N1Deburring int, positioning, attach them automatic_2" AND cln1.name CONTAINS "N1Cleanup and add sealant_1"  AND cln2.name CONTAINS "N1Cleanup and add sealant_2" AND drl1.name CONTAINS "N1Drilling template install_1" AND drl2.name CONTAINS "N1Drilling template install_2" AND deb3.name CONTAINS "N1Deburring int, positioning, attach them manual_1" AND deb4.name CONTAINS "N1Deburring int, positioning, attach them manual_2" AND pre.name CONTAINS "N1Set up working environment"
CREATE (cam1)-[:hasPredecessor]->(lft1), (cam2)-[:hasPredecessor]->(deb1), (lft2)-[:hasPredecessor]->(deb2), (deb4)<-[:hasPredecessor]-(cln2),(cln1)-[:hasPredecessor]->(lft2), (drl2)-[:hasPredecessor]->(deb3), (lft1)-[:hasPredecessor]->(pre)<-[:hasPredecessor]-(drl1)
RETURN  lft1, lft2, cam1, cam2, deb1, deb2, deb3, deb4, cln1, cln2, drl1, drl2, pre

//Add resources
MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[:requiresResource]->(res:n4sch__Class) WHERE op.name STARTS WITH 'N1'
WITH DISTINCT res
CREATE (rob:Resource{name: "N1R_" + res.n4sch__label, n4sch__label:"N1R_" + res.n4sch__label})-[:isIndividualOf]->(res)
WITH * MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[r]->(res:n4sch__Class)<-[:isIndividualOf]-(rob) WHERE op.name STARTS WITH 'N1'
CREATE (op)-[:requiresResource{number: r.number}]->(rob)
RETURN rob, op

//add time
MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class) WHERE op.name STARTS WITH 'N1'
SET op.duration = cl.duration, op.op_type=cl.op_type


##########################OPTION2 - N2 - 1/2 AUTO concurrent 1/2 AUTO ##########################
//#####create new process
//## structure of the process
//MATCH (op) WHERE op.name STARTS WITH 'N2' DETACH DELETE op;
MATCH (op),(ob), (res) WHERE op.name STARTS WITH 'N2' AND ob.name STARTS WITH "RD2" AND res.name STARTS WITH "N2R"  DETACH DELETE op, ob, res;

MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasEssentialOperation]->(Eop:n4sch__Class)
CREATE (np:Process{name: "RD2" + p.n4sch__label}), (np)-[:isIndividualOf]->(p), (nEop :Operation{name: "N2" + Eop.n4sch__label}), (nEop)-[:isIndividualOf]->(Eop), (np)-[:hasOperation]->(nEop)  //only 1 EssentialOperation
WITH * MATCH (p)-[:hasSubprocess]->(sc:n4sch__Class)-[:hasEssentialOperation]->(Eop1:n4sch__Class)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)//sc:upper and lower half
WITH DISTINCT Eop1, pr
CREATE (nEop1:Operation{name: "N2" + Eop1.n4sch__label})-[:isIndividualOf]->(Eop1), (nEop1)<-[:hasPredecessor]-(fop1:Operation{name:'N2' + pr.n4sch__label})-[:isIndividualOf]->(pr)   //only 1 EssentialOperation and its following ops
RETURN nEop1, fop1

//OptionalOperation of sc
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class)
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N2" + Oop.n4sch__label})-[:isIndividualOf]->(Oop)
RETURN nOop

//ssc
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)
WITH DISTINCT sc
MATCH (sc)-[:hasSubprocess]->(ssc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class) WHERE Oop.name CONTAINS "Camera"  //AUTO OptionalOperation
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N2" + Oop.n4sch__label + "_1"})-[:isIndividualOf]->(Oop)
WITH * MATCH (Oop)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)
WITH DISTINCT pr as pr0
UNWIND pr0 as pr1
CREATE (fop1:Operation{name:'N2' + pr1.n4sch__label+ "_1"}), (fop1)-[:isIndividualOf]->(pr1)
WITH * MATCH (op1)-[:isIndividualOf]->(oc1:n4sch__Class)<-[:hasPredecessor]-(pr1) WHERE op1.name STARTS WITH "N2"
CREATE (fop1)-[:hasPredecessor]->(op1)
RETURN op1, fop1

//create a copy of 1/4 operations
MATCH (p:n4sch__Class{n4sch__label: 'Orbital Joining Process'})-[:hasSubprocess]->(sc:n4sch__Class)
WITH DISTINCT sc
MATCH (sc)-[:hasSubprocess]->(ssc:n4sch__Class)-[:hasOptionalOperation]->(Oop:n4sch__Class) WHERE Oop.name CONTAINS "Camera"
WITH DISTINCT Oop
CREATE (nOop:Operation{name: "N2" + Oop.n4sch__label + "_2"})-[:isIndividualOf]->(Oop)
WITH * MATCH (Oop)<-[:hasPredecessor*1..10]-(pr:n4sch__Class)
WITH DISTINCT pr as pr0
UNWIND pr0 as pr1
CREATE (fop2:Operation{name:'N2' + pr1.n4sch__label+ "_2"}), (fop2)-[:isIndividualOf]->(pr1)
WITH * MATCH (op2)-[:isIndividualOf]->(oc1:n4sch__Class)<-[:hasPredecessor]-(pr1) WHERE op2.name ENDS WITH "_2" AND op2.name STARTS WITH "N2"
CREATE (fop2)-[:hasPredecessor]->(op2)
RETURN op2, fop2

//to be improved
//OptioN2: concurrent 1/2
MATCH (lft1:Operation), (lft2:Operation), (cam1:Operation), (cam2:Operation), (deb1:Operation), (deb2:Operation), (cln:Operation), (pre:Operation)
WHERE lft1.name CONTAINS "N2Set in position Rails and LFT" AND lft2.name CONTAINS "N2Deinstall LFT and rails" AND cam1.name CONTAINS "N2Camera at stating holes_1" AND cam2.name CONTAINS "N2Camera at stating holes_2" AND deb1.name CONTAINS "N2Deburring int, positioning, attach them automatic_1" AND deb2.name CONTAINS "N2Deburring int, positioning, attach them automatic_2" AND cln.name CONTAINS "N2Cleanup" AND pre.name CONTAINS "N2Set up working environment"
CREATE (cam1)-[:hasPredecessor]->(lft1), (cam2)-[:hasPredecessor]->(deb1), (lft2)-[:hasPredecessor]->(deb2), (cln)-[:hasPredecessor]->(lft2), (lft1)-[:hasPredecessor]->(pre)
RETURN  lft1, lft2, cam1, cam2, deb1, deb2, cln, pre

//clone the auto 1/2 process
//https://stackoverflow.com/questions/53596520/how-to-duplicate-node-tree-in-neo4j
MATCH (op:Operation{name:"N2Set up working environment"})<-[:hasPredecessor*1..20]-(op1)
WITH DISTINCT op1
CALL apoc.refactor.cloneNodesWithRelationships([op1]) YIELD input, output
WITH collect(output) as createdNodes, collect(op1) as originalNodes
UNWIND createdNodes as created
OPTIONAL MATCH (created)-[r]-(other)
WHERE other in originalNodes
DELETE r // get rid of relationships that aren't between cloned nodes
//RETURN *

//Add resources
MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[:requiresResource]->(res:n4sch__Class) WHERE op.name STARTS WITH 'N2'
WITH DISTINCT res
CREATE (rob:Resource{name: "N2R_" + res.n4sch__label, n4sch__label:"N2R_" + res.n4sch__label})-[:isIndividualOf]->(res)
WITH * MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[r]->(res:n4sch__Class)<-[:isIndividualOf]-(rob) WHERE op.name STARTS WITH 'N2'
CREATE (op)-[:requiresResource{number: r.number}]->(rob)
RETURN rob, op

//add time
MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class) WHERE op.name STARTS WITH 'N2'
SET op.duration = cl.duration, op.op_type=cl.op_type

//RETURN a complete process
//Displaying 66 nodes, 328 relationships.
MATCH (operatoin)-[relationship]-(entity) WHERE operatoin.name STARTS WITH 'N2'
RETURN *;

MATCH (op),(ob) WHERE op.name STARTS WITH 'N2' AND ob.name STARTS WITH "RD2" RETURN op, ob;



############################Query examples############################
## Show Orbital Joining Process classes
MATCH (p:n4sch__Class {n4sch__label: 'Orbital Joining Process'})
RETURN p;

//Displaying 68 nodes, 328 relationships.
MATCH (operation)-[Relationship]-(entity) WHERE operation.name STARTS WITH 'N1'
RETURN *;

//EXPORT as RDF
//https://neo4j.com/labs/neosemantics/4.0/export/
//Formats: Turtle, N-Triples, JSON-LD, RDF/XML, TriG and N-Quads
:POST http://localhost:7474/rdf/orbitaljoint/cypher
{ "cypher" : "MATCH (operatoin)-[relationship]-(entity) WHERE operatoin.name STARTS WITH 'N1' RETURN *", "format": "Turtle" }

:POST http://localhost:7474/rdf/orbitaljoint/cypher
{ "cypher" : "MATCH (c:n4sch__Class) RETURN *", "format": "Turtle" }

//WORKS WITH uri for a single node
:GET http://localhost:7474/rdf/orbitaljoint/describe/http%3A%2F%2Fwebprotege.stanford.edu%2FRDNFaiCNdW3f4aYdYFYsSXW
#################
