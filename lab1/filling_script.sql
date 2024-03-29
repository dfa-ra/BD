INSERT INTO Origin (country, language_, city)
VALUES
    ('Russia', 'Russian', 'Moscow'),
    ('USA', 'English', 'New York'),
    ('Russia', 'Russian', 'Omsk');

INSERT INTO Type_personality (type_personality, toxicity_level)
VALUES
    ('Pacifist', 10),
    ('Sociopath', 90),
    ('Peaceful', 0);

INSERT INTO Hobby (hobby_name, complexity)
VALUES
    ('chess', 99),
    ('joke', 80),
    ('checkers', 80),
    ('tell stories', 50),
    ('play the guitar', 80),
    ('sing', 40),
    ('play computer games', 10);

INSERT INTO Place (place_name, x, y)
VALUES
    ('Saturn', 2, 100),
    ('Sever star', 2332, -3445),
    ('Earh', 23, -324),
    ('Pluton', 23, -324),
    ('Mars', 23, -324),
    ('V-867', 23, -324);

INSERT INTO Type_spaceship (speed, capacity, spaceship_origin, space_programm)
VALUES
    (3453, 3, 1, 'RosCosmos'),
    (102, 10, 2, 'Nasa');


INSERT INTO Crew (crew_name)
VALUES
    ('Zenit'),
    ('Spartak');

INSERT INTO Human (human_name, surname, age, gender, nationality, personality_type, place, crew_id)
VALUES  
    ('Roman', 'Zakharchenko', 18, 'Male', 1, 1, 1, 1),
    ('Evgeniy', 'Kuranov', 18, 'Male', 1, NULL, 1, 1),
    ('Polya', 'Polivanavna', 19, 'Female', 3, NULL, 1, 1),
    ('Sasha', 'Upokoenov', 18, 'Male', 1, NULL, 1, 2),
    ('Zina', 'Zverobitobich', 19, 'Female', 3, NULL, 1, 2),
    ('Floyd', 'Chupchinky', 27, 'Male', 2, 1, 1, 1),
    ('Kurnou', 'Podzivloty', 23, 'Male', 2, 1, 2, 1);

INSERT INTO Human_hobby(human_id, hobby_id)
VALUES 
    (6, 2),
    (1, 1), 
    (6, 4),
    (7, 2),
    (7, 5);

INSERT INTO Spaceship (spaceship_name, type_spaceship, place)
VALUES
    ('SoIOZ SPASENiAY', 1, 1),    
    ('posIMaba', 2, 2);

INSERT INTO Space_flight(crew_id, spaceship_id, average_speed, distance, duration, flighy_vibe, departure_date, arrival_date)
VALUES
    (1, 1, 223, 123123, 12321, 'Normal', '2010-10-17', '2024-02-04');    
