from sqlalchemy import create_engine
import urllib.parse
import configparser

# Read the config file and generate a database connection string
def build_engine_string(configpath='db.ini'):
    config = configparser.ConfigParser()
    config.read(configpath)
    dbconfig = dict(config.items('db'))
    dbconfig['password'] = urllib.parse.quote_plus(dbconfig['password'])
    return "postgresql://{username}:{password}@{hostname}:{port}/{dbname}".format(**dbconfig)

def connect(config='db.ini'):
    return create_engine(build_engine_string(config))

