create or replace package oramail is
/* $Header$ ver: 1.0  Author: Aaron.song  Created Date: 2017/8/21
   Name: orahr_org_api
   File: D:\Song\Work\AI\8.Program\oramail.pck
   Description:  
   
   Modified History
   ----------------------------------------------------------------------------
   Date       Author          Description
   ----------------------------------------------------------------------------
   2017/8/21  Aaron.song      Created.
   */

  -- debug switch.
  debug         number       := 0;
  
  -- Type and function for email recipitent address list.
  -- create or replace type oraemailAddress_rec as object (email varchar2(256));
  -- create or replace type orasmtpRcpt_tb as table of oraemailAddress_rec;
  function splitrcpt(p_rcpt clob, p_delimiter varchar2 default ';') return orasmtpRcpt_tb pipelined;
  
  -- Type and function for email attachments.
  -- create or replace type oraemailAttach_rec as object (file_name varchar2(30), file_type varchar2(30), contents blob, file_length number);
  -- create or replace type oraemailAttach_tb as table of oraemailAttach_rec;
  --procedure writeAtachment(p_attachments in oraemailAttach_tb);
  --gv_email_attachments    oraemailAttach_tb;
  attachments   oraemailAttach_tb := oraemailAttach_tb();
  
  --
  ------------------------------
  -- procedure: sendMail
  ------------------------------
  procedure sendMail(
                p_sender          in varchar2
               ,p_recipient       in clob
               ,p_subject         in varchar2
               ,p_body            in clob
               ,p_body_html       in clob default null
               ,p_cc              in clob default null
               ,p_bcc             in clob default null
               );
               
  --
  -----------------------------
  -- procedure: addAttachment
  -----------------------------
  procedure addAttachment(
                dir               in varchar2
               ,filename          in varchar2
               ,filetype          in varchar2
               );
  procedure addAttachment(
                b_lob             in blob
               ,filename          in varchar2
               ,filetype          in varchar2
               );

end oramail;
/
create or replace package body oramail is
  
  --
  -------------------------------
  -- Global Variable
  -------------------------------
  smtp_host     varchar2(30) := 'localhost';
  smtp_port     varchar2(5)  := '25';
  conn          utl_smtp.connection;
  boundary      constant varchar2(256) := '----=_NextPart_000.``oraMAIL``';
  alternative   constant varchar2(256) := '----=_NextPart_001.``oraMAIL``';
  crlf          varchar2(10) := utl_tcp.crlf;
  charset       varchar2(10) := 'utf-8';
  --
  --attachments   oraemailAttach_tb := oraemailAttach_tb();
  l_temp        varchar2(32767) default null;
  
  --
  -------------------------------
  -- procedure writeOuput
  -------------------------------
  procedure writeOutput(text in varchar2) is
  begin
    if debug=1 then
      dbms_output.put_line(text);
    end if;
  end;
  
  --
  -------------------------------
  -- Function: splitrcpt
  -------------------------------
  function splitrcpt(p_rcpt clob, p_delimiter varchar2 default ';') return orasmtpRcpt_tb pipelined is
    v_idx       integer;
    v_str       varchar2(256);
    v_strs_last varchar2(2000) := p_rcpt;
  begin
    loop
      v_idx := instr(v_strs_last, p_delimiter);
      exit when v_idx = 0;
      v_str       := substr(v_strs_last, 1, v_idx - 1);
      v_strs_last := substr(v_strs_last, v_idx + 1);
      pipe row(oraemailAddress_rec(email => v_str));
    end loop;
    pipe row(oraemailAddress_rec(email => v_strs_last));
    return;
  end;
  
  --
  -------------------------------
  -- Function: splitrcpt
  -------------------------------
  procedure writeAtachment is
    cursor cur_attachs is select * from table(attachments);
    l_temp      varchar2(32767) default null;
    l_offset    number := 1;
    l_ammount   number := 57;
    l_file_len  number;
  begin
    for f1 in cur_attachs loop
      l_file_len := dbms_lob.getlength(f1.contents); 
      if l_file_len > 0 then
        l_temp := '';
        l_temp := l_temp || crlf || '--' || boundary || crlf;
        l_temp := l_temp ||  'Content-Type:' || f1.file_type || '; name="' || f1.file_name || '"' || crlf;
        l_temp := l_temp ||  'Content-Transfer-Encoding: base64' || crlf;
        --l_temp := l_temp ||  'Content-Description: ' || f1.file_name || crlf;
        l_temp := l_temp ||  'Content-Disposition: attachment; filename="' || f1.file_name || '"' || crlf || crlf;
        utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
        writeOutput(l_temp);
        --
        l_offset := 1;
        while l_offset < dbms_lob.getlength(f1.contents) loop 
          l_temp := dbms_lob.substr(f1.contents,l_ammount,l_offset); 
          l_offset := l_offset + l_ammount; 
          l_ammount := least(57,dbms_lob.getlength(f1.contents) - l_ammount); 
          utl_smtp.write_raw_data(conn,utl_encode.base64_encode(l_temp));
          --utl_smtp.write_raw_data(conn,l_temp);
          writeOutput(l_temp);
        end loop;
        l_temp := crlf || crlf;
        utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
        writeOutput(l_temp);
      end if;
    end loop;
  end;
  
  --
  -----------------------------
  -- procedure writeMailPart
  -----------------------------
  procedure writeMailPart(
                p_mime            in varchar2
               ,p_body            in clob
               )
  is
    l_temp      varchar2(32767) default null;
    l_offset    number := 1;
    l_ammount   number := 1900;
  begin
    l_temp := '';
    l_temp := l_temp || crlf || '--' || alternative || crlf;
    l_temp := l_temp ||  'Content-Type:' || p_mime || '; charset=' || charset || crlf  || crlf;
    utl_smtp.write_data(conn,l_temp);
    writeOutput(l_temp);
    while l_offset < dbms_lob.getlength(p_body) loop 
      l_temp := dbms_lob.substr(p_body,l_ammount,l_offset); 
      l_offset := l_offset + l_ammount; 
      l_ammount := least(1900,dbms_lob.getlength(p_body) - l_ammount); 
      utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
      writeOutput(l_temp);
    end loop; 
    l_temp := crlf || crlf;
    utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
    writeOutput(l_temp);
  end;
  
  -- Multipart mail, attatchement
  procedure sendMail(
                p_sender          in varchar2
               ,p_recipient       in clob
               ,p_subject         in varchar2
               ,p_body            in clob
               ,p_body_html       in clob default null
               ,p_cc              in clob default null
               ,p_bcc             in clob default null
               )
  is
    --
    cursor cur_rcpts(p_rcpt in clob, p_delimiter in varchar2) is
      select distinct email from table(splitrcpt(p_rcpt, p_delimiter));
      
  begin
    -- create connection
    conn := utl_smtp.open_connection(smtp_host, smtp_port);
    utl_smtp.helo(conn, smtp_host);
    utl_smtp.mail(conn, p_sender);
    -- add recipitent
    for c1 in cur_rcpts(p_recipient,';') loop
      utl_smtp.rcpt(conn, trim(c1.email)); --dbms_output.put_line(c1.email);
    end loop;
    --
    utl_smtp.open_data(conn);
    
    -- Headers
    l_temp := '';
    l_temp := l_temp || 'From: '    || p_sender    || crlf;
    l_temp := l_temp || 'To: '      || p_recipient || crlf;
    l_temp := l_temp || 'Subject: ' || p_subject   || crlf;   
    l_temp := l_temp || 'Date: '    || to_char(SYSDATE, 'dd Mon yyyy hh24:mi:ss') || crlf;
    if p_cc is not null then
       l_temp := l_temp || 'CC: '   || p_recipient || crlf;
    end if;
    if p_bcc is not null then
       l_temp := l_temp || 'BCC: '  || p_recipient || crlf;
    end if;
    l_temp := l_temp || 'MIME-Version: 1.0' || crlf;
    l_temp := l_temp || 'Content-Type:multipart/mixed; boundary="' || boundary || '"' || crlf;
    l_temp := l_temp || 'X-Mailer: Oracle utl_smtp' || crlf;
    l_temp := l_temp || 'Content-Language: zh-cn'   || crlf || crlf;
    l_temp := l_temp || 'This is a multipart message in MIME format.' || crlf || crlf;
    l_temp := l_temp || '--' || boundary || crlf;
    l_temp := l_temp || 'Content-Type: multipart/alternative; boundary="' || alternative || '"' || crlf || crlf;
    utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
    writeOutput(l_temp);
    
    -- Body for text
    writeMailPart(
                p_mime       => 'text/plain'
               ,p_body       => p_body
               );
    -- Body for html
    if dbms_lob.getlength(p_body_html)>0 then
      writeMailPart(
                p_mime       => 'text/html'
               ,p_body       => p_body_html
               );
    end if;
    -- Body end
    l_temp := '--' || alternative || '--' || crlf || crlf;
    utl_smtp.write_data(conn,l_temp);
    writeOutput(l_temp);

    --
    writeAtachment;
    
    -- final html boundary 
    l_temp := '';
    l_temp := l_temp || crlf ||  '--' || boundary || '--' || crlf; 
    utl_smtp.write_raw_data(conn,utl_raw.cast_to_raw(l_temp));
    writeOutput(l_temp);

    --
    utl_smtp.close_data(conn);
    utl_smtp.quit(conn);
  end;
  
  --
  -----------------------------
  -- procedure: addAttachment
  -----------------------------
  procedure addAttachment(
                dir               in varchar2
               ,filename          in varchar2
               ,filetype          in varchar2
               )
  is
    f_lob         bfile;
    b_lob         blob;
  begin
    dbms_lob.createtemporary(b_lob,false);
    f_lob := bfilename(dir,filename);
    dbms_lob.fileopen(f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(b_lob, f_lob, dbms_lob.getlength(f_lob));
    dbms_lob.fileclose(f_lob);
    addAttachment(b_lob,filename,filetype);
  end;
  --
  procedure addAttachment(
                b_lob             in blob
               ,filename          in varchar2
               ,filetype          in varchar2
               )
  is
    l_attach_row  oraemailAttach_rec;
  begin
    l_attach_row := oraemailAttach_rec(
                file_name      => filename
               ,file_type      => filetype
               ,contents       => empty_blob()
               ,file_length    => 0
               );
    l_attach_row.contents := b_lob;
    l_attach_row.file_length := dbms_lob.getlength(b_lob);
    attachments.extend;
    attachments(attachments.last) := l_attach_row;
  end;
  
end oramail;
/
