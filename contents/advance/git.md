# git 常用命令

###### 参考https://www.liaoxuefeng.com/wiki/896043488029600

## 查看命令

​       git status 

- 要随时掌握工作区的状态，使用`git status`命令。

  git diff

- 如果`git status`告诉你有文件被修改过，用`git diff`可以查看修改内容。

  git reset --hard commit_id

- HEAD`指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令`git reset --hard commit_id`。

  git log

- 穿梭前，用`git log`可以查看提交历史，以便确定要回退到哪个版本。

  git reflog

- 要重返未来，用`git reflog`查看命令历史，以便确定要回到未来的哪个版本。

## 分支操作一

一、添加文件到Git仓库，分两步：

1. 使用命令`git add `，注意，可反复多次使用，添加多个文件；

2. 使用命令`git commit -m `，完成。

   例如： git add readme.txt 

   ​			 git commit -m "add readme.txt"

二、 git checkout -- file  可以丢弃工作区的修改

​	这里有两种情况： 让这个文件回到最近一次`git commit`或`git add`时的状态

​	例如：git checkout -- readme.txt

三、 `git reset`命令既可以回退版本，也可以把暂存区的修改回退到工作区。	当我们用`HEAD`时，表示最新的版本

​	git reset HEAD <file>      例如：git reset HEAD readme.txt

四、命令`git rm`用于删除一个文件

## 分支操作二

查看分支：`git branch`

创建分支：`git branch   ` <name>

切换分支：`git checkout ` <name>

创建+切换分支：`git checkout -b ` <name> 

合并某分支到当前分支：`git merge ` <name>

删除分支：`git branch -d ` <name>

查看远程库信息，使用`git remote -v`；

从远程抓取分支，使用`git pull`，如果有冲突，要先处理冲突。

从本地推送分支，使用`git push origin branch-name`，如果推送失败，先用`git pull`抓取远程的新提交；

# git本地仓库关联远程仓库

要关联一个远程库，使用命令`git remote add origin https://github.com/shareGirl/learngit.git

关联后，使用命令`git push -u origin master`第一次推送master分支的所有内容；

## 配置别名

配置文件放哪了？每个仓库的Git配置文件都放在`.git/config`文件中：

而当前用户的Git配置文件放在用户主目录下的一个隐藏文件`.gitconfig`中

配置别名也可以直接修改这个文件，如果改错了，可以删掉文件重新通过命令配置。

##### 下面是直接在终端执行命令

```
$ git config --global alias.st status
```

```
$ git config --global alias.co checkout
$ git config --global alias.ci commit
$ git config --global alias.br branch
```

以后`st`就表示`status`，`co`表示`checkout`，`ci`表示`commit`，`br`表示`branch`，

​	`--global`参数是全局参数，也就是这些命令在这台电脑的所有Git仓库下都有用。如果不加，那只针对当前的仓库起作用。

把`lg`配置成了：

```
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

   





