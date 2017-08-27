/* $Header$ ver: 1.0  Author: Aaron.song  Created Date: 2017/8/21
   Name: orahr_org_api
   File: D:\Song\Github\Aaron24-song\oracle\oramail
   Description:  
   
   Modified History
   ----------------------------------------------------------------------------
   Date       Author          Description
   ----------------------------------------------------------------------------
   2017/8/21  Aaron.song      Created.
   */

-- Type email recipitent address list.
create or replace type oraemailAddress_rec as object (email varchar2(256));
create or replace type orasmtpRcpt_tb as table of oraemailAddress_rec;

-- Type for email attachments.
create or replace type oraemailAttach_rec as object (file_name varchar2(30), file_type varchar2(30), contents blob, file_length number);
create or replace type oraemailAttach_tb as table of oraemailAttach_rec;

