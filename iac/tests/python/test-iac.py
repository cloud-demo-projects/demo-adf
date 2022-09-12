    def setUp(self):
        self.seq = list(range(10))
    
    def test_readme_existence(self):   
        # test if there is a README.md file
        readme_path = './{}/README.md'.format(os.environ['BUILD_REPOSITORY_NAME'])
        self.assertTrue(os.path.exists(readme_path), 'Readme file({}) should exists.'.format(readme_path)) 
