DROP TABLE IF EXISTS Space_flight CASCADE;
DROP TABLE IF EXISTS Human_hobby CASCADE;
DROP TABLE IF EXISTS Human CASCADE;
DROP TABLE IF EXISTS Spaceship CASCADE;
DROP TABLE IF EXISTS Type_spaceship CASCADE;
DROP TABLE IF EXISTS Type_personality CASCADE;
DROP TABLE IF EXISTS Place CASCADE;
DROP TABLE IF EXISTS Origin CASCADE;
DROP TABLE IF EXISTS Crew CASCADE;
DROP TABLE IF EXISTS Hobby CASCADE;

DROP TYPE IF EXISTS country_enum CASCADE;
DROP TYPE IF EXISTS language_enum CASCADE;
DROP TYPE IF EXISTS city_enum CASCADE;
DROP TYPE IF EXISTS type_personality_enum CASCADE;
DROP TYPE IF EXISTS gender_enum CASCADE;
DROP TYPE IF EXISTS space_programm_enum CASCADE;

DROP DOMAIN IF EXISTS positiv_int CASCADE;
DROP DOMAIN IF EXISTS procent_int CASCADE;

CREATE TYPE country_enum AS ENUM ('USA', 'Russia', 'China', 'Germany', 'Austria', 'France', 'India', 'Japan');
CREATE TYPE language_enum AS ENUM ('Russian', 'English', 'German', 'Hebrew', 'Chinese', 'Complex with hieroglyphs');
CREATE TYPE city_enum AS ENUM ('Moscow', 'New York', 'St. Petersburg', 'Hamburg', 'Munich', 'Paris', 'Berlin', 'Omsk', 'Barnaul', 'Murmansk', 'Las Vegas');
CREATE TYPE type_personality_enum AS ENUM ('Pacifist', 'Optimist', 'Sociophobe', 'Sociopath', 'Jerk', 'Cheerful', 'Peaceful', 'Humble');
CREATE TYPE gender_enum AS ENUM ('Male', 'Female', 'Iron');
CREATE TYPE space_programm_enum AS ENUM ('Nasa', 'SpaceX', 'RosCosmos');

CREATE DOMAIN positiv_int AS INTEGER
CHECK (VALUE > 0);

CREATE DOMAIN procent_int AS INTEGER
CHECK (VALUE >= 0 AND VALUE <= 100);

CREATE TABLE IF NOT EXISTS Origin (
    id SERIAL PRIMARY KEY,
    country country_enum NOT NULL,
    language_ language_enum NOT NULL,
    city city_enum NOT NULL
);

CREATE TABLE IF NOT EXISTS Hobby(
    id SERIAL PRIMARY KEY,
    hobby_name TEXT NOT NULL,
    complexity procent_int
);

CREATE TABLE IF NOT EXISTS Type_personality(
    id SERIAL PRIMARY KEY,
    type_personality type_personality_enum NOT NULL,
    toxicity_level procent_int NOT NULL
);

CREATE TABLE IF NOT EXISTS Place(
    id SERIAL PRIMARY KEY,
    place_name TEXT NOT NULL,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Crew(
    id SERIAL PRIMARY KEY,
    crew_name text NOT NULL
);

CREATE TABLE IF NOT EXISTS Human(
    id SERIAL PRIMARY KEY,
    human_name TEXT NOT NULL,
    surname TEXT NOT NULL,
    age positiv_int NOT NULL,
    gender gender_enum NOT NULL,
    nationality INTEGER REFERENCES Origin(id) NOT NULL,
    personality_type INTEGER REFERENCES Type_personality(id),
    place INTEGER REFERENCES Place(id) NOT NULL,
    crew_id INTEGER REFERENCES Crew(id)
);

CREATE TABLE IF NOT EXISTS Type_spaceship(
    id SERIAL PRIMARY KEY,
    speed INTEGER NOT NULL,
    capacity positiv_int NOT NULL,
    spaceship_origin INTEGER REFERENCES Origin(id) NOT NULL,
    space_programm space_programm_enum NOT NULL
);

CREATE TABLE IF NOT EXISTS Spaceship(
    id SERIAL PRIMARY KEY,
    spaceship_name TEXT NOT NULL,
    type_spaceship INTEGER REFERENCES Type_spaceship(id) NOT NULL
    place INTEGER REFERENCES Place(id) NOT NULL,
);


CREATE TABLE IF NOT EXISTS Space_flight(
    crew_id INTEGER REFERENCES Crew(id) NOT NULL,
    spaceship_id INTEGER REFERENCES Spaceship NOT NULL,
    PRIMARY KEY (crew_id, spaceship_id),
    average_speed INTEGER NOT NULL,
    distance INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    flighy_vibe TEXT NOT NULL,
    departure_date DATE NOT NULL,
    arrival_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Human_hobby(
    human_id INTEGER REFERENCES Human(id) NOT NULL,
    hobby_id INTEGER REFERENCES Hobby(id) NOT NULL,
    PRIMARY KEY (human_id, hobby_id)
);
