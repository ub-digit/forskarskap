# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

=======
# forskstat
Statistics on researchers cupboards




# Necessary information in case modification is to be done

---GUNDA---
The application currently retrieves data from GUNDA at 

  Controllers -> people_controller.rb in "create"
  Models -> person.rb in "findGundaPerson" and "updatePerson" 
  db -> seed.rb under "People"

It gives either the personnumber or cardnumber and recieves the name, personnumber and cardnumber in return.

Since GUNDA stores peoples personnumbers as YYMMDDXXXX, the applications database only allows this format. If a new database for the library is created with a different format, this restriction will need to be changed in Models -> person.rb.


---LOG IN---
The login is a "http_basic_authenticate_with" located in Controllers -> people_controller.rb


---IP-LOCK---
The IP-lock works through a simple if-case, in Controllers -> visits_controller.rb in "new"


---NEW LOCKERS---
There is currently no way to add new lockers to the database through the application. The people using the application is aware of this, and may ask for some to be added. 


---SEED---
OBS: The current SEED-file REMOVES all existing data in the database. DO NOT run it before modifying it.

It also currently reads three files called LOCKERS.LST, INDEX.LST and LOGG.LST located in the "public" folder






