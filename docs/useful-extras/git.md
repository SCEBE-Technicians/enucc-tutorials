# Using git

## Description

This tutorial will outline the basics of using git.

---

## Prerequisites

None.

---

Git is a general purpose tool for tracking changes in a filesystem and for collaboratively working with others. There are a few ways to use git, some more complicated than others. In this tutorial we'll first look at using git for a project on which you are the only person making changes. In this scenario git is useful for tracking changes and also for keeping a remote copy of your work as a backup. After we become comfortable working alone with git, we'll look at using git to collaborate with others.

Before we get started I want to cover a few bits of terminology which are frequently used.

- git: git is the name of the tool used for version control.
- Repository: all of your project files, along with your git history and data.
- GitHub: a website which allows you to host a copy of your repository on their servers.
- Commit: a snapshot of your project files

To get started you can follow the instructions on github to [create a new repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository). Once you've created a repository, which is stored on github's servers, you can clone the repository to have a copy on your own machine.

```
$ git clone git@github.com:SCEBE-Technicians/<repository-name>.git
```

You can then make changes or create new files in the repository. Once you are happy with the changes made, we will want to make a commit. You can think of a commit as a snapshot of your project. Committing your changes happens in two parts - first you add the changed files you want to be included in the commit to the staging area, then you create the commit from the files in the staging area.

```
$ git add file1 file2 file3
$ git commit -m "Create file2 and file3 and change file1"
```

The changes will not be visible on the remote repository (on github) yet, because we've only made the changes locally. In order to sync the remote repository with our local repository, we have to push the changes. 

```
$ git push
```

### Working with others

So far, everything we've done has been on the main branch.

## Useful resources

- If you are looking to get deep into what git can really do and how it works then I'd recommend reading [pro git](https://git-scm.com/book/en/v2). It's freely available online and is one of the best resources there is.

