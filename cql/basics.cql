// R
// get all nodes and relationships
MATCH (n) RETURN n;
// get all nodes included in relationships
START n=node(*) MATCH (n)-[r]->(m) RETURN n,r,m;
// D
// delete all nodes
MATCH (n) DETACH DELETE n;
// C
// create a node
CREATE (ian:Person { name: 'Ian' })
CREATE (john:Person { name: 'John' })
// create relationship
CREATE (john)-[:TEAMMATE]->(ian)
