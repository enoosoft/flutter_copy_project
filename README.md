# Flutter copy project


>Copy whole project to another. Enter the conversion keyword to convert it.
<br>
<br>
## How to copy flutter project
---
**1. get this project to your folder**
```
git clone "https://github.com/enoosoft/flutter_copy_project.git"
```
<br>

**2. Run fcpy.dart in root directory with arguments**
```
dart bin/fcpy.dart --converter to-be.txt --source C:\Sync\Works\smmy --destination C:\Sync\Works\dmmy
```
<br>

 - **Arguments**

Arguments|Example|Description
|--|--|--|
converter|`to-be.txt`|Define conversion rules
source|C:\your\workspace\existing_project|Source template project folder
destination|C:\your\workspace\new_project|New project folder to create
<br>

- **How converter(`to-be.txt`) file wors**

Basically, replace the keyword contained in the source file.<br> 
Conversion rules are expressed as `before` -> `after`<br> 
Define conversion rules what ever you need.<br> 
eg. **`package name`**, **`app name`**, **`package directory`**, **`Admob IDs`**, etc.

```
# package name
com.example.smmy->com.example.dmmy

# app name
smmy -> dmmy

# package directory(windows) 
# start with slash and do not end with slash  
\com\example\smmy->\com\example\dmmy

# package directory(linux) 
# start with slash and do not end with slash
#/com/example/smmy->/com/example/dmmy

# Admob IDs
ca-app-pub-ADMOBaXXX~XXXXXXXXXXXX->ca-app-pub-ad_app_id~XXXXXXXXXXXX
ca-app-pub-ADMOBbXXX/XXXXXXXXXXXX->ca-app-pub-ad_banner_id~XXXXXXXXXXXX
ca-app-pub-ADMOBcXXX/XXXXXXXXXXXX->ca-app-pub-ad_intstl_id~XXXXXXXXXXXX
 ```
`package directory` converts and creates a folder structure that creates a directory with a package name, such as `Java`, `Kotlin`.

## Updates
---

* 0.0.1 
  * Create project 2021-08-22


## About
---

* Developer: EnooSoft
* Email: [as.enoosoft@gmail.com](mailto:as.enoosoft@gmail.com)
* Last modify: 2021-08-22