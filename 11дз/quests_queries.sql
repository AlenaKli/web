DROP TABLE IF EXISTS quests;
CREATE TABLE quests (
    quest_id SERIAL PRIMARY KEY,
    quest_date DATE NOT NULL,
    realm TEXT NOT NULL CHECK(realm IN ('Valoria', 'Nordheim', 'Sandsea', 'Blackreach')),
    player_class TEXT NOT NULL CHECK(player_class IN ('warrior', 'mage', 'rogue', 'cleric')),
    mode TEXT NOT NULL CHECK(mode IN ('solo', 'party')),
    quest_type TEXT NOT NULL CHECK(quest_type IN ('hunt', 'escort', 'dungeon', 'bounty')),
    difficulty INT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('accepted', 'completed', 'failed', 'abandoned', 'cancelled')),
    reward_gold NUMERIC(7,2) NOT NULL,
    reward_xp INT NOT NULL,
    consumables_cost NUMERIC(7,2) NOT NULL DEFAULT 0,
    fine NUMERIC(7,2) NOT NULL DEFAULT 0
);

INSERT INTO quests (quest_date, realm, player_class, mode, quest_type, difficulty, status, reward_gold, reward_xp, consumables_cost, fine) VALUES
('2025-01-03','Valoria','warrior','solo','hunt',3,'completed',180,300,20,0),
('2025-01-04','Valoria','mage','party','dungeon',4,'completed',260,520,35,0),
('2025-01-05','Valoria','rogue','solo','bounty',2,'cancelled',90,120,0,0),
('2025-01-07','Valoria','cleric','solo','escort',2,'completed',140,260,10,0),
('2025-01-10','Valoria','warrior','party','dungeon',5,'failed',340,700,45,30),
('2025-02-01','Nordheim','mage','party','dungeon',5,'completed',320,680,50,0),
('2025-02-02','Nordheim','rogue','solo','bounty',3,'completed',170,310,15,0),
('2025-02-03','Nordheim','cleric','party','escort',3,'completed',150,280,12,0),
('2025-02-05','Nordheim','warrior','solo','hunt',2,'abandoned',110,150,10,0),
('2025-02-08','Nordheim','mage','solo','hunt',4,'completed',210,380,25,0),
('2025-03-01','Sandsea','rogue','solo','bounty',4,'completed',220,420,18,0),
('2025-03-02','Sandsea','cleric','party','escort',2,'completed',120,200,8,0),
('2025-03-03','Sandsea','warrior','party','dungeon',5,'completed',360,750,55,0),
('2025-03-05','Sandsea','mage','solo','hunt',3,'failed',160,300,22,15),
('2025-03-07','Sandsea','rogue','solo','bounty',1,'completed',80,120,5,0),
('2025-03-10','Blackreach','warrior','party','dungeon',5,'completed',400,820,60,0),
('2025-03-11','Blackreach','mage','solo','hunt',2,'completed',130,240,12,0),
('2025-03-12','Blackreach','rogue','party','bounty',3,'completed',190,350,16,0),
('2025-03-14','Blackreach','cleric','solo','escort',3,'abandoned',135,230,9,0),
('2025-03-16','Blackreach','warrior','solo','hunt',4,'completed',210,390,27,0),
('2025-04-01','Valoria','rogue','party','dungeon',4,'completed',280,560,40,0),
('2025-04-02','Valoria','cleric','solo','escort',1,'completed',75,110,4,0),
('2025-04-03','Nordheim','warrior','party','dungeon',5,'failed',350,720,58,25),
('2025-04-04','Nordheim','mage','solo','hunt',3,'completed',175,330,18,0),
('2025-04-06','Sandsea','cleric','party','escort',2,'cancelled',115,180,0,0),
('2025-04-07','Sandsea','warrior','solo','hunt',4,'completed',205,370,24,0),
('2025-04-08','Blackreach','rogue','solo','bounty',3,'completed',185,340,14,0),
('2025-04-09','Blackreach','mage','party','dungeon',5,'completed',390,800,62,0);

SELECT quest_id, realm, status,
    CASE 
        WHEN status = 'completed' THEN reward_gold - consumables_cost - fine 
        ELSE 0 
    END AS net_gold,
    CASE 
        WHEN difficulty BETWEEN 1 AND 2 THEN 'easy'
        WHEN difficulty BETWEEN 3 AND 4 THEN 'mid'
        WHEN difficulty = 5 THEN 'hard'
    END AS diff_band
FROM quests
ORDER BY quest_date, quest_id;

SELECT quest_id, mode, difficulty
FROM quests
WHERE difficulty > CASE WHEN mode = 'solo' THEN 3 ELSE 4 END;

SELECT realm, 
    COUNT(*) AS q_cnt,
    SUM(reward_gold) AS sum_gold,
    AVG(reward_xp) AS avg_xp,
    MAX(difficulty) AS max_diff
FROM quests
GROUP BY realm
ORDER BY sum_gold DESC;

SELECT player_class,
    SUM(reward_gold - consumables_cost - fine) FILTER (WHERE status = 'completed') AS completed_gold,
    COUNT(*) FILTER (WHERE status = 'failed') AS fail_cnt,
    COUNT(*) FILTER (WHERE status = 'failed')::NUMERIC / COUNT(*) AS fail_rate
FROM quests
GROUP BY player_class
ORDER BY fail_rate DESC;

SELECT quest_type,
    COUNT(*) AS total_quests,
    COUNT(*) FILTER (WHERE status = 'failed') AS failed_count,
    SUM(reward_gold - consumables_cost - fine) FILTER (WHERE status = 'completed') AS completed_gold
FROM quests
GROUP BY quest_type
HAVING 
    COUNT(*) FILTER (WHERE status = 'failed')::NUMERIC / COUNT(*) > 0.20
    OR SUM(reward_gold - consumables_cost - fine) FILTER (WHERE status = 'completed') > 800
ORDER BY quest_type;

SELECT realm, mode,
    COUNT(DISTINCT quest_date) AS unique_days,
    AVG(reward_gold - consumables_cost - fine) FILTER (WHERE status = 'completed') AS avg_completed_net,
    AVG((difficulty > CASE WHEN mode = 'solo' THEN 3 ELSE 4 END)::INT) AS hard_share
FROM quests
GROUP BY realm, mode
HAVING COUNT(*) FILTER (WHERE status IN ('failed', 'abandoned')) >= 2
ORDER BY avg_completed_net DESC;