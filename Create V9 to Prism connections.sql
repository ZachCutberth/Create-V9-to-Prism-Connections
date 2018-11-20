declare 
  address varchar2(100);
  sid number(19);
  remote_sid number(19);
  tenant_sid number(19);  
  rem_con_sid number(19);
  i integer;
begin
  select c.sid, c.tenant_sid, c.address
    into sid, tenant_sid, address
  from rps.controller c
  where c.active = 1;
  
  for i in 1..60 loop -- Change the numbers in this loop to define how many you want to create
              
    select rps.getsid into 
           remote_sid 
    from dual;
    
    select rps.getsid into 
           rem_con_sid 
    from dual;
    
    insert into rps.controller (sid, created_by, created_datetime, post_date, origin_application, 
      row_version, controller_sid, tenant_sid, active, controller_type, controller_no, address, controller_name, poa_controller_sid)    
      values (remote_sid, 'sysadmin', sysdate, sysdate, 'TestScript', 1, sid, tenant_sid, 0, 2, i+1, 'Store-' || to_char(i), 
      'Store ' || to_char(i), sid);
    
    insert into drs.remote_connection  (sid, created_by, created_datetime,  post_date, origin_application, 
      row_version, connection_name, active, connection_type, remote_address, local_address, subscriber_id)    
      values (rem_con_sid, 'sysadmin', sysdate, sysdate, 'TestScript', 1, address || '<==>Store-' || to_char(i), 1, 1, 'Store-' || to_char(i), address, i);
      
    insert into drs.replication_sub_connection  (sid, created_by, created_datetime,  post_date, origin_application, 
      row_version, remote_connection_sid, replication_subscription_sid)    
      values (rps.getsid, 'sysadmin', sysdate, sysdate, 'TestScript', 1, rem_con_sid, 421139819000119255);
      
  end loop;
  
  commit;      
  
end;
