import requests

endpoint = 'http://localhost:3217/userregistration';

data = {
    'userId': 'testuser',
    'password': 'testpassword',
    'appId': 'testApp'
}

r = requests.post(endpoint, params=data)
print r.json()
