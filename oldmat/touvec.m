function s = touvec(f)

s = regexprep(char(simplify(f)),'u([0-9]+)','u($1)');