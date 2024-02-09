#!/bin/bash

comm -12 <(cat requirements.txt | grep == | cut -d' ' -f1 | sort) <(cat extra_requirements/requirements-tests.txt | grep == | cut -d' ' -f1 | sort)
