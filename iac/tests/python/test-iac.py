import random
import glob
import unittest
import os
import xmlrunner

class TestModule(unittest.TestCase):

    def setUp(self):
        self.seq = list(range(10))

    def test_readme_existence(self):
        # test if there is a README.md file
        readme_path = './{}/README.md'.format(os.environ['BUILD_REPOSITORY_NAME'])
        self.assertTrue(os.path.exists(readme_path), 'Readme file({}) should exists.'.format(readme_path))

    def test_template_files(self):
        bicep_files = glob.glob('./{}/template/*.bicep'.format(os.environ['BUILD_REPOSITORY_NAME']))
        self.assertGreater(len(bicep_files), 0, 'There should be at least one bicep file in the template folder.')

        bicep_config_path = './{}/template/bicepconfig.json'.format(os.environ['BUILD_REPOSITORY_NAME'])
        self.assertTrue(os.path.exists(bicep_config_path), 'The bicepconfig.json file({}) should exists.'.format(bicep_config_path))


if __name__ == '__main__':
    unittest.main(
        testRunner=xmlrunner.XMLTestRunner(output='dist/test-results'),
        failfast=False, buffer=False, catchbreak=False)
