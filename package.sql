

create or replace package pseudo_sequence
is

	think_time number(5,3) := 0.1 ; -- simulate a static think time - incoming from app server
	xaction_time number(5,4) := 0.05 ; -- short time spent processing
	iterations pls_integer := 300;

	--procedure seq_lock;

	function unlock return number;

	--procedure xact;

	procedure do_work;

end;
/

show error package pseudo_sequence


create or replace package body pseudo_sequence
is

	procedure seq_lock
	is 
	begin
		update pseudo_seq set myseq = myseq + 0;	
	end;

	-- updates the sequence, performs the commit and returns the sequence value
	function unlock return number
	is
		next_seq pseudo_seq.myseq%type;
	begin
		update pseudo_seq set myseq = myseq + 1 returning myseq into next_seq;
		commit;
		return next_seq;
	end;

	procedure xact
	is
		next_seq pseudo_seq.myseq%type;
	begin
		dbms_lock.sleep(think_time);
		seq_lock;
		dbms_lock.sleep(xaction_time);
		next_seq := unlock;
	end;

	procedure do_work
	is
	begin
		for i in 1..iterations
		loop
				xact;
		end loop;
				
	end;
end;
/

show error package body pseudo_sequence



