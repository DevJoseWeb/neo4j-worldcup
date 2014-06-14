USING PERIODIC COMMIT 1000
//LOAD CSV WITH HEADERS FROM "https://dl.dropboxusercontent.com/u/7619809/matches.csv" AS csvLine
LOAD CSV WITH HEADERS FROM "file:/Users/markneedham/projects/neo4j-worldcup/data/import/lineups.csv" AS csvLine

MATCH (match:Match {id: csvLine.match_id})
MATCH (wc:WorldCup {name: csvLine.world_cup})<-[:FOR_WORLD_CUP]-()<-[:IN_SQUAD]-(player {name: csvLine.player})

// home players
FOREACH(n IN (CASE csvLine.team WHEN "home" THEN [1] else [] END) |
	FOREACH(o IN (CASE csvLine.type WHEN "starting" THEN [1] else [] END) |
		MERGE (match)-[:HOME_TEAM]->(home)
		MERGE (player)-[:STARTED]->(stats)-[:IN_MATCH]->(match)
		MERGE (stats)-[:FOR]->(home)
	)

	FOREACH(o IN (CASE csvLine.type WHEN "sub" THEN [1] else [] END) |
		MERGE (match)-[:HOME_TEAM]->(home)
		MERGE (player)-[:SUBSTITUTE]->(stats)-[:IN_MATCH]->(match)
		MERGE (stats)-[:FOR]->(home)
	)	
)

// away players
FOREACH(n IN (CASE csvLine.team WHEN "away" THEN [1] else [] END) |
	FOREACH(o IN (CASE csvLine.type WHEN "starting" THEN [1] else [] END) |
		MERGE (match)-[:AWAY_TEAM]->(away)
		MERGE (player)-[:STARTED]->(stats)-[:IN_MATCH]->(match)
		MERGE (stats)-[:FOR]->(away)
	)

	FOREACH(o IN (CASE csvLine.type WHEN "sub" THEN [1] else [] END) |
		MERGE (match)-[:AWAY_TEAM]->(home)
		MERGE (player)-[:SUBSTITUTE]->(stats)-[:IN_MATCH]->(match)
		MERGE (stats)-[:FOR]->(away)
	)	
);