import requests

# user registration test
endpoint = 'http://localhost:3217/userregistration'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
    'appToken': 'testtoken',
    'appSecret': 'testsecret',
}
r = requests.post(endpoint, params=data)
print 'login:', r.json()


# user login test
endpoint = 'http://localhost:3217/login'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
    'appToken': 'testtoken',
    'appSecret': 'testsecret',
}
r = requests.post(endpoint, params=data)
print 'login:', r.json()


# app registration test
endpoint = 'http://localhost:3217/appregistration'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
}
r = requests.post(endpoint, params=data)
print 'login:', r.json()
