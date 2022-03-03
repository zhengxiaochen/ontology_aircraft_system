//add TLIRCatalogue class
MATCH (p:n4sch__Class) WHERE p.n4sch__label CONTAINS "TLIR" 
WITH * CREATE (e:n4sch__Class{name:"TLIRCatalogue", n4sch__label:"TLIRCatalogue"})-[:isSubclassOf]->(p) 
Return *

//rename requirement classes
MATCH (p) WHERE p.uri CONTAINS "ExtendedRequirement" SET p.name="ExtendedRequirement", p.n4sch__label="ExtendedRequirement"; 

MATCH (p) WHERE p.uri CONTAINS "FunctionalRequirement" SET p.name="FunctionalRequirement", p.n4sch__label="FunctionalRequirement";
MATCH (p) WHERE p.uri CONTAINS "Non-FunctionalRequirement" SET p.name="Non-FunctionalRequirement", p.n4sch__label="Non-FunctionalRequirement";
MATCH (p) WHERE p.uri CONTAINS "ConstraintRequirement" SET p.name="ConstraintRequirement", p.n4sch__label="ConstraintRequirement";
MATCH (p) WHERE p.uri CONTAINS "BusinessRequirement" SET p.name="BusinessRequirement", p.n4sch__label="BusinessRequirement";
MATCH (p) WHERE p.uri CONTAINS "LegalRequirement" SET p.name="LegalRequirement", p.n4sch__label="LegalRequirement";
MATCH (p) WHERE p.uri CONTAINS "PerformanceRequirement" SET p.name="PerformanceRequirement", p.n4sch__label="PerformanceRequirement";
MATCH (p) WHERE p.uri CONTAINS "PhysicalRequirement" SET p.name="PhysicalRequirement", p.n4sch__label="PhysicalRequirement";
MATCH (p) WHERE p.uri CONTAINS "ReliabilityRequirement" SET p.name="ReliabilityRequirement", p.n4sch__label="ReliabilityRequirement";
MATCH (p) WHERE p.uri CONTAINS "SupportabilityRequirement" SET p.name="SupportabilityRequirement", p.n4sch__label="SupportabilityRequirement";
MATCH (p) WHERE p.uri CONTAINS "UsabilityRequirement" SET p.name="UsabilityRequirement", p.n4sch__label="UsabilityRequirement";
MATCH (p) WHERE p.uri CONTAINS "Objective" SET p.name="Objective", p.n4sch__label="Objective";
MATCH (p) WHERE p.uri CONTAINS "hasPriority" SET p.name="hasPriority", p.n4sch__label="hasPriority";
MATCH (p) WHERE p.uri CONTAINS "hasStability" SET p.name="hasStability", p.n4sch__label="hasStability";
MATCH (p) WHERE p.uri CONTAINS "hasRisks" SET p.name="hasRisks", p.n4sch__label="hasRisks";
MATCH (p) WHERE p.uri CONTAINS "hasObligation" SET p.name="hasObligation", p.n4sch__label="hasObligation";
MATCH (p) WHERE p.uri CONTAINS "hasMotivation" SET p.name="hasMotivation", p.n4sch__label="hasMotivation";

//add new requirement classes
MATCH (t:n4sch__Class{n4sch__label:"TLIRCatalogue"}),(k:n4sch__Class{n4sch__label:"KPI"})
CREATE (t1:n4sch__Class{name:"Industrial Means Requirements",n4sch__label:"Industrial Means Requirements"})-[:isSubclassOf]->(t), 
(t2:n4sch__Class{name:"Process stability_maturity Requirements",n4sch__label:"Process stability_maturity Requirements"})-[:isSubclassOf]->(t), (t3:n4sch__Class{name:"Transition_Ramp-up",n4sch__label:"Transition_Ramp-up"})-[:isSubclassOf]->(t), 
(k1:n4sch__Class{name:"Industrial asset costs",n4sch__label:"Industrial asset costs"})-[:isSubclassOf]->(k), 
(k2:n4sch__Class{name:"Labour costs",n4sch__label:"Labour costs"})-[:isSubclassOf]->(k), 
(k3:n4sch__Class{name:"Lead time",n4sch__label:"Lead time"})-[:isSubclassOf]->(k),
(k4:n4sch__Class{name:"Production ramp up",n4sch__label:"Production ramp up"})-[:isSubclassOf]->(k)
Return *

//Then you can add performance items and link them with "TLIRCatalogue" and "KPI". The code below adds the first requirement to NEO4J, which is renamed to “S40_TPR30_01”:

MATCH (p:n4sch__Class{n4sch__label:"PerformanceRequirement"}),(t1:n4sch__Class{name:"Industrial Means Requirements"}), (t2:n4sch__Class{name:"Process stability_maturity Requirements"}), (t3:n4sch__Class{name:"Transition_Ramp-up"}),(k1:n4sch__Class{name:"Industrial asset costs"}),(k2:n4sch__Class{name:"Labour costs"}), (k3:n4sch__Class{name:"Lead time"}), (k4:n4sch__Class{name:"Production ramp up"})  
CREATE (p1:n4sch__Class{name:"S40_TPR30_01", n4sch__label:"S40_TPR30_01", description:"The RC of every station 40 Shall be 150K€/MSN",hasMetrics:"RC_STATION",hasMaximumValue:150, hasActualValue:0, hasStatus:"default" })-[:isSubclassOf]->(p), (k1)<-[:hasTLIRCatalogue]-(p1)-[:hasTLIRCatalogue]->(t1), (k2)<-[:hasTLIRCatalogue]-(p1), 
(p2:n4sch__Class{name:"S40_TPR30_02", n4sch__label:"S40_TPR30_02", description:"The new system shall not exceed production hours for structural assembly work of 350 hours at station",hasMetrics:"MH_STATION",hasMaximumValue:350, hasActualValue:0, hasStatus:"default" })-[:isSubclassOf]->(p), (k2)<-[:hasTLIRCatalogue]-(p2)-[:hasTLIRCatalogue]->(t1), (p3:n4sch__Class{name:"S40_TPR_87-TPR_88", n4sch__label:"S40_TPR_87-TPR_88", description:"Transportation tooling shall contribute to an overall Equipment Effectiveness (EE) of min. 98% for a workstation",hasMetrics:"OEE_STATION",hasMaximumValue:0.98, hasActualValue:0, hasStatus:"default" })-[:isSubclassOf]->(p), (k3)<-[:hasTLIRCatalogue]-(p3)-[:hasTLIRCatalogue]->(t2), (p4:n4sch__Class{name:"S40_TPR_87", n4sch__label:"S40_TPR_87", description:"The system shall achieve a baseline rate of A321 Aircraft per year of 115 at a peak rate of 10 per month.",hasMetrics:"ANNUAL_THROUGHPUT",hasMaximumValue:115, hasActualValue:0, hasStatus:"default" })-[:isSubclassOf]->(p), (k4)<-[:hasTLIRCatalogue]-(p4)-[:hasTLIRCatalogue]->(t3)
Return *


#Create Requirement individuals for 18 solutions
MATCH (p:Process), (r:n4sch__Class) WHERE p.name STARTS WITH "RN" AND r.n4sch__label STARTS WITH 'S40_TPR' 
WITH DISTINCT p, r CREATE (p)-[:hasRequirement]->(re:Requirement:PerformanceRequirement{name:"Req_"+substring(p.name,2,2)+r.name, n4sch__label:"Re"+substring(p.name,2,2)+r.name, description:r.description, hasStatus:r.hasStatus, hasMetrics:r.hasMetrics, hasMaximumValue:r.hasMaximumValue, hasActualValue:r.hasActualValue})-[:isIndividualOf]->(r)
RETURN p, r, re