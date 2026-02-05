import setuptools


def open_requirements(path):
    with open(path) as f:
        requires = [
            r.split('/')[-1] if r.startswith('git+') else r
            for r in f.read().splitlines()]
    return requires

with open('README.md') as file:
    readme = file.read()

requires = open_requirements('extra_requirements/requirements-tests.txt')

setuptools.setup(
    name='base_environment',
    version='2026.02.1',
    description='Base software environment for XENONnT, including python and data management tools',
    author='base_environment contributors, the XENON collaboration',
    url='https://github.com/XENONnT/base_environment',
    long_description=readme,
    long_description_content_type="text/markdown",
    setup_requires=['pytest-runner'],
    install_requires=requires,
    python_requires=">=3.11",
    packages=setuptools.find_packages() + ['extra_requirements'],
    package_dir={'extra_requirements': 'extra_requirements'},
    package_data={'extra_requirements': ['requirements-tests.txt']},
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3.11',
        'Intended Audience :: Science/Research',
        'Programming Language :: Python :: Implementation :: CPython',
        'Topic :: Scientific/Engineering :: Physics',
    ],
    zip_safe=False,
)
