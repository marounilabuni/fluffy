from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep

#driver = webdriver.Chrome('chromedriver.exe')
from selenium.webdriver.chrome.service import Service
from selenium import webdriver

from selenium.webdriver.chrome.options import Options
import requests
import json



with open('data.json', 'r') as f:
     data = json.loads(f.read())

print(data[0])

