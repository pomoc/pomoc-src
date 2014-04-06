import requests

# user registration test
endpoint = 'http://localhost:3217/userRegistration'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
    'appToken': 'testtoken',
    'appSecret': 'testsecret',
}
r = requests.post(endpoint, data=data)
print 'login:', r.json()


# user login test
endpoint = 'http://localhost:3217/agentLogin'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
    'appToken': 'testtoken',
    'appSecret': 'testsecret',
}
r = requests.post(endpoint, data=data)
print 'agentLogin:', r.json()


# app registration test
endpoint = 'http://localhost:3217/appRegistration'
data = {
    'userId': 'testuser',
    'password': 'testpassword',
}
r = requests.post(endpoint, data=data)
print 'appRegistration:', r.json()
