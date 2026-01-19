CREATE TABLE ITEM (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    rarity TEXT NOT NULL CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
    stack_limit INTEGER NOT NULL CHECK (stack_limit > 0)
);

CREATE TABLE ITEM_INFO (
    item_id INTEGER PRIMARY KEY,
    weight NUMERIC NOT NULL CHECK (weight >= 0),
    is_tradeable BOOLEAN NOT NULL,
    durability_max INTEGER NOT NULL CHECK (durability_max >= 0),
    FOREIGN KEY (item_id) REFERENCES ITEM(id) ON DELETE CASCADE
);

CREATE TABLE RECIPE (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    output_item_id INTEGER NOT NULL,
    craft_time_seconds INTEGER NOT NULL CHECK (craft_time_seconds > 0),
    required_station TEXT NOT NULL CHECK (required_station IN ('campfire', 'anvil', 'alchemy_table')),
    FOREIGN KEY (output_item_id) REFERENCES ITEM(id) ON DELETE RESTRICT
);

CREATE TABLE RECIPE_INGREDIENT (
    recipe_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (recipe_id, item_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPE(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES ITEM(id) ON DELETE RESTRICT
);