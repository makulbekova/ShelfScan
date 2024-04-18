import os
from dotenv import load_dotenv
load_dotenv()
SALT = os.environ.get('SALT')
JWT_SECRET = os.environ.get('JWT_SECRET')
SCANS_DIR = '.\\scans'
