#!/bin/bash

pandoc -s -t html -V fontsize=16 -V mainfont="Liberation Mono" -V backgroundcolor="#121215" -V fontcolor="#60b020" -o public/resume/index.html public/resume/resume.docx 2>/dev/null