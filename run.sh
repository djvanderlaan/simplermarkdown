
pandoc -s foo.md -t json | Rscript proc.R | pandoc -s -f json -o foo.pdf


pandoc -s foo.md --filter proc.R  -o foo.pdf


