import hashlib
from .constants import SALT
def hash_password(password):
    hashed_password = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), SALT.encode('utf-8'), 100000)
    return SALT + str(hashed_password)

def verify_password(stored_password, provided_password):
    stored_password = stored_password[len(SALT):]
    hashed_password = hashlib.pbkdf2_hmac('sha256', provided_password.encode('utf-8'), SALT.encode('utf-8'), 100000)
    print(hashed_password)
    print(stored_password)
    return str(hashed_password) == stored_password
