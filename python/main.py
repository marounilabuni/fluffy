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

data = []

chrome_options = Options()
chrome_options.add_argument("--disable-extensions")
driver = webdriver.Chrome(options=chrome_options)

driver.get("https://tabitisrael.co.il/tabit-order?siteName=blackstoretlv&step=menu")

sleep(2)
selector = 'body > app-root > block-ui > div > div > app-tabit-order > div > div > div > app-desktop-to-start > div > div > div > service-buttons > div > div'

btn = driver.find_element(by=By.CSS_SELECTOR, value=selector)


btn.click()

input('> ')



cat_class = 'to-menu-category-wrapper'
i = 0
cats = driver.find_elements(by=By.CLASS_NAME, value=cat_class)
for cat in cats:
    cat_name = cat.find_element(by=By.CLASS_NAME, value='menu-category-header')

    selector = 'to-menu-item'
    cards = cat.find_elements(by=By.CSS_SELECTOR, value=selector)




    for card in cards:
        item = {}

        title_class = 'item-name-text'
        title_el = card.find_element(by=By.CLASS_NAME, value=title_class)

        description_class = 'item-description-text'
        description_el = card.find_element(by=By.CLASS_NAME, value=description_class)
        
        price_class ='item-price'
        price_el = card.find_element(by=By.CLASS_NAME, value=price_class)
        data.append(
            {
                'title':title_el.text,
                'description':description_el.text,
                'price':price_el.text,
                'category':cat_name.text,
                'index':i,
                
            }
        )
        print(i)
        i += 1
        
        img = card.find_element(by=By.TAG_NAME, value='img')
        src = img.get_attribute('src')
        res = requests.get(src)
        with open(fr'C:\Users\maroun ailabouni\Desktop\flutter\food_menu\assets\images\items\{i}.jpg','wb') as f:
            f.write(res.content)




with open('data.json', 'w', encoding='utf-8') as f:
     f.write(json.dumps(data))

input('>>>>>>>>>>>>> ')
driver.close()
