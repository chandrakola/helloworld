from django.test import SimpleTestCase
from django.urls import reverse

class HelloWorldTests(SimpleTestCase):
    def test_hello_world_view(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Hello World from Django!!!")
