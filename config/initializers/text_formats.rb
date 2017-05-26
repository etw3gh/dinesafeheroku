# if the text file format is not listed here
# downloader.rb will consider the file to be a binary file
# add formats as required
# aspx added for future web scraping....
Rails.application.config.text_formats = ['html', 'htm', 'json', 'xml', 'txt', 'md', 'aspx']