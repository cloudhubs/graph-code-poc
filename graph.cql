
CREATE CONSTRAINT ON (s:System) ASSERT s.systemId IS UNIQUE;
CREATE CONSTRAINT ON (m:Module) ASSERT m.moduleId IS UNIQUE;
CREATE CONSTRAINT ON (c:Class) ASSERT c.classId IS UNIQUE;
CREATE CONSTRAINT ON (met:Method) ASSERT met.methodId IS UNIQUE;
CREATE CONSTRAINT ON (r:Role) ASSERT r.roleId IS UNIQUE;

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/systems.csv' AS row
WITH toInteger(row.systemId) AS systemId, row.systemName AS systemName
MERGE (s:System {systemId: systemId})
  SET s.systemName = systemName
RETURN count(s);

MATCH (s:System)
RETURN s LIMIT 20;

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/modules.csv' AS row
WITH toInteger(row.moduleId) AS moduleId, row.moduleName AS moduleName
MERGE (m:Module {moduleId: moduleId})
  SET m.moduleName = moduleName
RETURN count(m);

MATCH (m:Module)
RETURN m LIMIT 20;

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/systems-modules.csv' AS row
WITH toInteger(row.systemId) AS systemId, toInteger(row.moduleId) AS moduleId
MATCH (s:System {systemId: systemId})
MATCH (m:Module {moduleId: moduleId})
MERGE (s)-[rel:HAS_MODULE{}]->(m)
RETURN count(rel);

MATCH (s:System)-[rel:HAS_MODULE]->(m:Module)
RETURN s, rel, m LIMIT 50;

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/classes.csv' AS row
WITH toInteger(row.classId) AS classId, row.className AS className
MERGE (c:Class {classId: classId})
  SET c.className = className
RETURN count(c);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/methods.csv' AS row
WITH toInteger(row.methodId) AS methodId, row.methodName AS methodName
MERGE (met:Method {methodId: methodId})
  SET met.methodName = methodName
RETURN count(met);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/roles.csv' AS row
WITH toInteger(row.roleId) AS roleId, row.roleName AS roleName
MERGE (r:Role {roleId: roleId})
  SET r.roleName = roleName
RETURN count(r);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/modules-classes.csv' AS row
WITH toInteger(row.moduleId) AS moduleId, toInteger(row.classId) AS classId
MATCH (m:Module {moduleId: moduleId})
MATCH (c:Class {classId: classId})
MERGE (m)-[rel:HAS_CLASS{}]->(c)
RETURN count(rel);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/classes-methods.csv' AS row
WITH toInteger(row.classId) AS classId, toInteger(row.methodId) AS methodId
MATCH (c:Class {classId: classId})
MATCH (met:Method {methodId: methodId})
MERGE (c)-[rel:HAS_METHOD{}]->(met)
RETURN count(rel);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/methods-roles.csv' AS row
WITH toInteger(row.methodId) AS methodId, toInteger(row.roleId) AS roleId
MATCH (met:Method {methodId: methodId})
MATCH (r:Role {roleId: roleId})
MERGE (met)-[rel:HAS_ROLE{}]->(r)
RETURN count(rel);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/roles-roles.csv' AS row
WITH toInteger(row.roleIdA) AS roleIdA, toInteger(row.roleIdB) AS roleIdB
MATCH (rA:Role {roleId: roleIdA})
MATCH (rB:Role {roleId: roleIdB})
MERGE (rA)-[rel:NEXT{}]->(rB)
RETURN count(rel);

LOAD CSV WITH HEADERS FROM 'file:///desktop-csv-import/methods-methods.csv' AS row
WITH toInteger(row.methodIdA) AS methodIdA, toInteger(row.methodIdB) AS methodIdB
MATCH (metA:Method {methodId: methodIdA})
MATCH (metB:Method {methodId: methodIdB})
MERGE (metA)-[rel:NEXT{}]->(metB)
RETURN count(rel);