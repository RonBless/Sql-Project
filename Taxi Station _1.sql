CREATE SCHEMA taxi_station_1;
USE taxi_station_1;


CREATE TABLE Station
(station_number		float NOT NULL,
city				char(25),
street				char(25),
phone_num				float,
PRIMARY KEY			(station_number)

)ENGINE = InnoDB;


CREATE TABLE Employee
(id					float NOT NULL,
emp_name			char(25),
age					smallint,
phone				float, 
start_day			date,
salary				float, 
city_address		char(25),
station_num			float,
PRIMARY KEY			(id),
FOREIGN KEY (station_num) REFERENCES Station(station_number)

)ENGINE = InnoDB;





CREATE TABLE Receptionist
(Receptionist_id		float NOT NULL, 
PRIMARY KEY (Receptionist_id),
constraint fk_Receptionist_id_doesnt_exists
foreign key(Receptionist_id) references Employee(id)

on delete cascade
) ENGINE = InnoDB;


CREATE TABLE Driver
(license_num		float NOT NULL,
id					float NOT NULL,
car_license_date 	date NOT NULL,

primary key (id),
constraint fk_id_doesnt_exists
foreign key(id) references Employee(id)

on delete cascade
)ENGINE = InnoDB;



create table Taxi_car
(
Driverid			float NOT NULL,
car_license 		float NOT NULL unique, 
model				char(25),
insurance_date		date,
station_num			float,

constraint primary key 	(Driverid) ,
foreign key (Driverid) REFERENCES Driver(id),
FOREIGN KEY (station_num) REFERENCES Station(station_number)
)ENGINE = InnoDB;



CREATE TABLE Event_call
(event_id			char(25) NOT NULL, 
client_name			char(25), 
address				char(25), 
station_number		float,
date_accured		date,
receptionist_id		float,
event_time			time, 


PRIMARY KEY		(event_id) ,
FOREIGN KEY (station_number) REFERENCES Station(station_number),
FOREIGN KEY (receptionist_id) REFERENCES Receptionist(Receptionist_id)

)ENGINE = InnoDB;


CREATE TABLE Acutal_event
(event_id			char(25) NOT NULL, 
arrival_time		time, 
price				smallint,
driver_id			float,
PRIMARY KEY		(event_id),
constraint fk_event_id_doesnt_exists
foreign key(event_id) references Event_call(event_id),
foreign key(driver_id) references driver(id)


)ENGINE = InnoDB;


CREATE TABLE Taxi_apps
(
app_name			char(25) NOT NULL,
monthly_price		smallint,
clients_num			float,
station_number		float,
PRIMARY KEY		(app_name),
FOREIGN KEY (station_number) REFERENCES Station(station_number)

)ENGINE = InnoDB;


# -------------------- Trrigers --------------------


CREATE TABLE Employee_log
(id                 float NOT NULL,
emp_name_old        char(25),
emp_name_new        char(25),
age_old             smallint,
age_new             smallint,
phone_old           float,
phone_new           float, 
start_day_old       date,
start_day_new       date,
salary_old          float,
salary_new          float, 
city_address_old    char(25),
city_address_new    char(25),
station_num_old     float,
station_num_new     float,
command_ts timestamp,
command varchar(10));


delimiter $
CREATE TRIGGER Employee_ins_trg AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
 INSERT INTO Employee_log VALUES(new.id, null, new.emp_name, null, new.age,null, new.phone,null, new.start_day, null, new.salary
 , null, new.city_address, null, new.station_num, now(), 'insert');
END$
   
delimiter ;



create table Taxi_car_log
(
Driverid				float NOT NULL,
car_license 			float, 
old_model				char(25),
new_model				char(25),
old_insurance_date		date,
new_insurance_date		date,
old_station_num			float,
new_station_num			float,
command_ts timestamp,
command varchar(10));


delimiter $
CREATE TRIGGER Taxi_car_ins_trg AFTER INSERT ON taxi_car
FOR EACH ROW
BEGIN
 INSERT INTO Taxi_car_log VALUES(new.Driverid, new.car_license, null, new.model,null, new.insurance_date,null, new.station_num, now(), 'insert');
END$
   
delimiter ;

delimiter $
CREATE TRIGGER Taxi_car_upd_trg AFTER UPDATE ON Taxi_car
FOR EACH ROW
BEGIN
 INSERT INTO Taxi_car_log VALUES(new.Driverid, new.car_license, old.model, new.model,
 old.insurance_date, new.insurance_date, old.station_num, new.station_num, now(), 'update');
END$
   
delimiter ;

delimiter $
CREATE TRIGGER Taxi_car_trg AFTER DELETE ON Taxi_car
FOR EACH ROW
BEGIN
 INSERT INTO Taxi_car_log VALUES(old.Driverid, old.car_license, old.model, null,
 old.insurance_date, null, old.station_num, null, now(), 'delete');
END$
   
delimiter ;


create table Taxi_apps_log
(
app_name			char(25) NOT NULL,
old_monthly_price		smallint,
new_monthly_price		smallint,
old_clients_num			float,
new_clients_num			float,
old_station_number		float,
new_station_number		float,


command_ts timestamp,
command varchar(10));



delimiter $
CREATE TRIGGER Taxi_apps_trg AFTER DELETE ON Taxi_apps
FOR EACH ROW
BEGIN
 INSERT INTO Taxi_apps_log VALUES(old.app_name, old.monthly_price,null, old.clients_num, null,
 old.station_number, null, now(), 'delete');
END$
   
delimiter ;


INSERT INTO Station VALUES
#(station_num, city, street, phone_num)
('100','Tel Aviv','Frishman 42',036083264),
('101','Rishhon Lezion','Zalman Shneur 16', 036654567),
('102','Ashdod','Menachem Begin 1', 086789964);



INSERT INTO Employee VALUES
#(id, emp_name, age, phone, start_day, salary, city_address, station_num)
('1','Moshe','30', 0534679976, '2017-07-04', 6000, 'Tel Aviv', 100),
('2','Shani','52',0526873345, '2011-12-08', 7535, 'Tel Aviv', 100),
('3','Gilad', '25',0548889756, '2020-02-26', 8000, 'Rishon Lezion', 101),
('4','Dima', '64',0538869945, '2008-05-13', 9743, 'Rishon Lezion', 101),
('5','Lital', '47',0538768895, '2011-12-08', 8000, 'Rishon Lezion', 101),
('6','Ofir', '33',0505678829, '2017-07-04', 9867, 'Ashdod', 102),
('7','Yuval', '64',0538869945, '2008-05-13', 9743, 'Ashdod', 102),
('8','Shimon', '47',0543478876, '2011-12-08', 8000, 'Rishon Lezion', 101),
('9','Michael', '37',0522389765, '2017-07-04', 7653, 'Tel Aviv', 100);


INSERT INTO Receptionist VALUES
#(id)
(1), #Tel Aviv
(3), #Rishon Lezion
(6); #Ashdod

INSERT INTO Driver VALUES
#(licence_num, id, car_license_date)
(30, 2, '2023-07-04'),
(31, 4, '2024-05-01'),
(32, 5, '2022-07-12'), 
(33, 7, '2023-11-14'),
(34, 8, '2023-08-02'),
(35, 9, '2021-02-24');



INSERT INTO Taxi_car VALUES
#(Driverid, car_license, model, insurance_date, station_num)
(2, 700, 'Toyota', '2025-6-23', 100),
(4, 701, 'Mitsubishi', '2022-11-24', 101),
(5, 702, 'Honda', '2020-12-25', 100),
(7, 703, 'Fiat', '2024-06-23', 102),
(8, 704, 'Toyota', '2021-06-09', 102),
(9, 705, 'Honda', '2025-12-06', 101);




INSERT INTO Event_call VALUES
#(event_id, client_name, address, station_number, date,receptionist_id, event_time)
(500, 'Moshe', 'Rishon Leszion', 100, '2021-08-07',3, 081000),
(501, 'Sarit', 'Ashdod', 102, '2020-11-08',6, 100000),
(502, 'Shoshana', 'Ashdod', 101, '2019-04-21',6, 172100),
(503, 'Yaakov', 'Tel Aviv', 102, '2020-11-27',1, 210300);



INSERT INTO Acutal_event VALUES
#(event_id, arrival_time, price)
(500, 083000, 30, 4),
(501, 101500, 42, 7),
(502, 175200, 20, 7),
(503, 212300, 150, 2);


INSERT INTO Taxi_apps VALUES
#(app_name, monthly_price, clients_num, station_num)
('Get Taxi', 5000, 25000, 100),
('Yango', 3000, 5000, 102),
('Txi', 2500, 1000, 101);



#--------------------------Queries-----------------------

#User type 1: CEO/CFO - Will use the database for more genral informaition about all of his staitions 

#User type 2: station manager - Will use for more specific events and employees 

#CEO: 
#Query 1 - shows all the employees that works at Tel Aviv and Rishon staitions and theres an i in their name. orders by age.(lower to upper)
SELECT * FROM Employee
where station_num in(100,101) AND emp_name LIKE '%i%' 
ORDER BY age;

#Query 2 - shows the data of the client and the date of actual_event where..
select client_name, event_id, date_accured
from event_call
where event_time > '170000' and address like 'Tel aviv';

#Query 3 - length for rides
select event_id , price, 
	CASE WHEN price BETWEEN 10 AND 35 THEN 'Short Ride'
		WHEN price BETWEEN 36 AND 80 THEN 'Medium length ride'
        ELSE 'Long length Ride'
        END AS 'Legth of drives by price'
FROM Acutal_event
ORDER BY price;

#Query 4 - gets the receptionist name who handles each event call
select employee.emp_name as recptionist_name,
event_call.* from employee join
event_call on employee.id =
event_call.receptionist_id; 

#Query 5 - gives us every driver and what car he drove (car plate) to each Actual_event
select employee.emp_name as driver,
taxi_car.car_license, Acutal_event.*
from employee join taxi_car
on employee.id = taxi_car.driverid
join Acutal_event on taxi_car.driverid = 
Acutal_event.driver_id;

#Query 6 - shows the wanted information of the employee that works as a receptionist at station 100 (tel aviv)
SELECT station.station_number as station, emp_name as name,  employee.age, employee.phone, employee.start_day
from station, employee,
(SELECT employee.id, receptionist.receptionist_id
FROM employee, receptionist
WHERE receptionist.receptionist_id = employee.id
GROUP BY receptionist_id) as a
WHERE station.station_number = 100
GROUP BY station_number;

#Query 7 - Leaving a taxi app 
DELETE FROM taxi_apps WHERE app_name = 'Txi';
select * from taxi_apps_log;


#Query 8 - Adding a new Employee
INSERT INTO Employee VALUES('10','Lior', '25',0546887555, curdate(), 4500, 'Rishon Lezion', 100);
select * from employee_log;







#Station Manager
#Query 1 - shows the employee with the highest salary on station 101
SELECT * FROM Employee
WHERE employee.station_num = 101
ORDER BY salary desc limit 1;
 

#Query 2 - shows the most senior worker (rounds the amount years) and the oldest worker
SELECT distinct employee.*,
	ROUND((DATEDIFF(CURDATE(),start_day))/365) AS 'Seniority By Years',
	DAY(start_day) AS 'Start Day',
    MONTH(start_day) AS 'Start Month',
    YEAR(start_day) AS 'Start Year'
FROM Employee
GROUP BY age
ORDER BY employee.age desc;

#Query 3 - shows how much time it took for the taxi to come since the order time
SELECT TIMEDIFF(Acutal_event.arrival_time, event_call.event_time) As 'time_passed_since_order',
event_call.event_time as order_time, Acutal_event.arrival_time, event_call.date_accured
FROM event_call
INNER JOIN Acutal_event ON event_call.event_id = Acutal_event.event_id;

#Query 4  - shows all employees from station 100, but first shows the receptionist and then the drivers
SELECT employee.emp_name, employee.id, employee.station_num
FROM 
(
    SELECT driver.id FROM driver 
    UNION ALL
    SELECT receptionist.Receptionist_id FROM receptionist
) t1
INNER JOIN employee
ON  employee.id = t1.id
WHERE station_num = 100;

#Query 5 - "Shows us which driver has an outdated car insurance!
SELECT taxi_car.driverid, employee.emp_name, employee.station_num,
	CASE WHEN DATEDIFF(CURDATE(),insurance_date) >=0 THEN 'outdated'
		ELSE 'not outdated'
		END AS 'Is the insurance date outdated'
		from taxi_car JOIN employee
		ON taxi_car.driverid = employee.id
		order by driverid;

#Query 6- giving all the driver from station 100 (tel aviv) and their events (they need to have an event they took part in in order to show)

select employee.emp_name as driver, employee.station_num,
taxi_car.car_license, Acutal_event.*
from employee join taxi_car
on employee.id = taxi_car.driverid
join Acutal_event on taxi_car.driverid = 
Acutal_event.driver_id where employee.station_num = 100;



#Query 7 - Firing some employees
DELETE FROM taxi_Car where Driverid = 9;


#Query 8 - Updating the employee who we found out as an outdated insurance
update Taxi_car
set insurance_date = date_add(insurance_date, INTERVAL 1 year)
where Driverid = 5;

select * from taxi_car_log ;




show triggers from Taxi_Station_1;







