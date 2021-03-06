#https://towardsdatascience.com/neo4j-cypher-python-7a919a372be7
from neo4j import GraphDatabase

class Neo4jConnection:
    def __init__(self, uri, user, pwd):
        self.__uri = uri
        self.__user = user
        self.__pwd = pwd
        self.__driver = None
        try:
            self.__driver = GraphDatabase.driver(
                self.__uri, auth=(self.__user, self.__pwd))
        except Exception as e:
            print("Failed to create the driver:", e)
    def close(self):
        if self.__driver is not None:
            self.__driver.close()
    def query(self, query, db=None):
        assert self.__driver is not None, "Driver not initialized!"
        session = None
        response = None
        try:
            session = self.__driver.session(
                database=db) if db is not None else self.__driver.session()
            response = list(session.run(query))
        except Exception as e:
            print("Query failed:", e)
        finally:
            if session is not None:
                session.close()
        return response

#Create main process
def Neo4jCreateMainProcess(conn, db, namep):
    #namep="N3"
    str1 = ("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'}) "
    "CREATE (op:Process{name: 'R"+namep+ "' + p.n4sch__label}), (op)-[:isIndividualOf]->(p) "
    "WITH * MATCH (p)-[:hasEssentialOperation]->(e:n4sch__Class) "
    "WITH DISTINCT e, op,p "
    "CREATE (oe:Operation{name: '"+namep+ "' + e.n4sch__label}), (oe)-[:isIndividualOf]->(e) "
    "WITH * MATCH (e)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1) WHERE pr1.name STARTS WITH '" +namep+ "' "
    "MERGE (oe)-[:hasPredecessor]->(pr1) MERGE (op)-[:hasOperation]->(pr1) ")
    str3 =("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasEssentialOperation]->(e:n4sch__Class)<-[:isIndividualOf]-(ne) WHERE ne.name STARTS WITH '" +namep+ "' "
    "RETURN ne.name " )
    str2 = ("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasEssentialOperation]->(e:n4sch__Class) "
    "WITH DISTINCT e "
    "CREATE (oe1:Operation{name: '"+namep+ "' + e.n4sch__label + '_1'})-[:isIndividualOf]->(e), (oe2:Operation{name: '"+namep+ "' + e.n4sch__label + '_2'})-[:isIndividualOf]->(e) "
    "WITH * MATCH (e)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) "
    "WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH '" +namep+ "' AND pr2.name STARTS WITH '" +namep+ "' "
    "MERGE (oe1)-[:hasPredecessor]->(pr1) MERGE (oe2)-[:hasPredecessor]->(pr2) "
    "RETURN pr1.name, pr2.name, oe1.name, oe2.name " )
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    np0 = conn.query(str1, db)
    np = conn.query(str3, db) #[<Record ne.name='N02S40_00002_Jig out'>, <Record ne.name='N02S40_01001_Set up working environment'>, <Record ne.name='N02S40_00001_Jig in'>]
    op01name = np[0][0] #name of the first operation "Jig in"
    op02name = np[1][0] #name of the first operation "Jig out"
    op03name = np[2][0] #name of the first operation "Set up working environment"
    np2 = conn.query(str2, db) # np is a list
    op21name = np2[0][0] #'N3Cleanup and add sealant_1'
    op22name = np2[0][1] #'N3Cleanup and add sealant_2'
    op23name = np2[0][2]
    op24name = np2[0][3]
    return op01name, op02name, op03name, op21name, op22name, op23name, op24name

#Create automatic subprocess
def Neo4jCreateSubAutoProcess(conn, db, namep):
    #namep ="N3"
    str1 = ("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc:n4sch__Class)-[:hasOptionalAutoOperation]->(Oop:n4sch__Class) "
    "WITH DISTINCT Oop CREATE (nOop:Operation{name: '"+namep+ "' + Oop.n4sch__label})-[:isIndividualOf]->(Oop) "
    "WITH * MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc)-[:hasSubprocess]->(ssc)-[:hasOptionalAutoOperation]->(Oop1) "
    "WITH DISTINCT Oop1 CREATE (nOop1:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_1'})-[:isIndividualOf]->(Oop1), (nOop2:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_2'})-[:isIndividualOf]->(Oop1) "
    "WITH * MATCH (Oop1)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH '" +namep+ "' AND pr2.name STARTS WITH '" +namep+ "' "
    "MERGE (nOop1)-[:hasPredecessor]->(pr1) MERGE (nOop2)-[:hasPredecessor]->(pr2) "
    "WITH * MATCH (p1:Operation), (p2:Operation), (p3:Operation), (p4:Operation), (p5:Operation), (p6:Operation) "
    "WHERE p1.name CONTAINS '"+namep+ "S40_04001_Camera at stating holes_1' AND p2.name CONTAINS '"+namep+ "S40_04012_Deburring int, positioning, attach them automatic_1' AND p3.name CONTAINS '"+namep+ "S40_04001_Camera at stating holes_2' AND p4.name CONTAINS '"+namep+ "S40_04012_Deburring int, positioning, attach them automatic_2' AND p5.name CONTAINS '"+namep+ "S40_02001_Set in position Rails and LFT' AND p6.name CONTAINS '"+namep+ "S40_04014_Deinstall LFT and rails' "
    "MERGE (p1)-[:hasPredecessor]->(p5) MERGE (p3)-[:hasPredecessor]->(p2) MERGE (p6)-[:hasPredecessor]->(p4) "
    "RETURN p5.name, p6.name" )
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    np = conn.query(str1, db)
    firstname = np[0][0] #name of the starting operation of the subauto process 'N3Set in position Rails and LFT'
    lastname = np[0][1] ##name of the last operation of the subauto process 'N3Deinstall LFT and rails'
    return firstname, lastname


#Create manual sequencial subprocess
def Neo4jCreateSubManualProcessSeq(conn, db, namep):
    #namep = "N3"
    str1 = ("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc)-[:hasSubprocess]->(ssc)-[:hasOptionalManualOperation]->(Oop1) "
    "WITH DISTINCT Oop1 CREATE (nOop1:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_1'})-[:isIndividualOf]->(Oop1), (nOop2:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_2'})-[:isIndividualOf]->(Oop1) "
    "WITH * MATCH (Oop1)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH '" +namep+ "' AND pr2.name STARTS WITH '" +namep+ "' "
    "MERGE (nOop1)-[:hasPredecessor]->(pr1) MERGE (nOop2)-[:hasPredecessor]->(pr2) "
    "WITH * MATCH (p1:Operation), (p2:Operation),(p0:Operation), (p3:Operation)  WHERE p1.name CONTAINS '"+namep+ "S40_04013_Deburring int, positioning, attach them manual_1'  AND p2.name CONTAINS '"+namep+"S40_04003_Drilling template install_2' AND p0.name CONTAINS '"+namep+ "S40_04003_Drilling template install_1' AND p3.name CONTAINS '"+namep+"S40_04013_Deburring int, positioning, attach them manual_2'"
    "MERGE (p2)-[:hasPredecessor]->(p1) "
    "RETURN p0.name, p3.name")
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    np = conn.query(str1, db)
    op10name = np[0][0] #name of the starting operation of the SubManualSeq process 'N3Drilling template install_1'
    op11name = np[0][1]
    return op10name, op11name

#Create manual parallel subprocess
def Neo4jCreateSubManualProcessPar(conn, db, namep):
    #namep = "N3"
    str1 = ("MATCH (p:n4sch__Class{n4sch__label: 'S40_Orbital Joint Process'})-[:hasSubprocess]->(sc)-[:hasSubprocess]->(ssc)-[:hasOptionalManualOperation]->(Oop1) "
    "WITH DISTINCT Oop1 CREATE (nOop1:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_1'})-[:isIndividualOf]->(Oop1), (nOop2:Operation{name: '"+namep+ "' + Oop1.n4sch__label + '_2'})-[:isIndividualOf]->(Oop1)"
    "WITH * MATCH (Oop1)-[:hasPredecessor]->(c1)<-[:isIndividualOf]-(pr1), (c1)<-[:isIndividualOf]-(pr2) WHERE pr1.name ENDS WITH '_1' AND pr2.name ENDS WITH '_2' AND pr1.name STARTS WITH '" +namep+ "' AND pr2.name STARTS WITH '" +namep+ "' "
    "MERGE (nOop1)-[:hasPredecessor]->(pr1) MERGE (nOop2)-[:hasPredecessor]->(pr2) "
    "WITH * MATCH (p1:Operation), (p2:Operation), (p3:Operation),(p4:Operation) WHERE p1.name CONTAINS '"+namep+ "S40_04003_Drilling template install_1' AND p2.name CONTAINS '"+namep+ "S40_04003_Drilling template install_2' AND p3.name CONTAINS '"+namep+ "S40_04013_Deburring int, positioning, attach them manual_1' AND p4.name CONTAINS '"+namep+ "S40_04013_Deburring int, positioning, attach them manual_2' "
    "RETURN p1.name, p2.name, p3.name, p4.name")
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    np = conn.query(str1, db) # np is a list [<Record oe.name='N3Set up working environment'>]
    op01name = np[0][0] #'N3Drilling template install_1'
    op02name = np[0][1] #'N3Drilling template install_2'
    op10name = np[0][2] #'N3Deburring int, positioning, attach them manual_1'
    op11name = np[0][3] #'N3Deburring int, positioning, attach them manual_2'
    #print(op0name)
    return op01name, op02name, op10name,op11name

#connect two nodes
def ConnectNodes(conn, db, name1, name2):
    str = ("MATCH (p1:Operation), (p2:Operation) WHERE p1.name CONTAINS '" + name1 + "' AND p2.name CONTAINS '" + name2 + "' MERGE (p2)-[:hasPredecessor]->(p1)" )
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    conn.query(str, db)

def AddResourceTime(conn, db, pid):
    str1 = ("MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[:requiresResource]->(res:n4sch__Class) WHERE op.name STARTS WITH '" + pid + "' "
    "WITH DISTINCT res CREATE (rob:Resource{name: '" + pid + "' + res.n4sch__label, n4sch__label: '" + pid + "' + res.n4sch__label, cost_hour:res.cost_hour, calendar:res.calendar})-[:isIndividualOf]->(res) "
    "WITH * MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class)-[r]->(res:n4sch__Class)<-[:isIndividualOf]-(rob) WHERE op.name STARTS WITH '" + pid + "' "
    "CREATE (op)-[:requiresResource{number: r.number}]->(rob)")
    str2 = ("MATCH (op:Operation)-[:isIndividualOf]->(cl:n4sch__Class) WHERE op.name STARTS WITH '" + pid + "' "
    "SET op.duration = cl.duration, op.op_type=cl.op_type")
    str3 = ("MATCH (op) WHERE op.name STARTS WITH '" + pid + "' "
    "SET op.n4sch__label = op.name")
    #conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    conn.query(str1, db)
    conn.query(str2, db)
    conn.query(str3, db)

if __name__ == "__main__":
    conn = Neo4jConnection(uri="bolt://localhost:7687",  user="neo4j", pwd="qu4lity")
    db = "orbitaljoint"
    #Remote server
    #conn = Neo4jConnection(uri="bolt://xx.xx.xx.xx:7687",  user="neo4j", pwd="qu4lity")
    #db = "neo4j"
    i = 1
    for p1 in ["SubAuto", "SubManualSeq", "SubManualPar"]:
        for p2 in ["SubAuto", "SubManualSeq", "SubManualPar"]:
            for r in ["sequencial", "parallel"]:
                pid = f"N{i:02}"
                op01, op02, op03, clean1, clean2, inspec1, inspec2 = Neo4jCreateMainProcess(conn, db, pid) #3 essential operations
                #print(op01, op02, op03, clean1, clean2, inspec1, inspec2)
                #N02S40_00001_Jig in N02S40_01001_Set up working environment  N02S40_00002_Jig out
                #N02S40_02002_Cleanup and add sealant_1 N02S40_02002_Cleanup and add sealant_2 N02S40_02003_Inspection_1 N02S40_02003_Inspection_2
                ##subProcess1
                if p1 == "SubAuto":
                    subauto0,subauto1 = Neo4jCreateSubAutoProcess(conn, db, pid+"U_")
                    ConnectNodes(conn, db, op02, subauto0)
                    ConnectNodes(conn, db, subauto1, clean1)
                elif p1 == "SubManualSeq":
                    SubManualSeq0, SubManualSeq1 = Neo4jCreateSubManualProcessSeq(conn, db, pid+"U_")
                    ConnectNodes(conn, db, op02, SubManualSeq0)
                    ConnectNodes(conn, db, SubManualSeq1, clean1)
                elif p1 == "SubManualPar":
                    SubManualPar01, SubManualPar02, SubManualPar11, SubManualPar12 = Neo4jCreateSubManualProcessPar(conn, db,pid+"U_")
                    ConnectNodes(conn, db, op02, SubManualPar01)
                    ConnectNodes(conn, db, op02, SubManualPar02)
                    ConnectNodes(conn, db, SubManualPar11, clean1)
                    ConnectNodes(conn, db, SubManualPar12, clean1)
                else:
                    print("error!")
                ##subProcess1
                if p2 == "SubAuto":
                    subauto2,subauto3 = Neo4jCreateSubAutoProcess(conn, db, pid+"L_")
                    ConnectNodes(conn, db, subauto3, clean2)
                    if r == "sequencial":
                        ConnectNodes(conn, db, inspec1, subauto2)
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                    elif r == "parallel":
                        ConnectNodes(conn, db, op02, subauto2)
                        ConnectNodes(conn, db, inspec1, op03) #jig out
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                elif p2 == "SubManualSeq":
                    SubManualSeq2, SubManualSeq3 = Neo4jCreateSubManualProcessSeq(conn, db, pid+"L_")
                    ConnectNodes(conn, db, SubManualSeq3, clean2)
                    if r == "sequencial":
                        ConnectNodes(conn, db, inspec1, SubManualSeq2)
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                    elif r == "parallel":
                        ConnectNodes(conn, db, op02, SubManualSeq2)
                        ConnectNodes(conn, db, inspec1, op03) #jig out
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                elif p2 == "SubManualPar":
                    SubManualPar11, SubManualPar12, SubManualPar21, SubManualPar22 = Neo4jCreateSubManualProcessPar(conn, db, pid+"L_")
                    ConnectNodes(conn, db, SubManualPar21, clean2)
                    ConnectNodes(conn, db, SubManualPar22, clean2)
                    if r == "sequencial":
                        ConnectNodes(conn, db, inspec1,SubManualPar11)
                        ConnectNodes(conn, db, inspec1,SubManualPar12)
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                    elif r == "parallel":
                        ConnectNodes(conn, db, op02,SubManualPar11)
                        ConnectNodes(conn, db, op02,SubManualPar12)
                        ConnectNodes(conn, db, inspec1, op03) #jig out
                        ConnectNodes(conn, db, inspec2, op03) #jig out
                        AddResourceTime(conn, db, pid)
                        print("---Process No. {} Created!!".format(i))
                        i = i+1
                else:
                    print("error!")
