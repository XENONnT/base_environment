"""
Sync requirements with https://github.com/XENONnT/ax_env

Example:
    cd base_environment
    python renew_requirements.py dry
    python renew_requirements.py
    git checkout -b updates
    git commit -m "sync with ax-env"
    git push
"""

from straxen import get_resource
import sys

def update_req_file(
        pull_from='https://raw.githubusercontent.com/XENONnT/ax_env/master/extra_requirements/requirements-tests.txt',
        replace='./requirements.txt',
        ignore_lines=('git+',),
        dry=False,

):
    """
    Uppdate requirements fril with that of ax_env
    :param pull_from: url to fetch requirements from
    :param replace: path to requirements file to be updated
    :param ignore_lines: ignore lines that match this pattern
    :param dry: do a test run (print only and don't modify)
    :return:
    """
    new_requirements = get_resource(pull_from, fmt='txt').split('\n')
    with open(replace, 'r') as f:
        old_file = f.read()
    old_file = old_file.split('\n')
    new_file = old_file.copy()

    for req in new_requirements:
        if (any(l in req for l in ignore_lines)
                or req.startswith('#')
                or not len(req)):
            continue
        dependency = req.split('==')[0]
        for i, o in enumerate(old_file):
            if dependency == o.split('==')[0]:
                comment = o.split('#')
                if len(comment) == 2:
                    # replacing in place - bad but since there is only one per entry - its fine.
                    req = f'{req:50} #{comment[1]}'
                new_file[i] = req
    if dry:
        for n, o in zip(new_file, old_file):
            if n != o:
                print(f'-{o}\n+{n}\n')
        return
    with open(replace, 'w') as f:
        for line in new_file:
            f.write(f'{line}\n')


if __name__ == '__main__':
    update_req_file(dry=len(sys.argv)>1)
