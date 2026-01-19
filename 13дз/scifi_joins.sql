DROP TABLE IF EXISTS contract CASCADE;
DROP TABLE IF EXISTS module_station CASCADE;
DROP TABLE IF EXISTS spaceship_module CASCADE;
DROP TABLE IF EXISTS player_faction CASCADE;
DROP TABLE IF EXISTS module CASCADE;
DROP TABLE IF EXISTS spaceship CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS planet CASCADE;
DROP TABLE IF EXISTS faction CASCADE;
DROP TABLE IF EXISTS player CASCADE;

CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    nickname TEXT NOT NULL UNIQUE,
    email TEXT
);

CREATE TABLE faction (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    alignment TEXT
);

CREATE TABLE player_faction (
    faction_id INT NOT NULL REFERENCES faction(id) ON DELETE CASCADE,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    call_sign TEXT NOT NULL,
    joined_at DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (faction_id, player_id),
    CONSTRAINT uniq_call_sign_per_faction UNIQUE (faction_id, call_sign)
);

CREATE TABLE planet (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    sector TEXT,
    population BIGINT
);

CREATE TABLE station (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    planet_id INT REFERENCES planet(id) ON DELETE SET NULL,
    orbit_altitude_km INT
);

CREATE TABLE spaceship (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    class TEXT,
    hull_points INT
);

CREATE TABLE module (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    module_type TEXT,
    rarity TEXT,
    power_usage INT,
    description TEXT
);

CREATE TABLE spaceship_module (
    spaceship_id INT NOT NULL REFERENCES spaceship(id) ON DELETE CASCADE,
    module_id INT NOT NULL REFERENCES module(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    equipped BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (spaceship_id, module_id)
);

CREATE TABLE module_station (
    station_id INT NOT NULL REFERENCES station(id) ON DELETE CASCADE,
    module_id INT NOT NULL REFERENCES module(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    vendor_name TEXT,
    PRIMARY KEY (station_id, module_id)
);

CREATE TABLE contract (
    id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES station(id) ON DELETE CASCADE,
    faction_id INT,
    call_sign TEXT,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    spaceship_id INT NOT NULL REFERENCES spaceship(id) ON DELETE CASCADE,
    module_id INT REFERENCES module(id) ON DELETE SET NULL,
    reward_credits INT,
    duration_days INT NOT NULL CHECK (duration_days > 0),
    accepted_at DATE NOT NULL DEFAULT CURRENT_DATE,
    completed_at DATE,
    CONSTRAINT fk_faction_call_sign FOREIGN KEY (faction_id, call_sign)
        REFERENCES player_faction (faction_id, call_sign)
        ON DELETE RESTRICT
);

CREATE INDEX idx_contract_player ON contract(player_id);
CREATE INDEX idx_contract_station ON contract(station_id);
CREATE INDEX idx_contract_module ON contract(module_id);

INSERT INTO player (id, nickname, email) VALUES
(1, 'NovaCaptain', 'nova@example.com'),
(2, 'QuantumMage', 'quantum@example.com'),
(3, 'ShadowRunner', 'shadow@example.com'),
(4, 'NewPilot', NULL),
(5, 'LoneWolf', 'lonewolf@example.com');

SELECT setval(pg_get_serial_sequence('player','id'), (SELECT MAX(id) FROM player));

INSERT INTO faction (id, name, alignment) VALUES
(1, 'Solar Union', 'Lawful'),
(2, 'Void Corsairs', 'Chaotic'),
(3, 'Neutral Traders Guild', 'Neutral');

SELECT setval(pg_get_serial_sequence('faction','id'), (SELECT MAX(id) FROM faction));

INSERT INTO player_faction (faction_id, player_id, call_sign, joined_at) VALUES
(1, 1, 'SUN-001', '2023-01-10'),
(1, 2, 'SUN-002', '2023-06-05'),
(2, 3, 'VOID-777', '2024-02-12'),
(1, 5, 'SUN-009', '2024-11-01');

INSERT INTO planet (id, name, sector, population) VALUES
(1, 'Terra Prime', 'Core', 12000000000),
(2, 'New Horizon', 'Rim', 500000000),
(3, 'Astra-7', 'Outer Belt', 12000000),
(4, 'Dead Rock', 'Void Edge', NULL);

SELECT setval(pg_get_serial_sequence('planet','id'), (SELECT MAX(id) FROM planet));

INSERT INTO station (id, name, planet_id, orbit_altitude_km) VALUES
(1, 'Terra Orbital Hub', 1, 350),
(2, 'Horizon Trade Ring', 2, 420),
(3, 'Astra Mining Station', 3, 120),
(4, 'Deep Void Relay', NULL, 0),
(5, 'Horizon Research Spire', 2, 600);

SELECT setval(pg_get_serial_sequence('station','id'), (SELECT MAX(id) FROM station));

INSERT INTO spaceship (id, name, player_id, class, hull_points) VALUES
(1, 'SS Nova Light', 1, 'Frigate', 3000),
(2, 'QMC Entangler', 2, 'Cruiser', 4500),
(3, 'Shadow Dancer', 3, 'Corvette', 2800),
(4, 'Rookie Shuttle', 4, 'Shuttle', 800),
(5, 'Wolf Fang', 5, 'Destroyer', 3800);

SELECT setval(pg_get_serial_sequence('spaceship','id'), (SELECT MAX(id) FROM spaceship));

INSERT INTO module (id, name, module_type, rarity, power_usage, description) VALUES
(1, 'Plasma Cannon Mk I', 'Weapon', 'Rare', 50, 'Basic plasma weapon.'),
(2, 'Shield Generator Alpha', 'Defense', 'Uncommon', 40, 'Standard shield generator.'),
(3, 'Warp Drive Beta', 'Engine', 'Epic', 60, 'Improved warp capabilities.'),
(4, 'Cargo Hold Extender', 'Utility', 'Common', 10, 'Increases cargo capacity.'),
(5, 'Cloaking Device', 'Stealth', 'Legendary', 70, 'Advanced stealth module.'),
(6, 'Point Defense Laser', 'Weapon', 'Uncommon', 30, 'Anti-missile defense.'),
(7, 'Nanobot Repair Bay', 'Support', 'Rare', 35, 'Automatic hull repair.');

SELECT setval(pg_get_serial_sequence('module','id'), (SELECT MAX(id) FROM module));

INSERT INTO spaceship_module (spaceship_id, module_id, quantity, equipped) VALUES
(1, 1, 1, TRUE),
(1, 2, 1, TRUE),
(2, 3, 1, TRUE),
(2, 4, 2, FALSE),
(3, 1, 1, TRUE),
(3, 5, 1, TRUE),
(5, 6, 2, TRUE);

INSERT INTO module_station (station_id, module_id, quantity, vendor_name) VALUES
(1, 2, 10, 'Terran Shields Inc'),
(1, 4, 25, 'Cargo Solutions'),
(2, 1, 3, 'Horizon Arms'),
(2, 6, 5, 'Defense Matrix'),
(2, 7, 2, 'NanoTech Vendor'),
(3, 4, 8, 'Mining Depot'),
(3, 6, 4, 'Security Hub'),
(5, 3, 1, 'Research Labs'),
(5, 5, 1, 'Black Lab Co.');

INSERT INTO contract (station_id, faction_id, call_sign, player_id, spaceship_id, module_id, reward_credits, duration_days, accepted_at) VALUES
(1, 1, 'SUN-001', 1, 1, 4, 5000, 7, '2025-11-01'),
(2, 1, 'SUN-002', 2, 2, 3, 8000, 10, '2025-10-20'),
(2, 2, 'VOID-777', 3, 3, 1, 7000, 5, '2025-11-05'),
(3, NULL, NULL, 2, 2, NULL, 3000, 3, '2025-11-10'),
(5, 1, 'SUN-009', 5, 5, 7, 9000, 12, '2025-11-12');

SELECT s.name AS ship_name, s.class, s.hull_points, p.nickname
FROM spaceship s
INNER JOIN player p ON s.player_id = p.id;

SELECT s.name AS ship_name, m.name AS module_name, m.module_type, sm.quantity, sm.equipped
FROM spaceship_module sm
INNER JOIN spaceship s ON sm.spaceship_id = s.id
INNER JOIN module m ON sm.module_id = m.id;

SELECT s.name AS ship_name, m.name AS module_name, m.module_type, sm.quantity, sm.equipped
FROM spaceship s
LEFT JOIN spaceship_module sm ON s.id = sm.spaceship_id
LEFT JOIN module m ON sm.module_id = m.id;

SELECT p.nickname, COUNT(s.id) AS ship_count
FROM player p
LEFT JOIN spaceship s ON p.id = s.player_id
GROUP BY p.id, p.nickname;

SELECT st.name AS station_name, m.name AS module_name, ms.quantity
FROM station st
RIGHT JOIN module_station ms ON st.id = ms.station_id
RIGHT JOIN module m ON ms.module_id = m.id;

SELECT m.module_type, COUNT(DISTINCT ms.station_id) AS station_count
FROM module m
LEFT JOIN module_station ms ON m.id = ms.module_id
GROUP BY m.module_type;

SELECT m.name AS module_name, ms.station_id, ms.quantity
FROM module m
FULL JOIN module_station ms ON m.id = ms.module_id;

SELECT p.nickname, f.name AS faction_name, pf.call_sign
FROM player p
FULL JOIN player_faction pf ON p.id = pf.player_id
FULL JOIN faction f ON pf.faction_id = f.id;

SELECT st.name AS station_name, m.module_type
FROM station st
CROSS JOIN (SELECT DISTINCT module_type FROM module) m;

SELECT s.name AS ship_name, st.name AS station_name
FROM spaceship s
CROSS JOIN station st
LIMIT 100;

SELECT st.name AS station_name, m.name AS module_name, ms.quantity
FROM station st
LEFT JOIN LATERAL (
    SELECT ms2.module_id, ms2.quantity
    FROM module_station ms2
    WHERE ms2.station_id = st.id
    ORDER BY ms2.quantity DESC
    LIMIT 1
) ms ON TRUE
LEFT JOIN module m ON ms.module_id = m.id;

SELECT p.nickname, c.station_id, c.module_id, c.accepted_at
FROM player p
LEFT JOIN LATERAL (
    SELECT c2.station_id, c2.module_id, c2.accepted_at
    FROM contract c2
    WHERE c2.player_id = p.id
    ORDER BY c2.accepted_at DESC
    LIMIT 1
) c ON TRUE;

SELECT s1.name AS ship1, s2.name AS ship2, p.nickname
FROM spaceship s1
INNER JOIN spaceship s2 ON s1.player_id = s2.player_id AND s1.id < s2.id
INNER JOIN player p ON s1.player_id = p.id;

SELECT m1.name AS module1, m2.name AS module2, m1.rarity
FROM module m1
INNER JOIN module m2 ON m1.rarity = m2.rarity AND m1.id < m2.id;