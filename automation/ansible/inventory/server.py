#!/bin/env python
from subprocess import Popen,PIPE
import sys
import json


result = {}
result['linux'] = {}
result['linux']['hosts'] = []
result['linux']['vars']  = {}


pipe = Popen(['getent', 'hosts'], stdout=PIPE,universal_newlines=True)

for line in pipe.stdout.readlines():
    s = line.split()
    if s[1].startswith('fedora'):
        result['linux']['hosts'].append(s[1])

if len(sys.argv) == 2 and sys.argv[1] == '--list':
    print(json.dumps(result))
elif len(sys.argv) == 3 and sys.argv[1] == '--host':
    print(json.dumps({}))
else:
    print("Requires an argument, please use --list or --host <host>")
