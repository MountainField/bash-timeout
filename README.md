Bash Timeout
============

[bash-timeout](https://github.ibm.com/NOGAYAMA/bash-timeout) is a command and also a bash function in order to terminate the target command if the target command does not finish within the duration specified beforehand. 
The input via either redirection ( < FILE ) or pipe ( | ) are transferred to the target command transparently.
The exit status of the target command is retained if the target command finishes within the duration.

The [timeout](https://www.gnu.org/software/coreutils/manual/html_node/timeout-invocation.html) in GNU coreutils is a similar command which has the timeout capability.
In shell script, bash-timeout make the script simpler than GNU timeout.
See [comparison.md](docs/comparison.md) for more details.

Usage
-----

- Use as a linux/unix command

    ```bash
    $ bash-timeout 10s sleep 20s
    ```

- Use as a bash function

    ```bash
    source bash-timeout
    timeout 10s sleep 20s
    ```

- An example in bash script

    ```bash
    source bash-timeout
    
    function very_expensive_task() {
        ...
    }
    
    if timeout 10s  very_expensive_task  ; then
        echo "successfully done"
    else
        echo "the task failed or timed out"
    fi
    ```

Getting started
----------------

### Prerequisites

- `bash` command (version 3 or later)
- `sleep` command
- `pkill` command
- `ps` command

### Installing

- Install via yum
    
    1. Download repository definition
        
        ```bash
        $ sudo curl -kL -o /etc/repos.d/bash-timeout.repo  https://github.com/nogayama/bash-timeout/master/bash-timeout.repo
        ```
    
    2. Do yum command
    
        ```bash
        $ sudo yum install bash-timeout
        ```

- Install via rpm

    1. Do rpm command

        ```bash
        $ sudo rpm -ivh https://github.com/nogayama/bash-timeout/master/bash-timeout.rpm
        ```

- Install executable directory

    1. Copy executable to directory included in `$PATH` environmental variable

        ```bash
        $ curl -kL -o /usr/local/bin/bash-timeout  https://github.com/nogayama/bash-timeout/master/bin/bash-timeout
        $ chmod +x /usr/local/bin/bash-timeout
        ```

Characteristics
---------------

1. Status code
    
    1. Return error code if time out

        ```bash
        $ bash-timeout 10s sleep 20s
        $ echo $? #=> 1 or more 
        ```

    2. Retain the target command status code if the target command finishes within the duration

        1. Normal exit
            
            ```bash
            $ bash-timeout 10s ls /bin
            $ echo $? #=> 0
            ```

        2. Exit with error
            
            ```bash
            $ ls /FOOBAR
            $ echo $? #=> 2
            ```
            
            ```bash
            $ bash-timeout 10s ls /FOOBAR
            $ echo $? #=> 2
            ```

2. Input and Output

    - Retain output

        ```bash
        $ echo abc #=> abc 
        ```

        ```bash
        $ bash-timeout 10s echo abc #=> abc 
        ```

    - Retain input via pipe

        ```bash
        $ echo abc | cat #=> abc 
        ```
    
        ```bash
        $ echo abc | bash-timeout 10s cat #=> abc 
        ```

    - Retain input via redirection

        ```bash
        $ echo abc > abc.txt
        $ cat < abc.txt  #=> abc 
        $ < abc.txt cat  #=> abc 
        ```
    
        ```bash
        $ bash-timeout 10s cat < abc.txt  #=> abc 
        $ bash-timeout < abc.txt 10s cat  #=> abc 
        $ < abc.txt bash-timeout 10s cat  #=> abc 
        ```

Author
------

* **Takahide Nogayama** - [Nogayama](https://github.com/nogayama)

License
-------

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details

## Contributing

Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

Acknowledgments
---------------

We express our sincere thanks to Scott Trent for reviewing documents.

