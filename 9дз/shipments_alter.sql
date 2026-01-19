DROP TABLE IF EXISTS shipment_raw CASCADE;

CREATE TABLE shipment_raw (
    id              serial PRIMARY KEY,
    recipient_name  text,
    weight_grams    integer,
    shipped_at      timestamp DEFAULT now(),
    status          text DEFAULT 'pending',
    deprecated_flag boolean DEFAULT false
);

INSERT INTO shipment_raw (recipient_name, weight_grams, shipped_at, status, deprecated_flag) VALUES
('Alice Johnson',     350,    now() - interval '30 days',  'pending',  false),
('Bob Smith',         1250,   now() - interval '29 days',  'shipped',  false),
('Charlie Brown',     7800,   now() - interval '28 days',  'shipped',  false),
('Diana Prince',      25000,  now() - interval '27 days',  'pending',  false),
('Evan Lee',          520,    now() - interval '26 days',  'canceled', false),
('Fiona Adams',       999,    now() - interval '25 days',  'pending',  false),
('George Miller',     15400,  now() - interval '24 days',  'shipped',  false),
('Hannah Davis',      2300,   now() - interval '23 days',  'pending',  false),
('Ian Wright',        4875,   now() - interval '22 days',  'pending',  false),
('Julia Stone',       300,    now() - interval '21 days',  'shipped',  false),
('Kevin Park',        42000,  now() - interval '20 days',  'shipped',  false),
('Laura Chen',        750,    now() - interval '19 days',  'pending',  false),
('Mark Green',        1800,   now() - interval '18 days',  'canceled', false),
('Nina Patel',        605,    now() - interval '17 days',  'pending',  false),
('Oscar Diaz',        9800,   now() - interval '16 days',  'shipped',  false),
('Paula Gomez',       1525,   now() - interval '15 days',  'pending',  false),
('Quinn Baker',       26800,  now() - interval '14 days',  'shipped',  false),
('Rita Ora',          410,    now() - interval '13 days',  'pending',  false),
('Sam Young',         3500,   now() - interval '12 days',  'pending',  false),
('Tina King',         12400,  now() - interval '11 days',  'shipped',  false),
('Uma Reed',          890,    now() - interval '10 days',  'pending',  false),
('Victor Hugo',       650,    now() - interval '9 days',   'canceled', false),
('Wendy Frost',       22200,  now() - interval '8 days',   'shipped',  false),
('Yara Novak',        510,    now() - interval '7 days',   'pending',  false),
('Zack Cole',         17500,  now() - interval '6 days',   'shipped',  false),
('Ola Svensson',      990,    now() - interval '5 days',   'pending',  false),
('Maja Nilsson',      30500,  now() - interval '4 days',   'shipped',  false),
('Erik Karlsson',     470,    now() - interval '3 days',   'pending',  false),
('Sara Lind',         5550,   now() - interval '2 days',   'pending',  false),
('Anton Larsson',     8200,   now() - interval '1 days',   'shipped',  false);


ALTER TABLE shipment_raw RENAME TO shipments;

ALTER TABLE shipments 
ALTER COLUMN weight_grams TYPE numeric(10,3) 
USING (weight_grams / 1000.0);

ALTER TABLE shipments 
RENAME COLUMN weight_grams TO weight_kg;


ALTER TABLE shipments 
ADD COLUMN tracking_code text;

UPDATE shipments 
SET tracking_code = 'TRK-' || to_char(shipped_at, 'YYYYDDD') || '-' || lpad(id::text, 5, '0');


ALTER TABLE shipments 
DROP COLUMN deprecated_flag;
