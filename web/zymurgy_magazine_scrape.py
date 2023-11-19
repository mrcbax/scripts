#! /usr/bin/env python

import requests
import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.common import exceptions


ROOT_URL = "https://www.homebrewersassociation.org/zymurgy-magazine/page/"
POST_URL = "https://mydigitalpublication.com/publication/logincheck.php"
requests_session = requests.Session()
headers = {
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0'
}
cookie_jar = {
    'clientIP':'Undefined',
    'customerType':'AHA',
    'firstname':'REDACTED',
    'isMonthly':'false',
    'OptanonConsent':'isGpcEnabled=0&datestamp=Mon+Jun+20+2022+01%3A08%3A27+GMT-0400+(Eastern+Daylight+Time)&version=6.32.0&isIABGlobal=false&hosts=&landingPath=NotLandingPage&groups=C0005%3A0%2CC0003%3A0%2CC0004%3A0%2CC0002%3A0%2CC0001%3A1&AwaitingReconsent=false',
    'paidThrough':'6/26/2022%2012:00:00%20AM',
    'uimis':'900370942',
    'username':'REDACTED@EXAMPLE.COM'
}
for x in range(1, 13):
    url = ROOT_URL + str(x) + "/";
    page = requests_session.get(url, cookies=cookie_jar, headers=headers)
    soup = BeautifulSoup(page.content, "html.parser")
    summary_divs = soup.find_all("div", class_="entry-summary")
    links = soup.find_all("a", class_="text-link", href=True)
    for link in links:
        page = requests_session.get(link['href'], cookies=cookie_jar, headers=headers)
        soup = BeautifulSoup(page.content, "html.parser")
        form = soup.find("form", class_="mr-2")
        #print(form)
        post_data = {
            'coupon_id': form.find('input', {'name':'coupon_id'}).get('value'),
            'i': form.find('input', {'name':'i'}).get('value'),
            'l': form.find('input', {'name':'l'}).get('value')
        }
        book_page = requests_session.post(POST_URL, data=post_data)
        soup = BeautifulSoup(book_page.content, "html.parser")
        download_url = 'https://mydigitalpublication.com' + soup.find('meta', {'http-equiv': 'refresh'}).get('content')[6:-1]
        #print(download_url)

        service = Service(executable_path=ChromeDriverManager().install())
        options = webdriver.ChromeOptions()
        options.add_experimental_option('prefs', {
            "download.default_directory": "./zymurgy", #Change default directory for downloads
            "download.prompt_for_download": False, #To auto download the file
            "download.directory_upgrade": True,
            "plugins.always_open_pdf_externally": True #It will not show PDF directly in chrome
        })
        driver = webdriver.Chrome(service=service, options=options)
        cookies = requests_session.cookies.get_dict()
        driver.get('https://mydigitalpublication.com')
        for cookie_key in cookies.keys():
            #print(cookie_key + ': ' + cookies[cookie_key])
            try:
                driver.add_cookie({'name': cookie_key, 'value': cookies[cookie_key]})
            except exceptions.InvalidCookieDomainException as e:
                print(e)
        driver.get(download_url)
        time.sleep(3)
        try:
            driver.switch_to.frame("viewerFrame")
        except:
            try:
                driver.switch_to.frame('contentFrame')
                driver.switch_to.frame("viewerFrame")
            except:
                print("manual browse required:\n\tpage: " + link['href'] + "\n\tdownload url: " + download_url + "\n")
                continue
        driver.execute_script("var pagebutton = document.getElementById('getPdfBtn');pagebutton.click();")
        time.sleep(4)
        driver.quit()
