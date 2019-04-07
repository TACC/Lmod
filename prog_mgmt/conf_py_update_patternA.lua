patternA = {
   {"^(version *= *)'[^']*'", "%1'" .. myVersion     .. "'"  },
   {"^(release *= *)'[^']*'", "%1'" .. myFullVersion .. "'"  },
}


