# JupyterHub Utility Scripts
## Motivation
This repository provides bash scripts to easily administrate a JupyterHub server (TLJH included).

## List of scripts:

**empty-user-folder.sh**


* This script removes the content of all jupyterhub users' folders that match the specified pattern.
  
* Syntax:
```
./empty-user-folder.sh <PATTERN>
```

* Example: `./empty-user-folder.sh test` will empty all folders whose name contain the word `test`.
* Notes:
  * The script doesn't delete the Linux user associated to the the folder, nor the user stored in the Jupyterhub.sqlite database.
  * To run the script first do `chmod +x empty-user-folders.sh` and then `./empty-user-folder.sh <PATTERN>` from the `/home` folder.


**delete-user-from-system.sh**

*  This script completely deletes a JupyterHub user from the command line according to a specified pattern. This includes the deletion of:
    * The records related to the user in the `jupyterhub.sqlite` database.
    * The linux account of the user showed in `/etc/passwd`.
    * The `/home` folder of the user and all its content.

* Syntax: 
```
./delete-user-from-system.sh <HOST> <JUPYTERHUB_TOKEN> <PATTERN>
```
* Meaning of each argument:
    * <HOST> is the JupyterHub URL.
    * <PATTERN> indicates which users have to be deleted.
    * <TOKEN> is a token generated on JupyterHub to interact with the API.
* Example: `./delete-user-from-system.sh 127.0.0.1 16eae6dda3a44245b4e30e97b789fcu5 test` will completely delete from the system all users whose name contain the word `test`.


  
