import os
import subprocess

os.chdir('..')
subprocess.run(['git', 'archive', '--prefix=hawkdraw/', '--output=hawkdraw.zip', 'HEAD']) 