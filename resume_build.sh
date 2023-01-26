#!/bin/bash

pandoc -s -t html -V mainfont="Liberation Mono" -V backgroundcolor="#121215" -V fontcolor="#50b020" -o public/resume/index.html public/resume/resume.docx 2>/dev/null