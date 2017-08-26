Description
===========

This is a plsql mailer building from oracle utl_smtp.

Features on v1.0

* Add multi-attachments from table's blob filed or file base oracle database directory.
* Single sendmail program.


Installition
=====================

* First, you must create type the main program used in createType.sql;
* Using sqlplus excute follow command:
  
  			[oracle@hostname ~]$ sqlplus /nolog
  			SQL> connect <schema you want to install to>/<password>
  			SQL> @oramail.pck


Invoke example
===================

Referent invokeExample.sql.


License and Authors
===================

* Author:: Aaron24.song <aaron24.song@starspacetech.com>  
