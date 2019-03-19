#include <stdio.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char* argv[])
{
  const char* str = "  '/opt/apps/lmod/lmod/lib\'exec/RC2lua.tcl '  -F   -a \"foo:bar:baz\" \t -b bar amber/9";

  int  done; 
  char boundary;
  const char* left;

  const char* p;
  size_t len, a, b;

  a    = strspn(str," \t");
  left = &str[a];
  
  if (*left == '\'' || *left == '"')
    {
      boundary = *left;
      left++;
    }
  else
    boundary = '\0';

  if (boundary)
    {
      p = left;
      while (1)
        {
          p = strchr(p,boundary);
          if (p == NULL)
            {
              len = strlen(left);
              break;
            }
          else if (p[-1] != '\\')
            {
              p++;
              continue;
            }
          len = left - p - 1;
        }
      p++;
    }
  else
    len = strcspn(left," \t");
  printf("\"%.*s\"\n",(int) len, left);

  return 0;
}
