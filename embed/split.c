#include <stdio.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char* argv[])
{
  const char* cmd = "   /opt/apps/lmod/lmod/libexec/RC2lua.tcl  -F   -a 'foo:bar:baz' \t -b bar amber/9";

  char boundary;
  const char* left;

  const char* p = cmd;
  size_t len, a, b;

  a    = strspn(p," \t");
  p   += a;
  left = p;
  len  = strcspn(left, " \t");
  printf("cmd_name: \"%.*s\"\n",len,left);
  p   += len;
  a    = strspn(p," \t");
  p   += a;
  left = p;

  while (*p)
    {
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
              else if (p[-1] == '\\')
                {
                  p++;
                  continue;
                }
              len = p - left;
              break;
            }
          p++;
        }
      else
        {
          len = strcspn(left," \t");
          p   += len;
        }
      printf("\"%.*s\"\n",(int) len, left);
      a    = strspn(p," \t");
      p   += a;
      left = p;
  
    }

  return 0;
}
