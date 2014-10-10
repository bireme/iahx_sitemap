iahx_sitemap
============

- About sitemaps

A sitemap is a file where you can list the web pages of your site to tell Google and other search 
engines about the organization of your site content. Search engine web crawlers like Googlebot 
read this file to more intelligently crawl your site.

- iahx_sitemap application objective

Create XML files indicating shaped link for each existing document iAHx in order to provide 
for the search engine Google.

- Install the iahx_sitemap application

Note.: The install mode was done on Ubuntu Linux

1) Create virtualenv
# install virtualenv
sudo apt-get install python-virtualenv
virtualenv IAHX_Sitemaps

2) Install the python module requests
sudo apt-get install python-pip
sudo pip install requests

3) Install tidy - tool to check HTML and XML files HTML e XML
sudo apt-get install tidy

4) Go to a suitable installation directory and check out the application source:
~/IAHX_Sitemaps $ git clone https://github.com/bireme/iahx_sitemap.git

5) Give execute permission to the following files
cd ~/IAHX_Sitemaps
chmod 775 bin/activate
chmod 775 iahx_sitemap/sitemap.sh
chmod 775 iahx_sitemap/tpl/2-XMLs.sh
chmod 775 iahx_sitemap/tpl/createSitemap.sh

6) Configuration for your iAHx
Edit the file below and set as your environment
~/IAHX_Sitemaps/iahx_sitemap/tpl/getConfig.inc

7) Running the application
cd ~/IAHX_Sitemaps/iahx_sitemap
./sitemap.sh

8) Results
cd ~/IAHX_Sitemaps/iahx_sitemap/sitemap

The result should be copied to a public area of your website, and then the link should be 
created in the Google tool for the sitemap available in http://www.google.com.br/webmasters/



2014/October

