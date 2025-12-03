DROP TABLE IF EXISTS bm_orders;

CREATE TABLE IF NOT EXISTS bm_orders (
  id           VARCHAR(64) PRIMARY KEY,
  identifier   VARCHAR(64) NOT NULL,
  items_json   JSON NOT NULL,
  ready_at     INT NOT NULL,
  x DOUBLE NOT NULL, 
  y DOUBLE NOT NULL, 
  z DOUBLE NOT NULL, 
  h DOUBLE NOT NULL,
  state        ENUM('pending','ready','completed') NOT NULL DEFAULT 'pending',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
