#!/bin/bash

cd /home/a/code/quatloo/public/resume/

pandoc -s -t html -V fontsize=16 -V mainfont="Liberation Mono" -V backgroundcolor="#121215" -V fontcolor="#60b020" -o index.html resume.docx