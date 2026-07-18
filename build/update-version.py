import sys
import json
import pathlib
import re
from datetime import datetime

if len(sys.argv) != 3:
    sys.exit('Usage: update-version.py <version> <date>.')

update_version = sys.argv[1]
update_date = sys.argv[2]

date_data = datetime.strptime(update_date, '%Y-%m-%d')
update_date_format = f'{date_data.day} {date_data.strftime('%B')} {date_data.year}'

pattern_version = re.compile(r'\d+\.\d+\.\d+')
pattern_date = re.compile(r'\d{4}-\d{2}-\d{2}')

if not pattern_version.fullmatch(update_version):
    sys.exit('Version requires format: <major>.<minor>.<patch>.')

if not pattern_date.fullmatch(update_date):
    sys.exit('Date requires format: <year>-<month>-<day>.')

with open('update-version-files.json', 'r') as json_file:
    update_replacements = json.load(json_file)

for replacement in update_replacements:
    for update_file in pathlib.Path('..').rglob(replacement['file_ext']):
        file_text = update_file.read_text()

        file_text = re.sub(
            replacement['pattern_version'],
            replacement['replace_version'].format(version=update_version),
            file_text,
            count=1,
            flags=re.MULTILINE
        )
        if replacement.get('date_format', False):
            file_text = re.sub(
                replacement['pattern_date'],
                replacement['replace_date'].format(date=update_date_format),
                file_text,
                count=1,
                flags=re.MULTILINE
            )
        else:
            file_text = re.sub(
                replacement['pattern_date'],
                replacement['replace_date'].format(date=update_date),
                file_text,
                count=1,
                flags=re.MULTILINE
            )

        update_file.write_text(file_text, newline='\n')

print('Done.')