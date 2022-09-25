INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_avocat', 'Avocat', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_avocat', 'Avocat', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_avocat', 'Avocat', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('avocat','Avocat')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('avocat',0,'recruit','Stagiaire',20,'{}','{}'),
	('avocat',1,'stagiaire','Avocat',40,'{}','{}'),
	('avocat',2,'boss','Patron',60,'{}','{}')
;