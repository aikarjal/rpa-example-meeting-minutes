import requests, os
from pathlib import Path

class KeywordLibrary(object):

    def __init__(self):
        pass

    def download_document(self, url):
        pdf_name = url.rsplit('/', 1)[1]
        file_path = Path('./pdf')
        if not file_path.exists():
            os.makedirs(file_path)

        with open(file_path / pdf_name, "wb") as file:
            response = requests.get(url)
            file.write(response.content)
        return response.status_code == 200
