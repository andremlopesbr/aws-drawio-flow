import unittest
import json
import sys
import os

# Adiciona o diretório atual ao path para importação
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from index import handler

class TestLambdaHandler(unittest.TestCase):
    def test_handler_success(self):
        event = {"key": "value"}
        context = None
        
        response = handler(event, context)
        
        self.assertEqual(response["statusCode"], 200)
        
        body = json.loads(response["body"])
        self.assertEqual(body["message"], "Lambda function executed successfully!")
        self.assertEqual(body["input"], event)

if __name__ == '__main__':
    unittest.main()
