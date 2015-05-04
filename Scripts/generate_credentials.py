# -*- coding: utf-8 -*-
# http://google-styleguide.googlecode.com/svn/trunk/pyguide.html

import getopt
import sys
import os

template = \
"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>GooglePlaceApiKey</key>
	<string>{googlePlaceApiKey}</string>
</dict>
</plist>
"""

def generate(directory=None):
    if directory is None:
        raise Exception('Not specified directory.')

    file_path = os.path.join(directory, "Credentials.plist")
    with open(file_path, 'w+') as f:
        f.write(template.format(
            googlePlaceApiKey = "API_KEY"
        ))

    print "Created %s" % file_path

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], "d:", ["directory="])
    except getopt.GetoptError:
        print "Help TODO(vojta)"
        sys.exit(2)

    directory = None
    for opt, arg in opts:
        if opt in ("-d", "--directory"):
            directory = arg

    # generate configs
    generate(directory=directory)
