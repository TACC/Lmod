/*

 Lmod is licensed under the terms of the MIT license reproduced below.
 This means that Lmod is free software and can be used for both academic
 and commercial purposes at absolutely no cost.

 ----------------------------------------------------------------------

 Copyright (C) 2014 Frederik Delaere

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject
 to the following conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

 ----------------------------------------------------------------------


module_output_redirect:

use this alias:
alias module 'eval `/path/to/module_output_redirect $LMOD_CMD csh \!*` '
don't add a ';' at the end of this alias, or it will be broken

captures lmod's stderr output and prints it to stdout instead

to build: cd to the folder of this file and type:
make mor

known bugs: 
    - when redirecting the output to a file, the echo statements are printed, not the raw output
*/

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_BUFFER      512
#define MAX_COL_DIGITS  5

char *stdout_buf = NULL;
char *stderr_buf = NULL;
char *tmp_buf	 = NULL;

// from: http://creativeandcritical.net/str-replace-c/
// credits go to: Laird Shaw, with assistance from comp.lang.c
char *replace_str(const char *str, const char *old, const char *new) {
    char *ret, *r;
    const char *p, *q;
    size_t oldlen = strlen(old);
    size_t count, retlen, newlen = strlen(new);

    if (oldlen != newlen) {
        for (count = 0, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen)
            count++;
        /* this is undefined if p - str > PTRDIFF_MAX */
        retlen = p - str + strlen(p) + count * (newlen - oldlen);
    } else {
        retlen = strlen(str);
    }

    if ((ret = malloc(retlen + 1)) == NULL) {
        return NULL;
    }

    for (r = ret, p = str; (q = strstr(p, old)) != NULL; p = q + oldlen) {
        /* this is undefined if q - p > PTRDIFF_MAX */
        ptrdiff_t l = q - p;
        memcpy(r, p, l);
        r += l;
        memcpy(r, new, newlen);
        r += newlen;
    }

    strcpy(r, p);

    return ret;
}

void mor(char *args[]) {

    int stdout_fp[2];
    int stderr_fp[2];

    char buffer[MAX_BUFFER];

    pid_t pid;

    memset(buffer, 0, MAX_BUFFER);

    if (pipe(stdout_fp) == -1) {
        perror("Error with stdout pipe: ");
        exit(1);
    }

    if (pipe(stderr_fp) == -1) {
        perror("Error with stderr pipe: ");
        exit(1);
    }

    pid = fork();
    if (pid == -1) {
        perror("Error while trying to fork: ");
        exit(1);
    } else if (pid == 0) {

        while ((dup2(stdout_fp[1], STDOUT_FILENO) == -1) && (errno == EINTR)) {}
        while ((dup2(stderr_fp[1], STDERR_FILENO) == -1) && (errno == EINTR)) {}

        close(stdout_fp[1]);
        close(stdout_fp[0]);
        close(stderr_fp[1]);
        close(stderr_fp[0]);

        execv(args[0], args);
        perror("Error while executing execv: ");
        _exit(1);
    }

    close(stdout_fp[1]);
    close(stderr_fp[1]);

    // now read stdout from our child process
    while (1) {
        ssize_t count;
        memset(buffer, 0, MAX_BUFFER);
        count = read(stdout_fp[0], buffer, sizeof(buffer));
        buffer[count] = '\0';
        
        if (count == -1) {
            if (errno == EINTR) {
                continue;
            } else {
                perror("Errow while trying to read stdout from child: ");
                exit(1);
            }
        } else if (count == 0) {
            break;
        } else {
            stdout_buf = realloc(stdout_buf, strlen(stdout_buf) + strlen(buffer)+ sizeof(char));
            strcat(stdout_buf, buffer);
        }
    }

    close(stdout_fp[0]);

    // now read stderr from our child process
    while (1) {
        ssize_t count;
        memset(buffer, 0, MAX_BUFFER);
        count = read(stderr_fp[0], buffer, sizeof(buffer));
        buffer[count] = '\0';
        
        if (count == -1) {
            if (errno == EINTR) {
                continue;
            } else {
                perror("Errow while trying to read stderr from child: ");
                exit(1);
            }
        } else if (count == 0) {
            break;
        } else {
            stderr_buf = realloc(stderr_buf, strlen(stderr_buf) + strlen(buffer)+ sizeof(char));
            strcat(stderr_buf, buffer);
        }
    }

    close(stderr_fp[0]);

    wait(0);
}

int main(int argc, char *argv[]) {
    struct winsize w;
    char cols[MAX_COL_DIGITS];
    char **args;
    int i = 0;

    if (argc <= 1) {
        return 1;
    }

    memset(cols, 0, sizeof(cols));

    stdout_buf = calloc(1, sizeof(stdout_buf));
    stderr_buf = calloc(1, sizeof(stderr_buf));

    // get terminal size
    ioctl(STDERR_FILENO, TIOCGWINSZ, &w);

    // let lmod know what our terminal size is
    sprintf(cols, "%d", w.ws_col);
    setenv("LMOD_TERM_WIDTH", cols, 1); 

    // copy our args to feed them into execv
    args = malloc(sizeof *args * (argc + 1));

    for (i = 0; i < argc; ++i) {
        args[i] = argv[i+1];
    }

    // null terminate our args array, for execv
    args[argc] = NULL;

    // run the modules command and catch stdout and stderr
    mor(args);

    // now we have to quote spaces, " and newlines need to be escaped too
    // to prevent memory leaks we have to do some copy, realloc and free'ing

    tmp_buf = replace_str(stderr_buf, "\"", "\"'\"'\"");


    stderr_buf = realloc(stderr_buf, strlen(tmp_buf)+1);
    strcpy(stderr_buf, tmp_buf);
    free(tmp_buf);

    tmp_buf = replace_str(stderr_buf, " ", "\" \"");


    stderr_buf = realloc(stderr_buf, strlen(tmp_buf)+1);
    strcpy(stderr_buf, tmp_buf);
    free(tmp_buf);

    tmp_buf = replace_str(stderr_buf, "\n", "\\n");


    stderr_buf = realloc(stderr_buf, strlen(tmp_buf)+1);
    strcpy(stderr_buf, tmp_buf);
    free(tmp_buf);

    printf("%s\n", stdout_buf);
    printf("echo \"%s\";\n", stderr_buf);

    // cleanup
    free(args);
    free(stdout_buf);
    free(stderr_buf);

    return 0;
}
