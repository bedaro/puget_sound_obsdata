# Puget Sound Observation Database

[!Database entity relationship diagram](doc/puget_sound_obsdata.pgerd.png)

A collection of Python scripts and notebooks for the creating and loading of a
database of observation data for Puget Sound water quality. The notebooks
process data files that are publicly available from their respective agencies,
either online or by public disclosure request. Most of the data is not hosted
in this repository, but the notebooks are intended to be able to extract and
load the data from the format each agency typically provides, with minimal
manual processing.

* All parameters are transformed to use common measurement units, which are
  self-described in a `parameters` table.
* All timestamps are in UTC to avoid any daylight savings confusion.
* Data collected as part of a CTD cast is assigned a common UUID so a depth
  profile can be interpolated easily, as opposed to discrete bottle
  measurements.
* The tables use natural keys whenever reasonable.
* The schema contains foreign key and unique constraints to avoid data
  duplication or breaking the table relationships.
* Measurement locations are tracked in a PostGIS-enabled `stations` table with
  coordinates in UTM zone 10. NANOOS cruises often report slightly different
  coordinates for common station names, and these location differences are
  preserved by creating unique entries in the table for them.
* The source of each observation is tracked through a relationship to a
  `sources` table, so every record can be traced back to its original provider.

## Database Setup

The Postgres database schema is in `db.sql`. It was created with `pg_dump --file db.sql --host <hostname> --port <port> --username <username> --verbose --format=p -C --schema-only "puget_sound_obsdata"`.

To get started, create the database on an instance of Postgres with PostGIS
installed by running

```
psql --set ON_ERROR_STOP=on postgres < db.sql
```

The database will automatically be given the name `puget_sound_obsdata`, but
this can be customized by editing the SQL script before running.

Database connections are handled through a Python module named `db.py`. This
simple module assembles a SQLAlchemy connection string by reading connection
options from a config file named `db.ini`. You must create this file. It
should be in the standard Python configparser format and contain the following,
as an example:

```
[db]
hostname = db_host
post = db_port
username = db_user
password = db_password
dbname = puget_sound_obsdata
```

All of the above parameters should be set according to your local
configuration.

## The ETL Notebooks

Certain notebooks need to be run before others to populate the database. The
order listed here should work, although not all of them depend on each other
so tightly; for instance, you can probably run the PRISM notebook before or
after the King County ones.

1. `load_initial_data.ipynb`: Populates the `parameters` table. This must be
   run first.
2. `load_ecology_ctd.ipynb`: Extracts, transforms, and loads Washington
   Department of Ecology CTD cast data from the Marine Water study,
   downloadable from EIM.
3. `load_ecology_bottle.ipynb`: Extracts, transforms, and loads Washington
   Department of Ecology lab-analyzed bottle data from the Marine Water study,
   available by public request from the agency. This notebook depends on the
   CTD notebook having been run first to create the source, and provide CTD
   data which has more precise time specification than the bottle spreadsheets
   tend to have.
4. `load_cruises.ipynb`: Extracts, transforms, and loads Salish cruise data
   available from NANOOS. All of the .zip files available for download can be
   imported, but take note that not all cruise files contain the lab data. I
   was able to request the missing lab data in a NetCDF format directly from
   NANOOS staff, and this notebook will load those NetCDF files as well when
   it detects that lab data is otherwise missing for a particular cruise.
5. `load_kingcounty.ipynb`: Extracts, transforms, and loads various King
   County Marine Monitoring data. Some of this is directly downloadable from
   the program website, while the lab data is available by request from the
   marine water quality group.

## Data Quality Control

The notebooks perform some automatic QA filtering by removing any data that is
suspect or flagged as inaccurate. It should be noted, however, that this is
not intended to be a complete quality assurance process for the dataset; manual
review may be required for your application if you intend to do more than just
basic research with the data.

## To Do

* Import King County mooring data
* Import NOAA moorings
