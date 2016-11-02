
drop table pseudo_seq purge;

create table pseudo_seq ( myseq number(12) not null);

create index pseudo_seq_pk_idx on pseudo_seq(myseq);

alter table pseudo_seq add constraint pseudo_seq_pk primary key(myseq);

-- there will never be more than 1 row in this table
insert into pseudo_seq values(1);

commit;



