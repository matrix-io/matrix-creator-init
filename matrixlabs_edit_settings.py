#!/usr/bin/python2

' Modify Raspberry Pi settins '

import sys


# BUGS: We don't uncomment lines and instead add a new line with the
# required value.

def read_lines(file_name):
    ' Parse config file '
    ret = []
    with open(file_name) as input_file:
        line = input_file.readline()
        while len(line):
            line = line.strip()
            if line.startswith('#') or line == '':
                ret.append(['REMARK', line])
            else:
                ret.append(['SETTING', line])
            line = input_file.readline()
    return ret

def key_and_value(line):
    ' Get the key and the value of a setting '
    assert line[0] == 'SETTING'
    splitted = line[1].split('=')
    return '='.join(splitted[:-1]), splitted[-1]

ORIGINAL_LINES = read_lines(sys.argv[1])

KEYS_TO_CHANGE = {}
for new_line in read_lines(sys.argv[2]):
    # We throw away comments in the modifications. It's not wasy to place them!
    if new_line[0] == 'SETTING':
        key, value = key_and_value(new_line)
        KEYS_TO_CHANGE[key] = value

for original in ORIGINAL_LINES:
    if original[0] == 'REMARK':
        print original[1]
    else:
        key, value = key_and_value(original)
        if key in KEYS_TO_CHANGE and KEYS_TO_CHANGE[key] != value:
            new_value = KEYS_TO_CHANGE[key]
            print '# previous value for {} was {}.'.format(key,
                                                           value,
                                                           new_value),
            print 'Changed by matrixlabs_edit_settings.py'
            print '{}={}'.format(key, new_value)
            del  KEYS_TO_CHANGE[key]
        elif key in KEYS_TO_CHANGE and KEYS_TO_CHANGE[key] == value:
            print '{}={}'.format(key, KEYS_TO_CHANGE[key])
            del KEYS_TO_CHANGE[key]
        else:
            print original[1]

if len(KEYS_TO_CHANGE):
    print '# Lines added by matrixlabs_edit_settings.py.'
    print '# Commented definitions of the settings might be above.'

for key  in sorted(KEYS_TO_CHANGE):
    print '{}={}'.format(key, KEYS_TO_CHANGE[key])
