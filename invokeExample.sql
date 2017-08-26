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
                p_sender    => 'sender@example.com'
               ,p_recipient => 'user1@example.com;user2@example.com'
               ,p_subject   => 'This is a example'
               ,p_body      => 'Text/plain'
               ,p_body_html => '
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Report Tigle</title>
    <style>
      ...
  </style>
  </head>
  <body>
    ...
  </body>
</html>
'              ,p_cc        => null
               ,p_bcc       => null
               );
end;
/

