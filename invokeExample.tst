PL/SQL Developer Test script 3.0
46
declare
  l_lob blob;
begin
  -- 1.on/0.off debug.
  oramail.debug := 0;
  -- init attachment table type.
  oramail.attachments := oraemailAttach_tb();
  -- add attachment base oracle directory.
  oramail.addAttachment('DATA_PUMP_DIR','dp.log','text/plain');
  oramail.addAttachment('EXPDIR','1.sh','application/excel');
  oramail.addAttachment('EXPDIR','export.log','text/plain');
  
  -- add attachement from table's blob filed.
  for c1 in (select * from orasalq_imgs) loop
    oramail.addAttachment(
                 b_lob      => c1.img
                ,filename   => c1.code||'.jpg'
                ,filetype   => 'images/jpg'
                );
  end loop;
  
  -- Call the procedure
  oramail.sendmail(
                p_sender    => :p_sender
               ,p_recipient => 'user1@example.com;user2@example.com'
               ,p_subject   => :p_subject
               ,p_body      => 'This is a example.'
               ,p_body_html => '
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>This is a example</title>
    <style>
      ...
  </style>
  </head>
  <body>
    <p>This is a Oracle utl_smtp mail client test.</a>
  </body>
</html>
'              ,p_cc        => :p_cc
               ,p_bcc       => :p_bcc
               );
end;
8
p_sender
1
﻿sender@example.com
5
p_recipient
1
<CLOB>
-112
p_subject
1
﻿This is a example
5
p_body
1
<CLOB>
-112
p_body_html
1
<CLOB>
-112
p_cc
1
<CLOB>
112
p_bcc
1
<CLOB>
112
p_body_htm
0
-5
0
