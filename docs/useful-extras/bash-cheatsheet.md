#Bash Cheatsheet

This page contains an overview of some of the most commonly used bash commands. Every bash command consists of a name which you type first, followed by a number of arguments. Some arguments start with `-` or `--` which are used to pass flags to the command which change its behaviour.

## Directory management

### `ls`

```bash
ls
ls /path/to/directory
```

Lists the contents of the supplied directory. If no directory is given, it lists the contents of the current working directory.

### `pwd`

```bash
pwd
```

Stands for 'print working directory'. Prints the working directory to the screen.

### `cd`

```bash
cd path/to/directory
```

Stands for change directory. Changes the working directory to the specified path. If no path is given it will change directory to the home directory.

### `mkdir`

```bash
mkdir directory_name
```

Stands for make directory. Creates a new directory called `directory_name`. Note that it is recommended that you **do not use spaces in filenames**.

### `mvdir`
```
mvdir directory_name new_directory_name
```

Stands for move directory. Renames `directory_name` to `new_directory_name`.

### `rmdir`

```
rmdir empty_directory
```

Stands for remove directory. Deletes an empty directory. Once it's deleted, there's no way to get it back and this command won't prompt you before deleting so use with caution.

## Working with files

### `touch`

```
touch filename
```

touch is often used to create a new empty file. If the file already exists then it will update the date modified time to the current time.

### `cp`

```
cp oldfile newfile
```

cp stands for copy. It will copy oldfile to newfile. Note that if newfile already exists then this command will overwrite it and it is impossible to get the overwritten file back.

### `mv`

```
mv oldfile newfile
```
mv stands for move. It is similar to copy, but will delete oldfile. Similarly, if newfile exists it will be permanently overwritten.

### `cat`
```
cat file1
cat file1 file2 file3
```
cat stands for concatenate. If you give it the name of one file, it will print the contents to the terminal. If you give it multiple files it will concatenate the contents together and then print that to the terminal. This is quite useful for inspecting files from the command line.

## More advanced operations

### piping - `|`

Piping allows you to use the output of one command as the input for another. For example, there is a program called wc, meaning word count. If we give it a file, it will print the number of newlines, the number of words and the number of bytes in the file.
```
$ wc file
 3 4 24 file
```
Here there were 3 newlines, 4 words and 24 byes.

We can use this to count the number of files and subdirectories in the current directory by piping the output of `ls` to `wc`.

```
$ ls | wc
 5 5 44
```

### redirecting to a file - `>` and `>>`

The `>` and `>>` commands redirect the output of a command to a file. For example we can save the output of ls to a file.

```
$ ls > ls_output_file
$ cat ls_output_file
bin
copy_projects
ls_output_file
miniconda3
projects
test2
```

`>` creates a new file if it doesn't exist and overwrites a file that does exist. The specified file will only contain the output of the redirected command.

`>>` will append the output to the specified file.

### wildcards - `*`

You can use `*` to work with more than one file, substituting `*` for the changing parts of filenames. Here are some examples.
```
ls *A       # List all files ending in A
ls A*       # List all files starting with A
cp *.txt textfiles/    # Copies all files ending in .txt to the textfiles directory
```

## Others

### `echo`
```
$ echo hello
hello
```
Prints any text after the echo command to the command line. Often used with `>` or `>>` for adding text to files. For example
```
$ echo hello > textfile
$ cat textfile
hello
```

### `sudo`

Stands for superuser do. This is the linux equivalent to running as an administrator. Do not use this unless strictly necessary. You won't have sudo access on ENUCC.

### `.`
Used to refer to the current directory.

```
ls ./
```

### `..`
Used to refer to the directory above

```
$ pwd
/users/username/projects/directory
$ cd ..
$ pwd
/users/username/projects
```

### `$?`
A variable which refers to the exit code of the last run command. Can be used with echo to check whether the last command ran successfully. In general an exit code of 0 is successful and anything else means the program exited with an error.
```
$ ls
$ echo $?
0
$ ls /non/existent/directory
$ echo $?
2
```

### `!!`
Can be used to run the last command again.

### `/dev/null`
A psuedofile which is deleted immediately. Useful for getting rid of noisy output. For example if you want to run a program but don't want to see its output you can redirect it to /dev/null.

```
python noisyprogram.py > /dev/null
```
