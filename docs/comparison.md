
What is the difference between GNU coreutils `timeout` command?
-------------------------------------------------

The `timeout` command is included in the `coreutils` package.
It can do the same thing as bash-timeout.

```bash
$ sudo yum install coreutils
$ /usr/bin/timeout 10s sleep 20
```

But if we run a bash function with the coreutils `timeout` in a shell script, we will get the error 'No such file or directory'.

```bash
function myfunc() {
    # a long running function
}

/usr/bin/timeout 10s myfunc #=> Error
timeout: failed to run command ‘b’: No such file or directory
```

We can solve this issue by exporting the bash function, and execute the function in bash command.

```bash
function myfunc() {
    # a long running function
}
export -f myfunc

/usr/bin/timeout 10s bash -c "myfunc" #=> success
```

But if we define some bash functions and one calls another, The error 'command not found' arises from bash command.

```bash
function myfunc0() {
    ...
}
function myfunc() {
    ...
    myfunc0
}
export -f myfunc

/usr/bin/timeout 10s bash -c "myfunc" #=> Error
environment: line 1: myfunc0: command not found
```

To solve this, we have to export all bash functions and replace all lines that invoke the bash function to invoke via bash command.
This solution is not realistic because we cannot check all dependent bash functions defined in other bash script files.

```bash
function myfunc0() {
    ...
}
export -f myfunc0

function myfunc() {
    ...
    bash -c "myfunc0"
}
export -f myfunc

/usr/bin/timeout 10s bash -c "myfunc" #=> works
```

If we use the bash-function in the same situation, we do not have to change existing code.
Just import the `bash-timeout` to the current shell, and run any bash function via the `timeout` function.

```bash
function myfunc0() {
    ...
}
function myfunc() {
    ...
    myfunc0
}

source bash-timeout
timeout 10s myfunc #=> works
```
